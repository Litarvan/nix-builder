# Nix Builder Image

This image serves as a Nix remote builder with an automatically started SSH server. You can provide your SSH public keys as arguments.

## Usage

1. **Add SSH Key**: Ensure your SSH key is added using `ssh-add`. Verify that `ssh-add -L` lists your public keys.

2. **Start Container**: Run the container with:
   ```bash
   docker run --rm -dp 22:22 ghcr.io/litarvan/nix-builder:2.27.1 "$(ssh-add -L)"
   ```

3. **Copy SSH Keys**: Make your SSH keys accessible to the root user:
   ```bash
   sudo cp -r ~/.ssh /var/root
   ```

4. **Register Builder**: Add the builder to your Nix configuration:
   ```bash
   mkdir -p ~/.config/nix && cat <<EOF >> ~/.config/nix/nix.conf
   builders = ssh://root@127.0.0.1 aarch64-linux
   builders-use-substitutes = true
   EOF
   ```

5. **Test Connection**: Verify the setup by testing the SSH connection:
   ```bash
   sudo ssh root@127.0.0.1 nix --version
   ```

6. **Trusted User**: Ensure you are a trusted user in your Nix installation. Add your username to `~/.config/nix/nix.conf`:
   ```bash
   extra-trusted-users = <your-username>
   ```

This setup enables you to use the Nix remote builder effectively.
