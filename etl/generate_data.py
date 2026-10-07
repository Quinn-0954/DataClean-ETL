import pandas as pd
import random
from datetime import datetime, timedelta

random.seed(42)

# =========================
# CONFIGURAÇÕES
# =========================

NUM_CLIENTES = 1000
NUM_PRODUTOS = 200
NUM_VENDAS = 10000

# =========================
# CLIENTES
# =========================

nomes = [
    "João Silva",
    "Maria Souza",
    "Carlos Oliveira",
    "Ana Santos",
    "Pedro Costa",
    "Juliana Almeida",
    "Lucas Pereira",
    "Fernanda Rodrigues",
    "Rafael Lima",
    "Camila Martins"
]

cidades = [
    "São Paulo",
    "Santo André",
    "São Bernardo do Campo",
    "São Caetano do Sul",
    "Diadema",
    "Campinas",
    "Santos",
    "Osasco"
]

clientes = []

for i in range(1, NUM_CLIENTES + 1):

    nome = random.choice(nomes)

    cpf_numero = f"{random.randint(10000000000, 99999999999)}"

    cpf_formatado = (
        f"{cpf_numero[:3]}."
        f"{cpf_numero[3:6]}."
        f"{cpf_numero[6:9]}-"
        f"{cpf_numero[9:]}"
    )

    email = nome.lower().replace(" ", ".") + "@email.com"

    cidade = random.choice(cidades)

    data_cadastro = datetime(
        2024,
        random.randint(1, 12),
        random.randint(1, 28)
    )

    clientes.append([
        i,
        nome,
        cpf_formatado,
        email,
        cidade,
        data_cadastro.strftime("%d/%m/%Y")
    ])

clientes_df = pd.DataFrame(
    clientes,
    columns=[
        "ClienteID",
        "Nome",
        "CPF",
        "Email",
        "Cidade",
        "DataCadastro"
    ]
)

# =========================
# INSERINDO PROBLEMAS
# =========================

# Espaços extras
clientes_df.loc[5, "Nome"] = " João Silva "
clientes_df.loc[15, "Nome"] = " Maria Souza "

# Email vazio
clientes_df.loc[20, "Email"] = ""
clientes_df.loc[35, "Email"] = None

# Cidade inconsistente
clientes_df.loc[40, "Cidade"] = "Sao Paulo"
clientes_df.loc[50, "Cidade"] = "SAO PAULO"

# =========================
# PRODUTOS
# =========================

categorias = [
    "Eletrônicos",
    "Informática",
    "Móveis",
    "Eletrodomésticos",
    "Acessórios"
]

produtos = []

for i in range(1, NUM_PRODUTOS + 1):

    categoria = random.choice(categorias)

    produtos.append([
        i,
        f"Produto {i}",
        categoria,
        round(random.uniform(20, 3000), 2)
    ])

produtos_df = pd.DataFrame(
    produtos,
    columns=[
        "ProdutoID",
        "NomeProduto",
        "Categoria",
        "Preco"
    ]
)

# Produto com preço inválido propositalmente
produtos_df.loc[10, "Preco"] = -50

# =========================
# VENDAS
# =========================

vendas = []

data_inicio = datetime(2025, 1, 1)

for i in range(1, NUM_VENDAS + 1):

    cliente_id = random.randint(1, NUM_CLIENTES)
    produto_id = random.randint(1, NUM_PRODUTOS)

    quantidade = random.randint(1, 5)

    produto = produtos_df[
        produtos_df["ProdutoID"] == produto_id
    ].iloc[0]

    valor_unitario = produto["Preco"]

    valor_total = round(
        quantidade * valor_unitario,
        2
    )

    data_venda = data_inicio + timedelta(
        days=random.randint(0, 364)
    )

    vendas.append([
        i,
        cliente_id,
        produto_id,
        data_venda.strftime("%d/%m/%Y"),
        quantidade,
        valor_unitario,
        valor_total
    ])

vendas_df = pd.DataFrame(
    vendas,
    columns=[
        "VendaID",
        "ClienteID",
        "ProdutoID",
        "DataVenda",
        "Quantidade",
        "ValorUnitario",
        "ValorTotal"
    ]
)

# Venda inválida propositalmente
vendas_df.loc[100, "Quantidade"] = 0
vendas_df.loc[200, "ValorTotal"] = -100

# =========================
# EXPORTAÇÃO
# =========================

from pathlib import Path

# Localização da raiz do projeto
BASE_DIR = Path(__file__).resolve().parent.parent

# Pasta onde os dados serão armazenados
DATA_DIR = BASE_DIR / "data"

# Cria a pasta caso ela não exista
DATA_DIR.mkdir(parents=True, exist_ok=True)

# Exportação dos arquivos
clientes_df.to_csv(
    DATA_DIR / "clientes_raw.csv",
    index=False,
    encoding="utf-8-sig"
)

produtos_df.to_csv(
    DATA_DIR / "produtos_raw.csv",
    index=False,
    encoding="utf-8-sig"
)

vendas_df.to_csv(
    DATA_DIR / "vendas_raw.csv",
    index=False,
    encoding="utf-8-sig"
)

print("===================================")
print("DATASET GERADO COM SUCESSO!")
print("===================================")
print(f"Clientes: {len(clientes_df)}")
print(f"Produtos: {len(produtos_df)}")
print(f"Vendas: {len(vendas_df)}")
print(f"Arquivos salvos em: {DATA_DIR}")
print("===================================")