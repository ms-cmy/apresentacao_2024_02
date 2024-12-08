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
