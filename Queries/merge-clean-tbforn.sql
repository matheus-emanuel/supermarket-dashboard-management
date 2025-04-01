MERGE INTO `lambda-architeture-on-gcp.tbforn.clean-tbforn` AS old_data
USING(
  SELECT
    SAFE_CAST(cod AS INT64) AS cod,
    nome,
    endereco,
    bairro,
    uf,
    cidade,
    cep,
    fone,
    cnpj,
    cadastro,
    fantasia,
    CURRENT_TIMESTAMP() AS inserted_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM `lambda-architeture-on-gcp.tbforn.raw-tbforn`
) AS new_data
  ON old_data.cod_fornecedor = new_data.cod

WHEN MATCHED THEN
  UPDATE SET
    old_data.nome_fornecedor = new_data.nome,
    old_data.endereco = new_data.endereco,
    old_data.bairro = new_data.bairro,
    old_data.cidade = new_data.cidade,
    old_data.cep = new_data.cep,
    old_data.nome_fantasia = new_data.fantasia,
    old_data.telefone = new_data.fone,
    old_data.updated_at = new_data.updated_at

WHEN NOT MATCHED THEN
  INSERT(
    cod_fornecedor,
    nome_fornecedor,
    endereco,
    bairro,
    uf,
    cidade,
    cep,
    telefone,
    cnpj,
    data_cadastro,
    nome_fantasia,
    inserted_at,
    updated_at
    )
  VALUES(
    new_data.cod,
    new_data.nome,
    new_data.endereco,
    new_data.bairro,
    new_data.uf,
    new_data.cidade,
    new_data.cep,
    new_data.fone,
    new_data.cnpj,
    new_data.cadastro,
    new_data.fantasia,
    new_data.inserted_at,
    new_data.updated_at
  )
