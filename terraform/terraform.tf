terraform {
  backend "remote" {
    hostname = "app.terraform.io" 
    organization = "mine22"
    workspaces {
      prefix = "deploy_example" 
    }
  }
}

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

resource "google_bigquery_dataset" "default" {
  dataset_id = "titanic_results"
}

resource "google_bigquery_table" "default" {
  dataset_id = "titanic_results"
  table_id   = "titanic"
  depends_on = [ google_bigquery_dataset.default ]
  deletion_protection = false

  schema = <<EOF
[
  {
    "name": "NOME",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "INPUTS",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "CHANCE_SOBREVIVER",
    "type": "FLOAT",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_pubsub_topic" "default" {
  name = "topic-project-titanic"
  project = var.project_id
  depends_on = [ google_bigquery_table.default ]

}

resource "google_pubsub_subscription" "default" {
  name  = "publish_to_bigquery_titanic"
  topic = google_pubsub_topic.default.id
  depends_on = [ google_pubsub_topic.default, google_bigquery_table.default ]
  
  bigquery_config {
    table = "${var.project_id}.titanic_results.titanic" 
    use_table_schema = true
  }
  
}

resource "google_cloud_run_v2_service" "default" {
  name     = "mycloudrun"
  location = "us-central1"
  deletion_protection = false
  ingress = "INGRESS_TRAFFIC_ALL"
  depends_on = [ google_artifact_registry_repository.mycloudrun-repo ]
  project = var.project_id

  template {
    scaling {
      max_instance_count = 1
    }
    max_instance_request_concurrency = 40
    containers {
      image = "gcr.io/google-samples/hello-app:2.0"
      }
    }
  lifecycle {
    ignore_changes = [ template[0].containers[0].image ]
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
#   name = google_cloud_run_v2_service.default.name
#   policy_data = data.google_iam_policy.noauth.policy_data
#   project = var.project_id
#   location = "us-central1"
# }