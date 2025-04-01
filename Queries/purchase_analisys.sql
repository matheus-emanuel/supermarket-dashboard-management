WITH
entradas_estoque AS(
  SELECT
    cod_produto,
    `data`, 
    qtd_item, 
    custo_unitario, 
    custo_total, 
    fornecedor
  FROM `lambda-architeture-on-gcp.tbentradasdet.clean-tbentradasdet`
  QUALIFY ROW_NUMBER() OVER(partition by cod_produto ORDER BY data DESC) = 1
),

fornecedor AS (
  SELECT
    cod_fornecedor, 
    nome_fantasia
  FROM `lambda-architeture-on-gcp.tbforn.clean-tbforn`
),

produto AS (
  SELECT
    cod_produto,
    cod_barras,
    descricao, 
    preco_venda, 
    ult_forn, 
    marca, 
    margem
  FROM `lambda-architeture-on-gcp.tbprodutos.clean-tbprodutos`
),

estoque AS (
  SELECT
    `data`, 
    cod_produto, 
    entrada, 
    saida, 
    estoque, 
    saldo
  FROM `lambda-architeture-on-gcp.tbestoquesdet.clean-tbestoquesdet`
  WHERE acao = 'VENDA REALIZADA'
  QUALIFY ROW_NUMBER() OVER(partition by cod_produto order by data DESC) = 1
)


SELECT
  ee.data AS ult_entrada_estoque,
  ee.qtd_item AS entrada_qtd_item,
  ee.custo_unitario AS custo_unitario_entrada,
  ee.custo_total AS custo_total_entrada,
  pr.cod_barras,
  pr.descricao AS descricao_prod,
  pr.preco_venda,
  pr.margem,
  es.data AS ult_venda_realizada,
  es.saida AS qtd_vendida,
  es.saldo AS estoque_restante,
  fo.nome_fantasia AS nome_fornecedor
FROM entradas_estoque ee
INNER JOIN produto pr
  USING(cod_produto)
INNER JOIN estoque es
  USING(cod_produto)
INNER JOIN fornecedor fo
  ON fo.cod_fornecedor = SAFE_CAST(pr.ult_forn AS INT64)




















