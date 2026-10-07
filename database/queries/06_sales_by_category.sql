USE DataCleanDB;
GO

-- =============================================
-- FATURAMENTO POR CATEGORIA
-- =============================================

SELECT
    p.Categoria,
    COUNT(v.VendaID) AS QuantidadeVendas,
    SUM(v.Quantidade) AS ItensVendidos,
    SUM(v.ValorTotal) AS Faturamento,
    AVG(v.ValorTotal) AS TicketMedio
FROM dbo.Vendas AS v

INNER JOIN dbo.Produtos AS p
    ON v.ProdutoID = p.ProdutoID

GROUP BY
    p.Categoria

ORDER BY
    Faturamento DESC;
GO