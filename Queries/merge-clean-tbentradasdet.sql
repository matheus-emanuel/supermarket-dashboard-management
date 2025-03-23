MERGE INTO `lambda-architeture-on-gcp.tbentradasdet.clean-tbentradasdet` AS old_data
USING(
  SELECT
    entrada,
    produto,
    CONCAT(entrada, '-', produto) AS entrada_produto_id,
    data,
    quant,
    valor,
    total,
    fornecedor,
    und,
    CURRENT_TIMESTAMP() AS inserted_at,
    CURRENT_TIMESTAMP() AS updated_at
  FROM `lambda-architeture-on-gcp.tbentradasdet.raw-tbentradasdet`
  WHERE data >= CURRENT_DATE()-7
) AS new_data
ON old_data.entrada_produto_id = new_data.entrada_produto_id

WHEN MATCHED THEN
  UPDATE SET
    old_data.data = new_data.data,
    old_data.qtd_item = CAST(new_data.quant AS INT64),
    old_data.custo_unitario = new_data.valor,
    old_data.custo_total = new_data.total,
    old_data.fornecedor = new_data.fornecedor,
    old_data.updated_at = new_data.updated_at

WHEN NOT MATCHED THEN
  INSERT(
    entrada_id,
    cod_produto,
    entrada_produto_id,
    `data`,
    qtd_item,
    custo_unitario,
    custo_total,
    fornecedor,
    unidade,
    inserted_at,
    updated_at
  )
  VALUES(
    new_data.entrada,
    new_data.produto,
    new_data.entrada_produto_id,
    new_data.data,
    CAST(new_data.quant AS INT64),
    new_data.valor,
    new_data.total,
    new_data.fornecedor,
    new_data.und,
    new_data.inserted_at,
    new_data.updated_at
  )