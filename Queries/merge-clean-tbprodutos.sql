MERGE INTO `lambda-architeture-on-gcp.tbprodutos.clean-tbprodutos` AS old_data
USING(
  SELECT
    cod,
    barras,
    descricao,
    descabrev,
    unidade,
    preco,
    ultforn,
    marca,
    margem,
    CURRENT_TIMESTAMP() AS inserted_at,
    CURRENT_TIMESTAMP() AS updated_at
  FROM `lambda-architeture-on-gcp.tbprodutos.raw-tbprodutos`
) AS new_data
  ON old_data.cod_produto = new_data.cod

WHEN MATCHED THEN
  UPDATE SET
    old_data.ult_forn = new_data.ultforn,
    old_data.descricao = new_data.descricao,
    old_data.descricao_brev = new_data.descabrev,
    old_data.preco_venda = new_data.preco,
    old_data.margem = new_data.margem,
    old_data.updated_at = new_data.updated_at

WHEN NOT MATCHED THEN
  INSERT(
    cod_produto,
    cod_barras,
    descricao,
    descricao_brev,
    unidade,
    preco_venda,
    ult_forn,
    marca,
    margem,
    inserted_at,
    updated_at
    )
  VALUES(
    new_data.cod,
    new_data.barras,
    new_data.descricao,
    new_data.descabrev,
    new_data.unidade,
    new_data.preco,
    new_data.ultforn,
    new_data.marca,
    new_data.margem,
    new_data.inserted_at,
    new_data.updated_at
  )
