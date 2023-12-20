#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $0 <ssh-public-key>"
    exit 1
fi

echo "$1" > /root/.ssh/authorized_keys
/root/.nix-profile/bin/sshd -De