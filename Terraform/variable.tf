
variable "bigquery_project" {
    description = "Projeto do BigQuery"
    type = string
    default = "lambda-architeture-on-gcp"
}

variable "table_name" {
  description = "Lista de tabelas que devem ser ingeridas"
  type = list(string)
}

variable "database_name" {
  description = "Tipo de Banco de Dados por padrão o nome deverá ser <nome-do-banco>-db"
  type = string
}