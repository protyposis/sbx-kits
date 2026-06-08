# traffic-inspection-ca

> **Warning**: Only use this mixin when you are certain that TLS traffic
> inspection in your environment is legitimate and explicitly authorized by your
> organization (for example, a corporate ZScaler proxy). Installing a CA
> certificate allows its owner to silently intercept all TLS connections from
> the sandbox. Never install a certificate from an unknown or untrusted source.

A mixin that installs a corporate CA certificate into the sandbox's system
trust store so TLS traffic works in environments where connections are
intercepted (e.g., ZScaler, Netskope, Blue Coat).

## How it works

At each sandbox start the mixin runs three steps in order, stopping at the
first that succeeds:

1. **Explicit path** — If `INSPECTION_CA_CERT_PATH` points to a PEM file inside the
   sandbox, install it.
2. **Workspace default** — If `inspection-ca.pem` exists at the root of the
   workspace, install it.
3. **Auto-detect** — Probe `INSPECTION_DETECT_URL` (default: `https://www.google.com`).
   If the connection fails TLS verification but succeeds without it, the mixin
   extracts the CA certificates from the TLS chain and installs them.

## Usage

```bash
sbx run <agent> \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=traffic-inspection-ca" \
  ~/my-project
```

### Option A: workspace file

Place your corporate CA certificate (PEM format) in the project root as
`inspection-ca.pem`. The mixin picks it up automatically — no extra configuration
needed.

### Option B: explicit path

Set `INSPECTION_CA_CERT_PATH` to the path inside the sandbox where the certificate
will be available (e.g., if it is part of the workspace at a non-root path):

```bash
sbx run <agent> \
  --kit "git+https://github.com/protyposis/sbx-kits.git#dir=traffic-inspection-ca" \
  --env INSPECTION_CA_CERT_PATH=/workspace/infra/corporate-ca.pem \
  ~/my-project
```

### Option C: auto-detect (no configuration)

If neither of the above provides a certificate, the mixin probes a well-known
HTTPS endpoint, detects the interception, and extracts the CA from the
certificate chain automatically.

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `INSPECTION_CA_CERT_PATH` | _(empty)_ | Path inside the sandbox to a PEM-encoded CA certificate. When set, this takes priority over the workspace default and auto-detection. |
| `INSPECTION_DETECT_URL` | `https://www.google.com` | HTTPS URL probed to detect TLS interception when no certificate file is found. Change this if the default URL is blocked or unreachable in your environment. |
