USE DataCleanDB;
GO

-- =============================================
-- LIMPA OS DADOS FINAIS ANTES DE EXECUTAR NOVAMENTE
-- =============================================

DELETE FROM dbo.Vendas;
DELETE FROM dbo.Clientes;
DELETE FROM dbo.Produtos;
GO


-- =============================================
-- LIMPEZA E CARGA DE CLIENTES
-- =============================================

INSERT INTO dbo.Clientes
(
    ClienteID,
    Nome,
    CPF,
    Email,
    Cidade,
    DataCadastro
)
SELECT
    TRY_CONVERT(INT, ClienteID) AS ClienteID,

    LTRIM(RTRIM(Nome)) AS Nome,

    LTRIM(RTRIM(CPF)) AS CPF,

    NULLIF(LTRIM(RTRIM(Email)), '') AS Email,

    CASE
        WHEN UPPER(LTRIM(RTRIM(Cidade))) IN
            ('SAO PAULO', 'SÃO PAULO')
            THEN 'São Paulo'
        ELSE LTRIM(RTRIM(Cidade))
    END AS Cidade,

    -- Formato brasileiro: DD/MM/AAAA
    TRY_CONVERT(DATE, DataCadastro, 103) AS DataCadastro

FROM dbo.STG_Clientes
WHERE
    TRY_CONVERT(INT, ClienteID) IS NOT NULL
    AND LTRIM(RTRIM(Nome)) <> ''
    AND LTRIM(RTRIM(CPF)) <> ''
    AND LTRIM(RTRIM(Cidade)) <> ''
    AND TRY_CONVERT(DATE, DataCadastro, 103) IS NOT NULL;
GO


-- =============================================
-- LIMPEZA E CARGA DE PRODUTOS
-- =============================================

INSERT INTO dbo.Produtos
(
    ProdutoID,
    NomeProduto,
    Categoria,
    Preco
)
SELECT
    TRY_CONVERT(INT, ProdutoID),
    LTRIM(RTRIM(NomeProduto)),
    LTRIM(RTRIM(Categoria)),
    TRY_CONVERT(DECIMAL(10, 2), Preco)

FROM dbo.STG_Produtos
WHERE
    TRY_CONVERT(INT, ProdutoID) IS NOT NULL
    AND LTRIM(RTRIM(NomeProduto)) <> ''
    AND LTRIM(RTRIM(Categoria)) <> ''
    AND TRY_CONVERT(DECIMAL(10, 2), Preco) > 0;
GO


-- =============================================
-- LIMPEZA E CARGA DE VENDAS
-- =============================================

INSERT INTO dbo.Vendas
(
    VendaID,
    ClienteID,
    ProdutoID,
    DataVenda,
    Quantidade,
    ValorUnitario,
    ValorTotal
)
SELECT
    TRY_CONVERT(INT, v.VendaID),
    TRY_CONVERT(INT, v.ClienteID),
    TRY_CONVERT(INT, v.ProdutoID),

    -- Formato brasileiro: DD/MM/AAAA
    TRY_CONVERT(DATE, v.DataVenda, 103),

    TRY_CONVERT(INT, v.Quantidade),
    TRY_CONVERT(DECIMAL(10, 2), v.ValorUnitario),
    TRY_CONVERT(DECIMAL(10, 2), v.ValorTotal)

FROM dbo.STG_Vendas v
WHERE
    TRY_CONVERT(INT, v.VendaID) IS NOT NULL
    AND TRY_CONVERT(INT, v.ClienteID) IS NOT NULL
    AND TRY_CONVERT(INT, v.ProdutoID) IS NOT NULL
    AND TRY_CONVERT(DATE, v.DataVenda, 103) IS NOT NULL
    AND TRY_CONVERT(INT, v.Quantidade) > 0
    AND TRY_CONVERT(DECIMAL(10, 2), v.ValorUnitario) > 0
    AND TRY_CONVERT(DECIMAL(10, 2), v.ValorTotal) > 0

    -- Garante que o cliente existe
    AND EXISTS (
        SELECT 1
        FROM dbo.Clientes c
        WHERE c.ClienteID = TRY_CONVERT(INT, v.ClienteID)
    )

    -- Garante que o produto existe
    AND EXISTS (
        SELECT 1
        FROM dbo.Produtos p
        WHERE p.ProdutoID = TRY_CONVERT(INT, v.ProdutoID)
    );
GO

PRINT 'Transformação e carga de dados concluída com sucesso!';
GO