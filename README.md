# claude-sandbox

A minimal, reproducible container environment for running Claude Code in isolation. Designed to be included as a git submodule in other repositories.

## Purpose

- **Security**: Sandbox Claude Code execution from your host system
- **Reproducibility**: Consistent development environment across machines
- **Tool Isolation**: Keep Claude's tools separate from host tools

## Quick Start

```bash
# Add as submodule to your project
git submodule add <repo-url> .claude-sandbox

# Build and start the container
.claude-sandbox/scripts/build
.claude-sandbox/scripts/up

# Enter the container
.claude-sandbox/scripts/shell
```

## Architecture

```
claude-sandbox/
├── docker-compose.yml      # Container orchestration
├── Dockerfile              # Base minimal image
├── config/
│   └── sandbox.yml         # Container configuration
├── scripts/
│   ├── build               # Build the container image
│   ├── up                  # Start the container
│   ├── down                # Stop the container
│   ├── shell               # Enter the running container
│   ├── logs                # View container logs
│   ├── status              # Check container status
│   ├── clean               # Remove container and images
│   └── hooks/              # Parent repo hook scripts
└── volumes/
    └── home/               # Persistent home directory
```

## Customization

Parent repositories can customize the container through:

1. **Overlay Dockerfiles**: Create `Dockerfile.local` in parent repo to extend the base image
2. **Config files**: Override `config/sandbox.yml` with project-specific settings
3. **Hook scripts**: Add scripts to `scripts/hooks/` that run at build/start time

### Hook Scripts

Place executable scripts in `scripts/hooks/`:
- `pre-build` - Runs before container build
- `post-build` - Runs after container build
- `pre-start` - Runs before container starts
- `post-start` - Runs after container starts

## Volumes

By default, the container mounts:
- **Project directory**: Parent repo mounted at `/workspace`
- **Persistent home**: `volumes/home/` mounted at `/home/claude`

## Running Claude Code

Claude Code runs inside the container. Start a session:

```bash
.claude-sandbox/scripts/shell
# Inside container:
claude
```

## Distribution

To share a customized environment, commit your:
- `Dockerfile.local` (if any)
- `config/sandbox.yml` overrides
- Hook scripts

Recipients build locally with `scripts/build`.
