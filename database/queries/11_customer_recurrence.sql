USE DataCleanDB;
GO

-- =============================================
-- ANÁLISE DE RECORRÊNCIA DOS CLIENTES
-- =============================================

WITH RecorrenciaClientes AS
(
    SELECT
        c.ClienteID,
        c.Nome AS NomeCliente,
        c.Cidade,
        COUNT(v.VendaID) AS QuantidadeVendas,
        SUM(v.Quantidade) AS ItensComprados,
        SUM(v.ValorTotal) AS TotalGasto
    FROM dbo.Clientes AS c
    INNER JOIN dbo.Vendas AS v
        ON c.ClienteID = v.ClienteID
    GROUP BY
        c.ClienteID,
        c.Nome,
        c.Cidade
)

SELECT
    ClienteID,
    NomeCliente,
    Cidade,
    QuantidadeVendas,
    ItensComprados,
    TotalGasto,

    CASE
        WHEN QuantidadeVendas >= 15 THEN 'Alta Recorrência'
        WHEN QuantidadeVendas >= 8 THEN 'Média Recorrência'
        ELSE 'Baixa Recorrência'
    END AS ClassificacaoRecorrencia

FROM RecorrenciaClientes
ORDER BY QuantidadeVendas DESC;
GO