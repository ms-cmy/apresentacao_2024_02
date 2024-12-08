terraform {
  backend "remote" {
    hostname = "app.terraform.io" 
    organization = "mine22"
    workspaces {
      name = "deploy_example" 
    }
  }
}

resource "google_cloud_run_v2_service" "default" {
  name     = "mycloudrun"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"
  depends_on = [ google_artifact_registry_repository.mycloudrun-repo ]

  template {
    scaling {
      max_instance_count = 1
    }
    max_instance_request_concurrency = 40
    containers {
      image = "us-central1-docker.pkg.dev/silicon-garage-438603-m6/mycloudrun-registry-docker/model_api"
        
      }
    }
  }