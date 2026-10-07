USE DataCleanDB;
GO

-- =============================================
-- RANKING DE PRODUTOS POR FATURAMENTO
-- =============================================

WITH RankingProdutos AS
(
    SELECT
        ProdutoID,
        NomeProduto,
        Categoria,
        QuantidadeVendas,
        QuantidadeItensVendidos,
        Faturamento,

        RANK() OVER (
            ORDER BY Faturamento DESC
        ) AS Ranking

    FROM dbo.vw_VendasPorProduto
)

SELECT
    Ranking,
    ProdutoID,
    NomeProduto,
    Categoria,
    QuantidadeVendas,
    QuantidadeItensVendidos,
    Faturamento
FROM RankingProdutos
ORDER BY Ranking;
GO