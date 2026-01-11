import os, uuid, pathlib, boto3
from typing import Tuple

BUCKET = os.getenv("ARTIFACTS_BUCKET")
REGION = os.getenv("AWS_REGION", "ca-central-1")

def save_upload(filename: str, data: bytes) -> Tuple[str, str]:
    """Return (location, key_or_path). Uses S3 if ARTIFACTS_BUCKET is set; else local data/uploads."""
    if BUCKET:
        s3 = boto3.client("s3", region_name=REGION)
        key = f"uploads/{uuid.uuid4()}-{filename}"
        s3.put_object(Bucket=BUCKET, Key=key, Body=data)
        return ("s3", f"s3://{BUCKET}/{key}")
    # local fallback
    base = pathlib.Path(__file__).resolve().parents[2] / "data" / "uploads"
    base.mkdir(parents=True, exist_ok=True)
    key = base / f"{uuid.uuid4()}-{filename}"
    key.write_bytes(data)
    return ("file", str(key))