CREATE OR REPLACE TABLE `lambda-architeture-on-gcp.tbforn.clean-tbforn`(
  cod_fornecedor      INT64       OPTIONS(description = "Código único de identificação do fornecedor"),
  nome_fornecedor     STRING      OPTIONS(description = "Nome do fornecedor"),
  endereco            STRING      OPTIONS(description = "Endereço do fornecedor"),
  bairro              STRING      OPTIONS(description = "Bairro onde a sede do fornecedor está localizado"),
  uf                  STRING      OPTIONS(description = "Unidade Federal onde a empresa está"),
  cidade              STRING      OPTIONS(description = "Cidade em que a sede da empresa está"),
  cep                 STRING      OPTIONS(description = "CEP da empresa"),
  telefone            STRING      OPTIONS(description = "Telefone de contato da empresa"),
  cnpj                STRING      OPTIONS(description = ""),
  data_cadastro       DATE        OPTIONS(description = ""),
  nome_fantasia       STRING      OPTIONS(description = "Nome fantasia do fornecedor"),
  inserted_at         TIMESTAMP   OPTIONS(description = "Dia e hora que a linha foi inserida na tabela"),
  updated_at          TIMESTAMP   OPTIONS(description = "Dia e hora da última atualização da linha na tabela")
) 
CLUSTER BY cod_fornecedor, nome_fantasia
OPTIONS(
  description = "Tabela contendo informações dos fornecedores"
)