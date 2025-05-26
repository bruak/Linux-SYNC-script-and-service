#!/bin/bash
# ! this is a development script
# Watches local directory for changes and syncs to remote

REMOTE="root@192.168.1.1"
REMOTE_PATH="/Example/path/to/remote/directory"
LOCAL_PATH="."
PASSWORD="examplePassword"

# Do you have inotify-tools installed? If not, install it
if ! command -v inotifywait &> /dev/null; then
    echo "inotify-tools not found. Installing..."
    sudo apt update && sudo apt install -y inotify-tools

    if ! command -v inotifywait &> /dev/null; then
        echo "Installation failed. Please install manually: sudo apt install inotify-tools"
        exit 1
    fi
fi

# Do you have sshpass installed? If not, install it
if ! command -v sshpass &> /dev/null; then
    echo "sshpass not found. Installing..."
    sudo apt update && sudo apt install -y sshpass

    if ! command -v sshpass &> /dev/null; then
        echo "Installation failed. Please install manually: sudo apt install sshpass"
        exit 1
    fi
fi

echo "Watching local directory... Changes will be automatically sent to the device."
while inotifywait -r -e modify,create,delete "$LOCAL_PATH"; do
    echo "[`date`] Change detected, sending..."
    sshpass -p "$PASSWORD" rsync -avh --delete "$LOCAL_PATH/" "$REMOTE:$REMOTE_PATH"
done

