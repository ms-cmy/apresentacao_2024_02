resource "google_artifact_registry_repository" "mycloudrun-repo" {
  location          = "us-central1" 
  repository_id     = "mycloudrun-registry-docker" 
  format            = "DOCKER"

  cleanup_policies {
    id = "keep-only-one-image"
    action = "KEEP"
    most_recent_versions {
      keep_count = 1
    }
  }
}