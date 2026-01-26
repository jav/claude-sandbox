FROM debian:bookworm-slim

ARG USERNAME=claude
ARG USER_UID=1000
ARG USER_GID=1000

# Install minimal essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && mkdir -p /workspace \
    && chown ${USERNAME}:${USERNAME} /workspace

# Set up home directory
WORKDIR /home/${USERNAME}

USER ${USERNAME}

# Default shell
CMD ["/bin/bash"]
