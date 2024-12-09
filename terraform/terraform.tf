terraform {
  backend "remote" {
    hostname = "app.terraform.io" 
    organization = "mine22"
    workspaces {
      prefix = "deploy_example" 
    }
  }
}

# data "google_iam_policy" "noauth" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "allUsers"
#     ]
#   }
# }

# resource "google_cloud_run_v2_service_iam_policy" "cloud_run" {
#   name = "//run.googleapis.com/projects/${var.project_id}/locations/us-central1/services/${google_cloud_run_v2_service.default.name}"
#   policy_data = data.google_iam_policy.noauth.policy_data
#   project = var.project_id
#   location = "us-central1"
# }