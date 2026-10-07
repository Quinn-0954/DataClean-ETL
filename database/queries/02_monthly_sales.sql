USE DataCleanDB;
GO

-- =============================================
-- FATURAMENTO POR MÊS
-- =============================================

SELECT
    YEAR(DataVenda) AS Ano,
    MONTH(DataVenda) AS Mes,
    COUNT(*) AS TotalVendas,
    SUM(Quantidade) AS ItensVendidos,
    SUM(ValorTotal) AS Faturamento
FROM dbo.Vendas
GROUP BY
    YEAR(DataVenda),
    MONTH(DataVenda)
ORDER BY
    Ano,
    Mes;
GO