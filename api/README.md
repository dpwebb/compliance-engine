# API quick start

## Local (requires Python 3.12)
pip install -r api/requirements.txt
uvicorn api.app.main:app --reload

- Health: GET http://127.0.0.1:8000/health
- Upload: POST /ingest/bureau-disclosure (multipart file)
- Evaluate: POST /evaluate/actions (JSON facts)

## Storage
- Set ARTIFACTS_BUCKET to use S3; otherwise files are saved under ./data/uploads.

## Docker
docker build -t ce-api .
docker run -p 8000:8000 -e AWS_REGION=ca-central-1 ce-api