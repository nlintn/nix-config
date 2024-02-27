{ pkgs, ... }:


pkgs.writeShellScriptBin "rofi-powermenu" ''
  rofi_command="${pkgs.rofi-wayland}/bin/rofi -theme $HOME/.config/rofi/config/powermenu.rasi"

  shutdown=""
  reboot=""
  lock=""
  suspend=""
  logout="󰍃"

  ddir="$HOME/.config/rofi/config"


  # Ask for confirmation
  rdialog () {
  rofi -dmenu\
      -i\
      -no-fixed-num-lines\
      -p "Are You Sure? : "\
      -theme "$ddir/confirm.rasi"
  }

  # Display Help
  show_msg() {
  	rofi -theme "$ddir/askpass.rasi" -e "Options : yes / no / y / n"
  }

  # Variable passed to rofi
  options="$lock\n$suspend\n$logout\n$reboot\n$shutdown"

  chosen="$(echo -e "$options" | $rofi_command -p "UP - uptime" -dmenu -selected-row 0)"
  case $chosen in
      $shutdown)
  		ans=$(rdialog &)
  		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
  			systemctl poweroff
  		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
  			exit
          else
  			show_msg
          fi
          ;;
      $reboot)
  		ans=$(rdialog &)
  		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
  			systemctl reboot
  		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
  			exit
          else
  			show_msg
          fi
          ;;
      $lock)
          swaylock
          ;;
      $suspend)
  		ans=$(rdialog &)
  		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
  			mpc -q pause
  			amixer set Master mute
  			sh $HOME/.local/bin/lock
  			systemctl suspend
  		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
  			exit
          else
  			show_msg
          fi
          ;;
      $logout)
  		ans=$(rdialog &)
  		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
  			bspc quit
  		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
  			exit
          else
  			show_msg
          fi
          ;;
  esac
''
