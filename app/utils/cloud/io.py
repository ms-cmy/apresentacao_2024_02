from google.cloud import storage

def read_file_from_gcs(gs_path):
  """Reads a file from Google Cloud Storage.

  Args:
    gs_path: The full gs:// path to the file.

  Returns:
    The contents of the file as a string.
  """

  try:
    storage_client = storage.Client()
    bucket_name = gs_path.split("/")[2]
    blob_name = "/".join(gs_path.split("/")[3:])
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(blob_name)
    return blob.download_as_bytes()

  except Exception as e:
    print(f"Error reading file from GCS: {e}")
    return None