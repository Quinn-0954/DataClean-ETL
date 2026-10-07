USE DataCleanDB;
GO

-- =============================================
-- TABELA FINAL: CLIENTES
-- =============================================

IF OBJECT_ID ('dbo.Clientes', 'U') IS NOT NULL
    DROP TABLE dbo.clientes;
GO

CREATE TABLE dbo.Clientes
(
    ClienteID INT NOT NULL PRIMARY KEY,
    Nome VARCHAR(200) NOT NULL,
    CPF VARCHAR(20) NOT NULL,
    Email VARCHAR(200) NULL,
    Cidade VARCHAR(100) NOT NULL,
    DataCadastro DATE NOT NULL,

    CONSTRAINT UQ_Clientes_CPF UNIQUE (CPF)

);
GO


-- =============================================
-- TABELA FINAL: PRODUTOS
-- =============================================

IF OBJECT_ID ('dbo.Produtos', 'U') IS NOT NULL
    DROP TABLE dbo.Produtos;
GO

CREATE TABLE dbo.Produtos
(
    ProdutoID INT NOT NULL PRIMARY KEY,
    NomeProduto VARCHAR(200) NOT NULL,
    Categoria VARCHAR(100) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL,

    CONTRAINT CK_Produtos_Preco CHECK (Preco >= 0)
);
GO

-- =============================================
-- TABELA FINAL: VENDAS
-- =============================================

IF OBJECT_ID('dbo.Vendas', 'U') IS NOT NULL
    DROP TABLE dbo.Vendas;
GO

CREATE TABLE dbo.Vendas
(
    VendaID INT NOT NULL PRIMARY KEY,
    ClienteID INT NOT NULL,
    ProdutoID INT NOT NULL,
    DataVenda DATE NOT NULL,
    Quantidade INT NOT NULL,
    ValorUnitario DECIMAL (10, 2) NOT NULL,
    ValorTotal DECIMAL (10, 2) NOT NULL,

    CONSTRAINT CK_Venda_Quantidade CHECK (Quantidade > 0),

    CONSTRAINT CK_Vendas_ValorUnitario CHECK (ValorUnitario > 0),

    CONSTRAINT CK_Vendas_ValorTotal CHECK (ValorTotal > 0),

    CONSTRAINT FK_Vendas_Clientes FOREIGN KEY (ClienteID) REFERENCES dbo.Clientes(ClientesID)

    CONSTRAINT FK_Vendas_Produtos FOREIGN KEY  (ProdutoID) REFERENCES dbo.Produtos(ProdutoID)
);
GO

PRINT 'Tabelas finais criadas com sucesso!';
GO