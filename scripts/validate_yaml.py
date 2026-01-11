import sys, json, pathlib
from typing import Tuple
try:
    import yaml, jsonschema
except Exception as e:
    print("Missing deps, install with: pip install pyyaml jsonschema", file=sys.stderr)
    sys.exit(0)  # non-blocking

ROOT = pathlib.Path(__file__).resolve().parents[1]

def load_yaml(p: pathlib.Path):
    with p.open("r", encoding="utf-8") as fh:
        return yaml.safe_load(fh)

def load_json(p: pathlib.Path):
    with p.open("r", encoding="utf-8") as fh:
        return json.load(fh)

checks = [
    ("data/directories/creditors.yaml", "data/schemas/creditors.schema.json"),
    ("data/directories/collectors.yaml", "data/schemas/collectors.schema.json"),
]

errors = 0
for yml, schema in checks:
    yp = ROOT / yml
    sp = ROOT / schema
    if not yp.exists():
        print(f"[skip] {yml} not found")
        continue
    try:
        data = load_yaml(yp)
        sch = load_json(sp)
        jsonschema.validate(instance=data, schema=sch)
        print(f"[ok] {yml} validated against {schema}")
    except jsonschema.ValidationError as ve:
        errors += 1
        print(f"[fail] {yml}: {ve.message}")
    except Exception as e:
        errors += 1
        print(f"[fail] {yml}: {e}")

# non-blocking exit; print summary
if errors:
    print(f"Validation completed with {errors} issue(s).")
else:
    print("Validation completed with 0 issues.")
sys.exit(0)