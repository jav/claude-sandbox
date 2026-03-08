#!/usr/bin/env bash
# Shared helpers for all sandbox scripts.
# Source this file after setting SCRIPT_DIR and ROOT_DIR.

# Derive a unique sandbox name from the parent project directory.
# When used as a submodule, ROOT_DIR sits inside the parent project,
# so the parent directory name is the natural differentiator.
_parent_dir="$(dirname "$ROOT_DIR")"
_parent_name="$(basename "$_parent_dir")"

# Sanitize to a valid Docker name (lowercase, alphanumeric + hyphens)
SANDBOX_NAME="claude-sandbox-$(echo "$_parent_name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')"

export SANDBOX_NAME
export COMPOSE_PROJECT_NAME="$SANDBOX_NAME"
