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
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with passwordless sudo
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && mkdir -p /workspace \
    && chown ${USERNAME}:${USERNAME} /workspace \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

# Install Node.js and Claude Code
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g @anthropic-ai/claude-code@latest

# Set up home directory
WORKDIR /home/${USERNAME}

# Add bashrc with git-aware prompt
RUN echo '# Git branch and dirty state for prompt\n\
parse_git_branch() {\n\
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)\n\
    if [ -n "$branch" ]; then\n\
        local dirty=""\n\
        [ -n "$(git status --porcelain 2>/dev/null)" ] && dirty="*"\n\
        echo " ($branch$dirty)"\n\
    fi\n\
}\n\
\n\
# Colored prompt: user@host:dir (branch*)$\n\
PS1='"'"'\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\]\$ '"'"'\n\
\n\
# Color support\n\
alias ls="ls --color=auto"\n\
alias grep="grep --color=auto"\n\
' > /home/${USERNAME}/.bashrc \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.bashrc

USER ${USERNAME}

# Default shell
CMD ["/bin/bash"]
