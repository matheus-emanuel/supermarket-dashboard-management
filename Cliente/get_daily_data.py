import os
import json
import pandas as pd
from datetime import datetime, timedelta
from sqlalchemy import create_engine
from google.cloud import storage

# Configurações
TABLE_LIST = [
    'tbestoquesdet',
    'tbmercadorias',
    'tbprodutos',
    'tbforn',
    'tblogpdv',
    'tbtributacao',
    'tbvendasbk',
    'tbvendasdet',
    'tbvendaspag',
    'tbvendas'
]

DATE_LIST = [] # Preencher com as datas que precisam ser reprocessadas Ex: ['2025-01-01', '2025-01-02']
FILE_PATH = f"C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Data"

# Configuração do Firebird
DB_PATH = f"C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Banco/BDGERENTE.fdb"
DB_USER = "sysdba"
DB_PASSWORD = "masterkey"
DB_URL = f'firebird+fdb://{DB_USER}:{DB_PASSWORD}@localhost:3050/{DB_PATH}'

# Configuração do GCS
BUCKET_NAME = "bronze-layer"
CREDENTIALS_PATH = "C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Senhas/1.JSON/management-zegordo-sa-credentials.json"  # Chave de autenticação do GCP
engine = create_engine(DB_URL)

def generate_query(date, table):
    with open('Cliente/table_filter.json', 'r') as file:
        TABLE_FILTER = json.load(file)
    
    if table not in TABLE_FILTER:
        raise ValueError(f"A tabela {table} não foi encontrada no arquivo de filtro.")
    
    table_config = TABLE_FILTER[table]
    filter_by_date = table_config['filter_by_date']
    column_to_filter = table_config['column_to_filter']
    filter_type = table_config['filter_type']
    
    if not filter_by_date:
        return f'SELECT * FROM {table}'
    
    if filter_type == 'last_day':
        return f"SELECT * FROM {table} WHERE {column_to_filter} = '{date}'"
    
    raise ValueError(f"Não há consulta definida para a tabela: {table}")

# Extrair dados
def extract_data(table, date, query, engine, file_path):
    df = pd.read_sql(query, engine)
    df['inserted_at'] = datetime.now()
    
    # Salvar como .parquet
    file_name = f"{table}_{datetime.now().strftime('%Y_%m_%d_%H_%M_%S')}.parquet"
    file_path = f"{file_path}/{file_name}"
    df.to_parquet(path=file_name)
    
    return file_name, file_name

# Enviar para GCS
def upload_to_gcs(file_path, file_name, table):
    destination_blob = f'firbird-db/{table}/{file_name}'
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = CREDENTIALS_PATH
    
    client = storage.Client()
    bucket = client.bucket(BUCKET_NAME)
    blob = bucket.blob(destination_blob)
    blob.upload_from_filename(file_path)
    print(f"Arquivo enviado para GCS: {destination_blob}")

# Execução
if __name__ == "__main__":
    if not DATE_LIST:
        DATE_LIST.append(
            datetime.strftime(datetime.now() - timedelta(days=20), '%Y-%m-%d')
        )
    for TABLE in TABLE_LIST:
        for DATE in DATE_LIST:
            try:
                query = generate_query(DATE, TABLE)
                file_path, file_name = extract_data(TABLE, DATE, query, engine, FILE_PATH)
                upload_to_gcs(file_path, file_name, TABLE)
            except Exception as e:
                print(f"Erro: {e}")
