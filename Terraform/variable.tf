
variable "bigquery_project" {
    description = "Projeto do BigQuery"
    type = string
    default = "lambda-architeture-on-gcp"
}

variable "table_name" {
  description = "Lista de tabelas que devem ser ingeridas"
  type = list(string)
}