import pandas as pd
from pathlib import Path
from sqlalchemy import create_engine

# =============================================
# CONFIGURAÇÕES
# =============================================

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"

SERVER = r"DESKTOP-J75PGKL\SQLEXPRESS03"
DATABASE = "DataCleanDB"

# =============================================
# CONEXÃO COM SQL SERVER
# =============================================

connection_string = (
    "mssql+pyodbc://@"
    + SERVER
    + "/"
    + DATABASE
    + "?driver=ODBC+Driver+18+for+SQL+Server"
    + "&trusted_connection=yes"
    + "&TrustServerCertificate=yes"
)

engine = create_engine(connection_string)

# =============================================
# LEITURA DOS CSVs
# =============================================

clientes = pd.read_csv(
    DATA_DIR / "clientes_raw.csv"
)

produtos = pd.read_csv(
    DATA_DIR / "produtos_raw.csv"
)

vendas = pd.read_csv(
    DATA_DIR / "vendas_raw.csv"
)

print("Arquivos CSV carregados.")
print(f"Clientes: {len(clientes)}")
print(f"Produtos: {len(produtos)}")
print(f"Vendas: {len(vendas)}")

# =============================================
# CARGA NO SQL SERVER
# =============================================

clientes.to_sql(
    "STG_Clientes",
    engine,
    schema="dbo",
    if_exists="append",
    index=False
)

produtos.to_sql(
    "STG_Produtos",
    engine,
    schema="dbo",
    if_exists="append",
    index=False
)

vendas.to_sql(
    "STG_Vendas",
    engine,
    schema="dbo",
    if_exists="append",
    index=False
)

print("===================================")
print("ETL DE CARGA CONCLUÍDO!")
print("===================================")