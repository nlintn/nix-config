#!/usr/bin/env bash
set -euo pipefail

failure="FALSE"

if ! [[ -e "$keyfile" ]]; then
  echo "✅ keyfile $keyfile doesn't exist."
else
  echo "🕑 removing $keyfile from its slot in $cryptdevice luks header."
  if cryptsetup luksRemoveKey --key-file="$keyfile" "$cryptdevice"; then
    echo "✅ removed $keyfile to $cryptdevice."
  else
    echo "❌ failed to remove keyfile $keyfile from $cryptdevice"
    keyslot="$(\
      cryptsetup --verbose --key-file="$keyfile" --test-passphrase open "$cryptdevice" |\
      grep "Key slot [0-9] unlocked." | sed 's/Key slot //' | sed 's/ unlocked.//'\
    )"
    if [[ -n "$keyslot" ]]; then
      echo "🕑 removing $keyfile from its slot in $cryptdevice luks header."
      if cryptsetup luksKillSlot "$cryptdevice" "$keyslot"; then
        echo "✅ killed key slot $keyslot on $cryptdevice."
      else
        echo "❌ failed to remove key at slot $keyslot from $cryptdevice"
        echo "☢  the keyfile $keyfile is still valid, occupying slot $keyslot, for $cryptdevice"
        echo "☢  You need to cleanup the header yourself!"
  failure="TRUE"
      fi
    else
      echo "✅ no $keyslot is available for key $keyfile on $cryptdevice."
    fi
  fi

  echo "🕑 shredding $keyfile"
  shred -u "$keyfile"
  if [[ -e "$keyfile" ]]; then
    echo "❌ attempt to erase $keyfile failed."
    exit 10
  fi
  echo "✅ $keyfile erased."
  echo "🕑 running fstrim on $(dirname "$keyfile")"
  fstrim "$(dirname "$keyfile")"
fi

if [[ "$failure" == "TRUE" ]]; then
  echo "☢  FAILED TO REMOVE KEYFILE FROM LUKS HEADER."
  echo "☢  YOU HAVE SOME CLEANUP TO DO!!"
  exit 10
fi
echo "🎉 ALL DONE."

exit 0
