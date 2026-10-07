USE DataCleanDB;
GO

-- =============================================
-- TOP 10 PRODUTOS POR FATURAMENTO
-- =============================================

SELECT TOP 10
    ProdutoID,
    NomeProduto,
    Categoria,
    QuantidadeVendas,
    QuantidadeItensVendidos,
    Faturamento
FROM dbo.vw_VendasPorProduto
ORDER BY Faturamento DESC;
GO