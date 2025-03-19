import os
import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
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

FILE_PATH = f"C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Data"

# Configuração do Firebird
DB_PATH = f"C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Banco/BDGERENTE.fdb"
DB_USER = "sysdba"
DB_PASSWORD = "masterkey"
DB_URL = f'firebird+fdb://{DB_USER}:{DB_PASSWORD}@localhost:3050/{DB_PATH}'

BUCKET_NAME = "bronze-layer"
CREDENTIALS_PATH = "C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Senhas/1.JSON/management-zegordo-sa-credentials.json"  # Chave de autenticação do GCP
engine = create_engine(DB_URL)
Session = sessionmaker(bind=engine)
session = Session()


def extract_data(table, engine, file_path):
    result = session.execute(text(f"SELECT * FROM {table}"))
    
    columns = result.keys()
    data = []
    for row in result:
        processed_row = {}
        for col, value in zip(columns, row):
            if isinstance(value, bytes):
                processed_row[col] = value
            elif hasattr(value, "read"): 
                processed_row[col] = value.read()
            else: 
                processed_row[col] = value
        data.append(processed_row)
    
    df = pd.DataFrame(data)
    
    
    # Salvar como .parquet
    file_name = f"carga_full_{table}_{datetime.now().strftime('%Y_%m_%d_%H_%M_%S')}.parquet"
    file_path = f"{file_path}/{file_name}"
    df.to_parquet(path=file_path)
    
    return file_path, file_name

# Enviar para GCS
def upload_to_gcs(file_path, file_name, table):
    destination_blob = f'firbird-db/{table}/{file_name}'
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = CREDENTIALS_PATH
    
    client = storage.Client()
    bucket = client.bucket(BUCKET_NAME)
    blob = bucket.blob(destination_blob)
    blob.upload_from_filename(file_path)
    print(f"Arquivo com a carga full foi enviado para GCS: {destination_blob}")

# Execução
if __name__ == "__main__":
    for TABLE in TABLE_LIST:
        try:
            file_path, file_name = extract_data(TABLE, engine, FILE_PATH)
            upload_to_gcs(file_path, file_name, TABLE)
        except Exception as e:
            print(f"Erro: {e}")