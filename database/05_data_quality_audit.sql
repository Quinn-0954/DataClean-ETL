USE DataCleanDB;
GO

-- =============================================
-- RELATÓRIO GERAL DE QUALIDADE DOS DADOS
-- =============================================

SELECT
    'Clientes' AS Tabela,
    (SELECT COUNT(*) FROM dbo.STG_Clientes) AS RegistrosOriginais,
    (SELECT COUNT(*) FROM dbo.Clientes) AS RegistrosValidos,
    (SELECT COUNT(*) FROM dbo.STG_Clientes)
        - (SELECT COUNT(*) FROM dbo.Clientes) AS RegistrosDescartados,
    CAST(
        (SELECT COUNT(*) FROM dbo.Clientes) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM dbo.STG_Clientes), 0)
        AS DECIMAL(5,2)
    ) AS PercentualAproveitamento

UNION ALL

SELECT
    'Produtos',
    (SELECT COUNT(*) FROM dbo.STG_Produtos),
    (SELECT COUNT(*) FROM dbo.Produtos),
    (SELECT COUNT(*) FROM dbo.STG_Produtos)
        - (SELECT COUNT(*) FROM dbo.Produtos),
    CAST(
        (SELECT COUNT(*) FROM dbo.Produtos) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM dbo.STG_Produtos), 0)
        AS DECIMAL(5,2)
    ) AS PercentualAproveitamento

UNION ALL

SELECT
    'Vendas',
    (SELECT COUNT(*) FROM dbo.STG_Vendas),
    (SELECT COUNT(*) FROM dbo.Vendas),
    (SELECT COUNT(*) FROM dbo.STG_Vendas)
        - (SELECT COUNT(*) FROM dbo.Vendas) AS RegistrosDescartados,
    CAST(
        (SELECT COUNT(*) FROM dbo.Vendas) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM dbo.STG_Vendas), 0)
        AS DECIMAL(5,2)
    ) AS PercentualAproveitamento;
GO

-- =============================================
-- PRODUTOS DESCARTADOS
-- =============================================

SELECT
    ProdutoID,
    NomeProduto,
    Categoria,
    Preco,

    CASE
        WHEN TRY_CONVERT(INT, ProdutoID) IS NULL
            THEN 'ProdutoID inválido'

        WHEN LTRIM(RTRIM(NomeProduto)) = ''
            THEN 'Nome do produto vazio'

        WHEN LTRIM(RTRIM(Categoria)) = ''
            THEN 'Categoria vazia'

        WHEN TRY_CONVERT(DECIMAL(10,2), Preco) IS NULL
            THEN 'Preço inválido'

        WHEN TRY_CONVERT(DECIMAL(10,2), Preco) <= 0
            THEN 'Preço menor ou igual a zero'

        ELSE 'Outro motivo'
    END AS MotivoDescarte

FROM dbo.STG_Produtos
WHERE
    TRY_CONVERT(INT, ProdutoID) IS NULL
    OR LTRIM(RTRIM(NomeProduto)) = ''
    OR LTRIM(RTRIM(Categoria)) = ''
    OR TRY_CONVERT(DECIMAL(10,2), Preco) IS NULL
    OR TRY_CONVERT(DECIMAL(10,2), Preco) <= 0;
GO


-- =============================================
-- VENDAS DESCARTADAS - ANÁLISE DE MOTIVOS
-- =============================================

SELECT
    v.VendaID,
    v.ClienteID,
    v.ProdutoID,
    v.DataVenda,
    v.Quantidade,
    v.ValorUnitario,
    v.ValorTotal,

    CASE
        WHEN TRY_CONVERT(INT, v.VendaID) IS NULL
            THEN 'VendaID inválido'

        WHEN TRY_CONVERT(INT, v.ClienteID) IS NULL
            THEN 'ClienteID inválido'

        WHEN TRY_CONVERT(INT, v.ProdutoID) IS NULL
            THEN 'ProdutoID inválido'

        WHEN TRY_CONVERT(DATE, v.DataVenda, 103) IS NULL
            THEN 'Data de venda inválida'

        WHEN TRY_CONVERT(INT, v.Quantidade) IS NULL
             OR TRY_CONVERT(INT, v.Quantidade) <= 0
            THEN 'Quantidade inválida'

        WHEN TRY_CONVERT(DECIMAL(10,2), v.ValorUnitario) IS NULL
             OR TRY_CONVERT(DECIMAL(10,2), v.ValorUnitario) <= 0
            THEN 'Valor unitário inválido'

        WHEN TRY_CONVERT(DECIMAL(10,2), v.ValorTotal) IS NULL
             OR TRY_CONVERT(DECIMAL(10,2), v.ValorTotal) <= 0
            THEN 'Valor total inválido'

        WHEN NOT EXISTS (
            SELECT 1
            FROM dbo.Clientes c
            WHERE c.ClienteID = TRY_CONVERT(INT, v.ClienteID)
        )
            THEN 'Cliente não encontrado'

        WHEN NOT EXISTS (
            SELECT 1
            FROM dbo.Produtos p
            WHERE p.ProdutoID = TRY_CONVERT(INT, v.ProdutoID)
        )
            THEN 'Produto não encontrado'

        ELSE 'Outro motivo'
    END AS MotivoDescarte

FROM dbo.STG_Vendas v

WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Vendas vf
    WHERE vf.VendaID = TRY_CONVERT(INT, v.VendaID)
);
GO

-- =============================================
-- RESUMO DOS MOTIVOS DE DESCARTE DE VENDAS
-- =============================================

WITH VendasDescartadas AS
(
    SELECT
        CASE
            WHEN TRY_CONVERT(INT, v.VendaID) IS NULL
                THEN 'VendaID inválido'

            WHEN TRY_CONVERT(INT, v.ClienteID) IS NULL
                THEN 'ClienteID inválido'

            WHEN TRY_CONVERT(INT, v.ProdutoID) IS NULL
                THEN 'ProdutoID inválido'

            WHEN TRY_CONVERT(DATE, v.DataVenda, 103) IS NULL
                THEN 'Data de venda inválida'

            WHEN TRY_CONVERT(INT, v.Quantidade) IS NULL
                 OR TRY_CONVERT(INT, v.Quantidade) <= 0
                THEN 'Quantidade inválida'

            WHEN TRY_CONVERT(DECIMAL(10,2), v.ValorUnitario) IS NULL
                 OR TRY_CONVERT(DECIMAL(10,2), v.ValorUnitario) <= 0
                THEN 'Valor unitário inválido'

            WHEN TRY_CONVERT(DECIMAL(10,2), v.ValorTotal) IS NULL
                 OR TRY_CONVERT(DECIMAL(10,2), v.ValorTotal) <= 0
                THEN 'Valor total inválido'

            WHEN NOT EXISTS (
                SELECT 1
                FROM dbo.Clientes c
                WHERE c.ClienteID = TRY_CONVERT(INT, v.ClienteID)
            )
                THEN 'Cliente não encontrado'

            WHEN NOT EXISTS (
                SELECT 1
                FROM dbo.Produtos p
                WHERE p.ProdutoID = TRY_CONVERT(INT, v.ProdutoID)
            )
                THEN 'Produto não encontrado'

            ELSE 'Outro motivo'
        END AS MotivoDescarte

    FROM dbo.STG_Vendas v
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Vendas vf
        WHERE vf.VendaID = TRY_CONVERT(INT, v.VendaID)
    )
)

SELECT
    MotivoDescarte,
    COUNT(*) AS Quantidade
FROM VendasDescartadas
GROUP BY MotivoDescarte
ORDER BY Quantidade DESC;
GO