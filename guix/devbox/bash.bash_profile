
export GUIX_EXTRA_PROFILES=$HOME/.guix-extra-profiles

# Activate extra profiles
if [ -d "$GUIX_EXTRA_PROFILES" ]; then
   for i in $(ls "$GUIX_EXTRA_PROFILES"); do
      profile=$i/$(basename "$i")
        if [ -f "$profile"/etc/profile ]; then
           GUIX_PROFILE="$profile"
           . "$GUIX_PROFILE"/etc/profile
        fi
        unset profile
    done
fi
