resource "google_pubsub_topic" "default" {
  name = "topic-project-titanic"
}

resource "google_bigquery_table" "default" {
  dataset_id = "titanic-results"
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

resource "google_pubsub_subscription" "default" {
  name  = "your-subscription-name"
  topic = google_pubsub_topic.default.name

  bigquery_config {
    table = "${google_bigquery_table.default.dataset_id}.${google_bigquery_table.default.table_id}"
    # use_topic_schema = true  
    write_metadata = true    
  }
}