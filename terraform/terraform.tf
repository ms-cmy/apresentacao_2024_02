resource "google_cloud_run_service" "my_service" {
  name     = "my-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/my-project-id/my-image:tag"
        readiness_probe {
          http_get {
            path = "/testing"
            port = 8080
          }
          initial_delay_seconds = 5
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
