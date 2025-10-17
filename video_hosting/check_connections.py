import sys
from django.db import connections
from django.db.utils import OperationalError
from google.cloud import storage
from google.oauth2 import service_account
from django.conf import settings


def check_database():
    """Check PostgreSQL connection"""
    db_conn = connections['default']
    try:
        db_conn.cursor()
        print("✅ Database connection successful")
    except OperationalError as e:
        print("❌ Database connection failed:")
        print(e)
        sys.exit(1)


def check_gcs():
    """Check Google Cloud Storage access"""
    try:
        credentials = service_account.Credentials.from_service_account_file(
            settings.BASE_DIR / "key.json"
        )
        client = storage.Client(credentials=credentials)
        bucket = client.get_bucket(settings.GS_BUCKET_NAME)
        print(f"✅ GCS bucket '{bucket.name}' accessible")
    except Exception as e:
        print("❌ GCS connection failed:")
        print(e)
        sys.exit(1)


def run_health_check():
    print("🔍 Running system health checks...\n")
    check_database()
    check_gcs()
    print("\n✅ All connections OK! You're good to go 🎉")
