# apm

**Kind:** mixin

Installs the Microsoft [Agent Package Manager](https://microsoft.github.io/apm/) (`apm` command). APM manages AI agent context dependencies — skills, prompts, instructions, plugins, and MCP servers — declared in an `apm.yml` file.

## Usage

```bash
sbx run opencode --kit "git+https://github.com/protyposis/sbx-kits.git#dir=apm" ~/my-project
```

`apm` is available immediately. Initialize a project or install dependencies from an existing `apm.yml`:

```bash
apm init my-app
apm install
apm run
```

The kit allows network access to GitHub and PyPI so the APM installer can download the CLI binary or fall back to a pip install when needed.
