
# Doesn't improve startup aesthetics with a small screen
#xrandr --output eDP-1 --mode 1920x1080 --rate 60.01 --dpi 158 --rotate normal

wmname EXWM

# Disable access control for the current user.
xhost +SI:localuser:$USER
#xhost +

# Load Xresources
#[[ -f ~/.Xresources ]] &&
xrdb -merge -I$HOME ~/.config/exwm/exwm.xresources

# Set default cursor.
xsetroot -cursor_name left_ptr

# Set keyboard repeat rate.
xset r rate 200 60
#xset m 5 1

# Start picom compositor first so we get double-buffering and effects
picom -b --experimental-backends --dbus --config ~/.config/exwm/exwm.picom

# Create a frame with emacsclient
exec dbus-launch --exit-with-session emacsclient -cs server -F '((fullscreen . fullboth))'
