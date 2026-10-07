USE DataCleanDB;
GO

-- =============================================
-- PARTICIPAÇÃO DAS CATEGORIAS NO FATURAMENTO
-- =============================================

WITH FaturamentoCategorias AS
(
    SELECT
        p.Categoria,
        SUM(v.ValorTotal) AS Faturamento
    FROM dbo.Vendas AS v
    INNER JOIN dbo.Produtos AS p
        ON v.ProdutoID = p.ProdutoID
    GROUP BY p.Categoria
)

SELECT
    Categoria,
    Faturamento,

    SUM(Faturamento) OVER () AS FaturamentoTotal,

    (Faturamento * 100.0)
        / SUM(Faturamento) OVER () AS PercentualFaturamento

FROM FaturamentoCategorias
ORDER BY Faturamento DESC;
GO