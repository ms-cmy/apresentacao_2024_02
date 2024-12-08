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

resource "google_bigquery_table" "default" {
  dataset_id = "titanic_results"
  table_id   = "titanic"

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
}

resource "google_pubsub_subscription" "default" {
  name  = "publish to bigquery titanic"
  topic = google_pubsub_topic.default.name

  bigquery_config {
    table = "titanic_results.titanic"
    # use_topic_schema = true  
    write_metadata = true    
  }
}

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
      image = "us-central1-docker.pkg.dev/silicon-garage-438603-m6/mycloudrun-registry-docker/model_api"
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