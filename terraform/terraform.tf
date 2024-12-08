resource "google_cloud_run_v2_service" "default" {
  name     = "mycloudrun"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
    scaling {
      max_instance_count = 1
    }
    max_instance_request_concurrency = 40
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      startup_probe {
        initial_delay_seconds = 5
        tcp_socket {
          port = 8080
        }
        http_get {
          path = "/health"
        }
      }
    }
  }
}

resource "google_artifact_registry_repository" "docker_repo" {
  location          = "us-central1" # Replace with your desired region
  repository_id     = "mycloudrun-registry-docker" # Replace with your desired repository name
  format            = "DOCKER"

  cleanup_policies {
    id = "keep only 1 image"
    most_recent_versions {
      keep_count = 1
    }
  }
}