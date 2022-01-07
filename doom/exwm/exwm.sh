#wmname LG3D
#xset -dpms
#xset s off
# xss-lock -- gnome-screensaver-command -l &
#xhost +SI:localuser:$USER
# picom -b --experimental-backends --dbus --config ~/.doom.d/exwm/picom.conf
#exec dbus-launch --exit-with-session emacs -mm --with-exwm --debug-init

gpg-connect-agent /bye
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

exec /usr/bin/startx ~/.doom.d/exwm/exwm.xinitrc >/tmp/startx.log 2>&1
