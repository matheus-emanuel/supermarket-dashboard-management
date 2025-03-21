terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.26.0"
    }
  }
}

provider "google" {
  credentials = file("C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Senhas/1.JSON/management-zegordo-sa-credentials.json")
  project = var.bigquery_project
}

resource "google_storage_bucket" "create_bucket_ingestion" {
  name = "${var.bigquery_project}-${var.database_name}"
  location = "US"
  project = var.bigquery_project
  storage_class = "STANDARD"
}

resource "google_storage_bucket_object" "ingestion_folder" {
  name   = "ingestion/"    # folder name should end with '/'
  content = " "            # content is ignored but should be non-empty
  bucket = google_storage_bucket.create_bucket_ingestion.name
}

resource "google_storage_bucket_object" "tables_folder" {
  for_each = toset(var.table_name)
  name = "${google_storage_bucket_object.ingestion_folder.name}${each.value}/"
  content = " "
  bucket = google_storage_bucket.create_bucket_ingestion.name
  
}

resource "google_bigquery_dataset" "creation_bigquery_dataset" {
    for_each = toset(var.table_name)
    dataset_id = each.value
    location = "US"

    labels = {
        managedby = "terraform"
        env = "production"
  }
  
}