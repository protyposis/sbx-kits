# opencode-omo

**Kind:** mixin

Installs [Oh My OpenAgent](https://github.com/oh-my-openagent/oh-my-openagent) for OpenCode with **OpenAI/ChatGPT** and **OpenCode Go** providers enabled. Bun is installed first as the runtime for the `bunx`-based installer.

## What gets installed

- **Bun** — fast JavaScript runtime / package manager (used to run `bunx oh-my-openagent`)
- **Oh My OpenAgent** — provider/model configuration layer for OpenCode
  - OpenAI (ChatGPT) ✓
  - OpenCode Go ✓
  - All other providers disabled

## Usage

Apply as a mixin on top of any OpenCode-based sandbox:

```bash
sbx run opencode --kit ./opencode-omo ~/my-project
```

Or stack it with other kits:

```bash
sbx run opencode \
  --kit ./opencode-omo \
  --kit ./opencode-go-auth \
  ~/my-project
```

## Customising providers

Fork the kit and edit the `bunx oh-my-openagent install` flags in `spec.yaml` to enable/disable providers (`--openai=yes/no`, `--gemini=yes/no`, etc.).
