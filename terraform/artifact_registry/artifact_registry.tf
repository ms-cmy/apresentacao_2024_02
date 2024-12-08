resource "google_artifact_registry_repository" "mycloudrun-registry-docker" {
  location          = "us-central1" 
  repository_id     = "mycloudrun-registry-docker" 
  format            = "DOCKER"

  cleanup_policies {
    id = "keep only 1 image"
    most_recent_versions {
      keep_count = 1
    }
  }
}