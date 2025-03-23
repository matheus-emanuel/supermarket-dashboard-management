CREATE OR REPLACE TABLE `lambda-architeture-on-gcp.tbentradasdet.clean-tbentradasdet`(
  entrada_id          STRING      OPTIONS(description = "Identificação única da entrada"),
  cod_produto         STRING      OPTIONS(description = "Código de identificação único do produto"),
  entrada_produto_id  STRING      OPTIONS(description = "Identificação única do produto por entrada: concatenação de entrada_id + cod_produto"),
  data                DATE        OPTIONS(description = "Data em que a nota deu entrada no sistema"),
  qtd_item            INT64       OPTIONS(description = "Quantidade do produto que deu entrada no sistema"),
  custo_unitario      FLOAT64     OPTIONS(description = "Custo por unidade que deu entrada no sistema"),
  custo_total         FLOAT64     OPTIONS(description = "Custo total do produto que deu entrada no sistema"),
  fornecedor          STRING      OPTIONS(description = "Código de identificação do fornecedor"),
  unidade             STRING      OPTIONS(description = "Unidade de medida de venda do Proiduto UN/KG"),
  inserted_at         TIMESTAMP   OPTIONS(description = "Dia e hora que a linha foi inserida na tabela"),
  updated_at          TIMESTAMP   OPTIONS(description = "Dia e hora da última atualização da linha na tabela")
) 
PARTITION BY data
CLUSTER BY data, cod_produto, fornecedor
OPTIONS(
  description = "Tabela contendo as entradas de produtos no estoque"
)