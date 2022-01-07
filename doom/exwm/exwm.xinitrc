
# Doesn't improve startup aesthetics with a small screen
#xrandr --output eDP-1 --mode 1920x1080 --rate 60.01 --dpi 158 --rotate normal

wmname EXWM

# Disable access control for the current user.
xhost +SI:localuser:$USER

# Load Xresources
#[[ -f ~/.Xresources ]] &&
#xrdb -merge -I$HOME ~/.doom.d/exwm/exwm.xresources

# Make Java applications aware this is a non-reparenting window manager.
export _JAVA_AWT_WM_NONREPARENTING=1
export XMODIFIERS=@im=exwm-xim
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export CLUTTER_IM_MODULE=xim
# Scrolling gtk3 apps won't work, unless GDK_CORE_DEVICE_EVENTS is defined
export GDK_CORE_DEVICE_EVENTS=1
# Try to fix QT scaling, unknown if it does anything
export PLASMA_USE_QT_SCALING=1
# If Emacs is started in server mode, `emacsclient` is a convenient way to
# edit files in place (used by e.g. `git commit`).
export VISUAL=emacsclient
export EDITOR="$VISUAL"
# Force the use of x11 over wayland
export GTK_SCALE=1
export GDK_BACKEND=x11
export CLUTTER_BACKEND=x11
export GDK_DPI_SCALE=1
export MOZ_USE_XINPUT2=1
export MOZ_DISABLE_WAYLAND=1


# Set default cursor.
xsetroot -cursor_name left_ptr

# Set keyboard repeat rate.
xset r rate 200 60
#xset m 5 1

## Finally start Emacs --debug-init
picom -b --experimental-backends --dbus --config ~/.doom.d/exwm/exwm.picom

# Run as a foreground daemon so that it exits when we exit X
#dbus-launch --exit-with-session /usr/bin/emacs --fg-daemon --with-exwm
exec dbus-launch --exit-with-session emacsclient -c

#--debug-init
#exec /usr/bin/emacsclient -c
#-f exwm-enable
#-mm --with-exwm
#exec /usr/bin/emacs --daemon -f exwm-enable
#exec /usr/bin/emacsclient -c

# --debug-init
# --profile spacemacs
# --with-exwm
