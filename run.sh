#!/usr/bin/env bash
set -euo pipefail
python -m pip install -r api/requirements.txt >/dev/null 2>&1 || true
python -m uvicorn api.app.main:app --host 0.0.0.0 --port 8000 --reload
