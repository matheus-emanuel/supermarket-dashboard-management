CREATE OR REPLACE TABLE `lambda-architeture-on-gcp.tbprodutos.clean-tbprodutos`(
  cod_produto     STRING     OPTIONS(description = "Código de identificação do produto"),
  cod_barras      STRING     OPTIONS(description = "Código de barras do produto"),
  descricao       STRING     OPTIONS(description = "Descrição completa do produto"),
  descricao_brev  STRING     OPTIONS(description = "Descrição abreviada do produto"),
  unidade         STRING     OPTIONS(description = "Unidade de medida de venda do Proiduto UN/KG"),
  preco_venda     FLOAT64    OPTIONS(description = "Valor de venda do produto"),
  ult_forn        STRING     OPTIONS(description = "Código de identificação do último fornecedor"),
  marca           STRING     OPTIONS(description = "Marca da fabricante do produto"),
  margem          FLOAT64    OPTIONS(description = "Margem do produto"),
  inserted_at     TIMESTAMP  OPTIONS(description = "Dia e hora que a linha foi inserida na tabela"),
  updated_at      TIMESTAMP  OPTIONS(description = "Dia e hora da última atualização da linha na tabela")
) 
CLUSTER BY cod_produto, cod_barras, ult_forn
OPTIONS(
  description = "Tabela contendo os produtos cadastrados para venda"
)