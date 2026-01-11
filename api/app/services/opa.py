import json, subprocess, shutil

def eval_actions(facts: dict) -> dict:
    """Evaluate OPA policy data.ce.triggers.actions. If opa not installed, return stub."""
    if not shutil.which("opa"):
        return {"actions": [], "engine": "stub"}
    try:
        proc = subprocess.run(
            ["opa", "eval", "-f", "json", "-d", "rules", "data.ce.triggers.actions"],
            input=json.dumps({"input": facts}).encode("utf-8"),
            capture_output=True, check=True
        )
        out = json.loads(proc.stdout)
        # OPA JSON: result[0].expressions[0].value
        val = out["result"][0]["expressions"][0]["value"] if out.get("result") else []
        return {"actions": val, "engine": "opa"}
    except Exception as e:
        return {"actions": [], "engine": "error", "error": str(e)}