CREATE OR REPLACE TABLE `lambda-architeture-on-gcp.tbestoquesdet.clean-tbestoquesdet`(
  id              INT64     OPTIONS(description = "Identificação única"),
  data            DATE      OPTIONS(description = "Data da transação"),
  hora            TIME      OPTIONS(description = "Hora em que a transação aconteceu"),
  cod_produto     STRING    OPTIONS(description = "Código do produto que foi movimentado"),
  entrada         FLOAT64   OPTIONS(description = "Indica a quantidade de itens que deram entrada no estoque"),
  saida           FLOAT64   OPTIONS(description = "Indica a quantidade de itens que deram saída no estoque"),
  movimento       STRING    OPTIONS(description = "Identificação do movimento, seja entrada em estoque ou venda realizada"),
  acao            STRING    OPTIONS(description = "Descrição da ação realidada VENDA REALIZADA / ENTRADA DE MERCADORIA / LANCAMENTO INICIAL"),
  estoque         FLOAT64   OPTIONS(description = "Valor que tem no estoque antes de haver a movimentação"),
  saldo           FLOAT64   OPTIONS(description = "Valor que há no estoque depois da movimentação"),
  inserted_at    TIMESTAMP OPTIONS(description = "Dia e hora que a linha foi inserida na tabela"),
  updated_at      TIMESTAMP OPTIONS(description = "Dia e hora que a linha foi atualizada")
) 
PARTITION BY data
OPTIONS(
  description = "Tabela contendo as movimentações de estoque"
)