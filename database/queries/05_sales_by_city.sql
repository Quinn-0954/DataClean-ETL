USE DataCleanDB;
GO

-- =============================================
-- FATURAMENTO POR CIDADE
-- =============================================

SELECT
   c.Cidade,
   COUNT(v.VendaID) AS QuantidadeVendas,
   SUM(v.Quantidade) AS ItensVendidos,
   SUM(v.ValorTotal) AS Faturamento,
   AVG(v.ValorTotal) AS TicketMedio
   FROM dbo.Vendas AS v

   INNER JOIN dbo.Clientes AS c
    ON v.ClienteID = c.ClienteID


 GROUP BY c.Cidade


 ORDER BY Faturamento DESC;
 GO