USE DataCleanDB;
GO

-- =============================================
-- CLASSIFICAÇÃO DOS CLIENTES POR FATURAMENTO
-- =============================================

WITH GastosClientes AS
(
    SELECT
        ClienteID,
        NomeCliente,
        Cidade,
        QuantidadeVendas,
        ItensComprados,
        TotalGasto
    FROM dbo.vw_VendasPorCliente
)

SELECT
    ClienteID,
    NomeCliente,
    Cidade,
    QuantidadeVendas,
    ItensComprados,
    TotalGasto,

    CASE
        WHEN TotalGasto >= 20000 THEN 'Alto Valor'
        WHEN TotalGasto >= 10000 THEN 'Valor Médio'
        ELSE 'Baixo Valor'
    END AS Classificacao

FROM GastosClientes
ORDER BY TotalGasto DESC;
GO