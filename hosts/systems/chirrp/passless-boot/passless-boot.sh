#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "usage: $0 [/path/to/an/existing_keyfile]"
  echo "   Perform a one-time password-less boot on system with a Luks encrypted root drive"
  echo "   /path/to/an/existing_keyfile is an optional path to a file already configured"
  echo "   to unlock the root drive. It will be used to unlock it and add a \"throw away\" keyfile"
  echo "   if provided. Otherwise you will be prompted for an existing passphrase to do so."
}

existing_keyfile="_NONE"
if [[ $# == 1 ]]; then
  if [[ "$1" == "--help" || "$1" == "-h" || "$1" == "-?" ]]; then
    usage
    exit 0
  fi
  existing_keyfile="$1"
elif [[ $# != 0 ]]; then
  echo "ERROR: wrong number of arguments, should be 0 or 1"
  usage
  exit 2
fi

################
# START SCRIPT #
################
if ! cryptsetup isLuks "$cryptdevice"; then
  echo "❌ the cryptdevice from the kernel commandline, $cryptdevice, is not a Luks encrypted drive."
  exit 20
fi

if [[ -b "$cryptkey_device" ]]; then
  echo "✅ $cryptkey_device is a block device."
else
  echo "❌ $cryptkey_device is not a valid block device."
  exit 20
fi

if findmnt --noheadings --output=TARGET "$cryptkey_device" | grep -q "^/boot$"; then
  echo "✅ cryptkey device $cryptkey_device is mounted on /boot"
else
  echo "⚠  the cryptkey device $cryptkey_device specified on the kernel command line is not mounted at /boot."
  echo "❌ this situation is unexpected and the script will not work. Are you sure your boot drive is mounted properly?"
  exit 60
fi

need_to_add_keyfile="TRUE"
if [[ -e "$keyfile" ]]; then
  echo "✅ $keyfile exists"
  echo -n "🕑 checking validity of $keyfile for unlocking $cryptdevice."
  if cryptsetup --key-file="$keyfile" --test-passphrase open "$cryptdevice"; then
    echo -ne "\r\033[0K\r"
    echo "✅ $keyfile is valid for unlocking of $cryptdevice."
    need_to_add_keyfile="FALSE"
  else
    echo -ne "\r\033[0K\r"
    echo "⚠  $keyfile will not yet unlock $cryptdevice."
  fi
else
  echo -n "🕑 no keyfile at $keyfile, creating a new 256 byte keyfile at $keyfile..." 
  dd if=/dev/random of="$keyfile" bs=256 count=1 status=none
  echo -ne "\r\033[0K\r"
fi

if [[ "$need_to_add_keyfile" == "TRUE" ]]; then
  if [[ "$existing_keyfile" == "_NONE" ]]; then
    echo "⚠  adding keyfile to cryptdevice, please type password..."
    cryptsetup luksAddKey "$cryptdevice" "$keyfile"
  else
    echo -n "🕑 adding keyfile to cryptdevice using existing key $existing_keyfile, please be patient..."
    cryptsetup --key-file "$existing_keyfile" luksAddKey "$cryptdevice" "$keyfile"
  fi

  if cryptsetup --key-file="$keyfile" --test-passphrase open "$cryptdevice"; then
    echo -ne "\r\033[0K\r"
    echo "✅ keyfile $keyfile is now valid for unlocking of $cryptdevice"
  else
    echo -ne "\r\033[0K\r"
    echo "❌ keyfile $keyfile will still not unlock $cryptdevice."
    echo "❌ password-less boot impossible."
    exit 30
  fi
fi

echo "✅ keyfile in place and valid for unlocking root cryptdevice."
echo "✅ password-less boot should be possible."

exit 0
