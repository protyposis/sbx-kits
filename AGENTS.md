# Agent Instructions

This repository contains Docker Sandbox kits. Each top-level subdirectory is a self-contained kit — a `spec.yaml` and an optional `files/` tree that extends or defines a sandbox agent.

References: [Docker Sandbox kits documentation](https://docs.docker.com/ai/sandboxes/customize/kits/) · [spec format](https://github.com/docker/sbx-kits-contrib/blob/main/spec/types.go)

## Repository layout

```
sbx-kits/
├── README.md                  # Index of all kits — keep in sync
├── AGENTS.md                  # This file
└── <kit-name>/
    ├── README.md
    ├── spec.yaml
    └── files/                 # Optional static files
        ├── home/              # Copied to /home/agent/ in the sandbox
        └── workspace/         # Copied to the primary workspace path
```

## Adding a kit

1. Create a directory at the repo root. Name it lowercase, alphanumeric, hyphens only.
2. Write `spec.yaml`. Set `schemaVersion`, `kind` (`mixin` or `sandbox`), `name`, and `version`.
3. Write a `README.md` — see the writing rules below.
4. Add the kit to the index table in the root `README.md`.

## Writing rules for README files

Follow Strunk & White: prefer the active voice, omit needless words, be direct.

Do not restate what is already in `spec.yaml` or in scripts. A README explains *what* the kit does and *how to use it*. It does not describe implementation details that are visible in the spec.

## Root README

`README.md` at the repo root is the kit index. Keep its table in sync with the actual kit directories. When you add or remove a kit, update the table immediately — same commit.

## Referencing kits in documentation

When writing commands or examples that load a kit from this repository, use the absolute GitHub URL:

```bash
sbx run <agent> --kit "git+https://github.com/protyposis/sbx-kits.git#dir=<kit-name>"
```

Do not use relative paths (e.g., `./opencode-omo`) in documentation. Relative paths are for local development only.
