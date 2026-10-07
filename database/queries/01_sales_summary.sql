USE DataCleanDB;
GO

-- =============================================
-- RESUMO GERAL DAS VENDAS
-- =============================================

SELECT
    COUNT(*) AS TotalVendas,
    SUM(Quantidade) AS TotalItensVendidos,
    SUM(ValorTotal) AS FaturamentoTotal,
    AVG(ValorTotal) AS TicketMedio,
    MIN(ValorTotal) AS MenorVenda,
    MAX(ValorTotal) AS MaiorVenda
FROM dbo.Vendas;
GO