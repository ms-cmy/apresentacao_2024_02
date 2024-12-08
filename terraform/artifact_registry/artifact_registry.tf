resource "google_artifact_registry_repository" "docker_repo" {
  location          = "us-central1" 
  repository_id     = "mycloudrunregistrydocker" 
  format            = "DOCKER"

  cleanup_policies {
    id = "keep only 1 image"
    most_recent_versions {
      keep_count = 1
    }
  }
}