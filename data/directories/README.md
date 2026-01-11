# Directories (seed)

Edit these YAML files with real contact and license details as you confirm them.

- `data/directories/creditors.yaml` — creditors/furnishers (legal name, BN, provinces, contacts)
- `data/directories/collectors.yaml` — collection agencies (operating names, provincial licenses, contacts)

Rules consult these directories to route conditional notices when triggers fire. If a contact is missing, the system falls back to privacy/registered office where available.