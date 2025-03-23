MERGE INTO `lambda-architeture-on-gcp.tbestoquesdet.clean-tbestoquesdet` AS old_data
USING(
  SELECT
    id,
    data,
    hora,
    produto,
    entrada,
    saida,
    movimento,
    historico,
    saldoantes,
    saldo,
    CURRENT_TIMESTAMP() AS inserted_at,
    CURRENT_TIMESTAMP() AS updated_at
  FROM `lambda-architeture-on-gcp.tbestoquesdet.raw-tbestoquesdet`
  WHERE data >= CURRENT_DATE()-7
  QUALIFY ROW_NUMBER() OVER(partition by data, produto, movimento order by updated_at DESC) = 1
) AS new_data
ON old_data.id = new_data.id
  AND old_data.data = new_data.data
  AND old_data.cod_produto = new_data.produto
WHEN MATCHED THEN
  UPDATE SET
    old_data.hora = new_data.hora,
    old_data.entrada = new_data.entrada,
    old_data.saida = new_data.saida,
    old_data.estoque = new_data.saldoantes,
    old_data.saldo = new_data.saldo,
    old_data.updated_at = new_data.updated_at
WHEN NOT MATCHED THEN
  INSERT(
    id, 
    `data`, 
    hora, 
    cod_produto, 
    entrada, 
    saida, 
    movimento, 
    acao, 
    estoque, 
    saldo, 
    inserted_at, 
    updated_at
  )
  VALUES(
    new_data.id,
    new_data.data,
    new_data.hora,
    new_data.produto,
    new_data.entrada,
    new_data.saida,
    new_data.movimento,
    new_data.historico,
    new_data.saldoantes,
    new_data.saldo,
    new_data.inserted_at,
    new_data.updated_at
  )

    
    
    
    
    
    
