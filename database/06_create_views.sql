USE DataCleanDB;
GO

-- =============================================
-- VIEW: VISÃO COMPLETA DAS VENDAS
-- =============================================

CREATE OR ALTER VIEW dbo.vw_VendasCompletas
AS
SELECT
    v.VendaID,
    v.DataVenda,

    c.ClienteID,
    c.Nome AS NomeCliente,
    c.Cidade,

    p.ProdutoID,
    p.NomeProduto,
    p.Categoria,

    v.Quantidade,
    v.ValorUnitario,
    v.ValorTotal

FROM dbo.Vendas v

INNER JOIN dbo.Clientes c
    ON v.ClienteID = c.ClienteID

INNER JOIN dbo.Produtos p
    ON v.ProdutoID = p.ProdutoID;
GO


-- =============================================
-- VIEW: VENDAS POR CLIENTE
-- =============================================

CREATE OR ALTER VIEW dbo.vw_VendasPorCliente
AS
SELECT
    c.ClienteID,
    c.Nome AS NomeCliente,
    c.Cidade,

    COUNT(v.VendaID) AS QuantidadeVendas,
    SUM(v.Quantidade) AS ItensComprados,
    SUM(v.ValorTotal) AS TotalGasto

FROM dbo.Clientes c

INNER JOIN dbo.Vendas v
    ON c.ClienteID = v.ClienteID

GROUP BY
    c.ClienteID,
    c.Nome,
    c.Cidade;
GO


-- =============================================
-- VIEW: VENDAS POR PRODUTO
-- =============================================

CREATE OR ALTER VIEW dbo.vw_VendasPorProduto
AS
SELECT
    p.ProdutoID,
    p.NomeProduto,
    p.Categoria,

    COUNT(v.VendaID) AS QuantidadeVendas,
    SUM(v.Quantidade) AS QuantidadeItensVendidos,
    SUM(v.ValorTotal) AS Faturamento

FROM dbo.Produtos p

INNER JOIN dbo.Vendas v
    ON p.ProdutoID = v.ProdutoID

GROUP BY
    p.ProdutoID,
    p.NomeProduto,
    p.Categoria;
GO


PRINT 'Views analíticas criadas com sucesso!';
GO