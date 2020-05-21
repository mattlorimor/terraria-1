#!/bin/sh

# These are the UID and GID that will be used
# for the terraria user by default.
DEFAULT_UID=7777
DEFAULT_GID=7777

UID=${UID:-${DEFAULT_UID}}
GID=${GID:-${DEFAULT_GID}}

# Set the terraria user's UID and GID to the default
# or the user-supplied values.
echo "setting terraria uid/gid $UID/$GID"
usermod terraria -u $UID
groupmod terraria -g $GID

# setting permissions
chown -R terraria:terraria /tshock /world /plugins

# Copy all the plugins in
echo "\nBootstrap:\nconfigpath=$CONFIGPATH\nworldpath=$WORLDPATH\nlogpath=$LOGPATH\n"
echo "Copying plugins..."
su terraria -c "cp -Rfv /plugins/* ./ServerPlugins"

# Start the TerrariaServer.exe as the terraria user
su terraria -c 'mono --server --gc=sgen -O=all TerrariaServer.exe -configPath "$CONFIGPATH" -worldpath "$WORLDPATH" -logpath "$LOGPATH" "$@"'
