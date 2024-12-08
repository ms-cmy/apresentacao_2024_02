resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"

  template {
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