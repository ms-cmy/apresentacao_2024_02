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