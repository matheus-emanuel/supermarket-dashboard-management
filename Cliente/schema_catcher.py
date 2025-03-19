from sqlalchemy import create_engine, MetaData
from sqlalchemy.types import BLOB

# Configurações
TABLE_LIST = [
    # 'tbestoquesdet',
    # 'tbmercadorias',
    # 'tbprodutos',
    # 'tbforn',
    # 'tblogpdv',
    # 'tbtributacao',
    # 'tbvendasbk',
    # 'tbvendasdet',
    # 'tbvendaspag',
    'tbvendas'
]

DATE_LIST = [] # Preencher com as datas que precisam ser reprocessadas
FILE_PATH = f"C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Data"

# Configuração do Firebird
DB_PATH = f"C:/Users/freit/OneDrive/Documentos/Estudos/TCC/Banco/BDGERENTE.fdb"
DB_USER = "sysdba"
DB_PASSWORD = "masterkey"
DB_URL = f'firebird+fdb://{DB_USER}:{DB_PASSWORD}@localhost:3050/{DB_PATH}'

engine = create_engine(DB_URL)
metadata = MetaData()
metadata.reflect(bind=engine)

# inspector = inspect(engine)
# table_name = inspector.get_table_names()

# print("Tabelas encontradas no banco:")
# print(table_name)

for table in TABLE_LIST:
    if table in metadata.tables:
        print(f'\nschma da tabela {table}:')
        metadata_table = metadata.tables[table]
        for column in metadata_table.columns:
            print(f' - {column.name} {column.type}')
            if isinstance(column.type, BLOB):
                print('Essa coluna é um BLOB')
    else:
        print('Tabela não encontrada no Banco de Dados')