# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

claude-sandbox is a containerization toolkit for running Claude Code in isolated environments. It's designed as a git submodule that parent repositories include to gain container management tooling.

## Commands

```bash
# Check Docker dependencies
./scripts/check-deps

# Build the container image
./scripts/build

# Start container (detached)
./scripts/up

# Stop container
./scripts/down

# Enter running container shell
./scripts/shell

# View logs
./scripts/logs

# Check container status
./scripts/status

# Remove container and images
./scripts/clean
```

## Architecture

- **Docker Compose** orchestrates the container
- **Minimal base image** (shell only) - tools added via customization
- **Volume mounts**: project at `/workspace`, persistent home at `/home/claude`
- **Hook system**: `scripts/hooks/` allows parent repos to inject behavior at build/start

### Customization Layers

1. Base `Dockerfile` provides minimal environment
2. Parent repos can create `Dockerfile.local` to extend
3. `config/sandbox.yml` holds runtime configuration
4. Hook scripts in `scripts/hooks/` run at lifecycle events

## Key Design Decisions

- Claude Code runs **inside** the container, not on host
- Single container profile per project (no multi-profile complexity)
- Distribution via Dockerfile sharing, not registry pushes
- Default Docker security isolation (no extra restrictions)

---

## SESSION HANDOFF - Current State & Next Steps

### What Was Built
All core tooling is complete:
- `Dockerfile` - minimal debian:bookworm-slim with bash, git, curl
- `docker-compose.yml` - service orchestration
- `config/sandbox.yml` - configuration reference
- All scripts: `build`, `up`, `down`, `shell`, `logs`, `status`, `clean`, `check-deps`
- `.gitignore` and directory structure

### Current Blocker
Docker daemon needs to be accessible. Run one of:
```bash
sudo systemctl start docker
# OR if just added to docker group:
newgrp docker
```

### Next Steps (in order)
1. Verify Docker works: `./scripts/check-deps`
2. Test the build: `./scripts/build`
3. Test container lifecycle: `./scripts/up && ./scripts/shell`
4. Inside container, verify mounts work (`ls /workspace`)
5. Test cleanup: `./scripts/down && ./scripts/clean`

### Future Improvements to Consider
- Install Claude Code inside the container (needs install script)
- Add example hook scripts
- Add `.env` file support for configuration
- Test submodule workflow in a real parent repo
- Add `scripts/exec` for running one-off commands without entering shell
