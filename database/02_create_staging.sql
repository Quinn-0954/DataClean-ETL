USE DataCleanDB;
GO


-- =============================================
-- STAGING: CLIENTES
-- =============================================

IF OBJECT_ID('dbo.STG_Clientes', 'U') IS NOT NULL
    DROP TABLE dbo.STG_CLIENTES;
GO

CREATE TABLE EDBO.STG_CLIENTES
(
    ClienteID    VARCHAR(50),
    Nome         VARCHAR(200),
    CPF          VARCHAR(50),
    Email        VARCHAR(200),
    Cidade       VARCHAR(200),
    DataCadastro  VARCHAR(50)
);
GO


-- =============================================
-- STAGING: PRODUTOS
-- =============================================

IF OBJECT_ID('dbo.STG_Produtos', 'U') IS NOT NULL
    DROP TABLE dbo.STG_Produtos.
GO

CREATE TABLE dbo.STG_Produtos
(
    ProdutoID    VARCHAR(50),
    NomeProduto  VARCHAR(200),
    Categoria    VARCHAR(100),
    Preco        VARCHAR(50)
);
GO



-- =============================================
-- STAGING: VENDAS
-- =============================================

IF OBJECT_ID('dbo.STG_Vendas',  'U') IS NOT NULL
    DROP TABLE dbo.STG_VENDAS;
GO

CREATE TABLE dbo.STG_Vendas
(
    VendaID     VARCHAR(50),
    ClienteID   VARCHAR(50),
    ProdutoID   VARCHAR(50),
    Datavenda   VARCHAR(50),
    Quantidade  VARCHAR(50),
    ValorUnitario VARCHAR(50),
    ValorTotal  VARCHAR(50)
);
GO

PRINT 'Tabelas STAGING criadas com sucesso.';
GO