# Derived from: https://github.com/LnL7/nix-docker/blob/master/ssh/Dockerfile

FROM nixos/nix:2.27.1

LABEL org.opencontainers.image.name="nix-builder"
LABEL org.opencontainers.image.authors="Adrien Navratil <id@litarvan.com>, Daiderd Jordan <daiderd@gmail.com>"

# ARM machines does not support seccomp
# Add parallelism configuration for faster builds
RUN echo "filter-syscalls = false" >> /etc/nix/nix.conf && \
    echo "max-jobs = auto" >> /etc/nix/nix.conf && \
    echo "cores = 0" >> /etc/nix/nix.conf && \
    echo "build-cores = 0" >> /etc/nix/nix.conf

RUN nix-env -iA nixpkgs.openssh nixpkgs.gnused && \
    nix-collect-garbage -d

RUN mkdir -p /etc/ssh /var/empty /run /root/.ssh && \
    echo "sshd:x:498:65534::/var/empty:/run/current-system/sw/bin/nologin" >> /etc/passwd && \
    cp /root/.nix-profile/etc/ssh/sshd_config /etc/ssh && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    sed -i "s/root:!:/root:*:/g" /etc/shadow && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N "" -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N "" -t ed25519 && \
    echo "source /root/.nix-profile/etc/profile.d/nix.sh" >> /etc/bashrc && \
    echo "source /etc/bashrc" >> /etc/profile

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
