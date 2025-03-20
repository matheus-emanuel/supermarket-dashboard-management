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

resource "google_bigquery_dataset" "creation_bigquery_dataset" {
    for_each = toset(var.table_name)
    dataset_id = each.value
    location = "US"

    labels = {
        managedby = "terraform"
        env = "production"
  }
  
}