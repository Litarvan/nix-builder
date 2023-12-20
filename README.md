# Nix builder image

This image can be used to serve as a Nix remote builder. A SSH server is started automatically, and your SSH public keys
can be fed in arguments.

## Usage

To start a container, simply use:
```bash
docker run --rm -dp 22:22 ghcr.io/litarvan/nix-builder:2.19.2 "$(ssh-add -L)"
```

The first time, register the builder in your Nix configuration:
```bash
mkdir -p ~/.config/nix && cat <<EOF >> ~/.config/nix/nix.conf
builders = ssh://root@127.0.0.1 x86_64-linux
builders-use-substitutes = true
EOF
```

Finally, test the connection (while also registering the host key(s)):
```bash
ssh root@127.0.0.1 nix --version
```