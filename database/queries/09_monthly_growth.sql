USE DataCleanDB;
GO

-- =============================================
-- CRESCIMENTO MENSAL DO FATURAMENTO
-- =============================================

WITH FaturamentoMensal AS
(
    SELECT
        YEAR(DataVenda) AS Ano,
        MONTH(DataVenda) AS Mes,
        SUM(ValorTotal) AS Faturamento
    FROM dbo.Vendas
    GROUP BY
        YEAR(DataVenda),
        MONTH(DataVenda)
),

ComparacaoMensal AS
(
    SELECT
        Ano,
        Mes,
        Faturamento,

        LAG(Faturamento) OVER (
            ORDER BY Ano, Mes
        ) AS FaturamentoMesAnterior

    FROM FaturamentoMensal
)

SELECT
    Ano,
    Mes,
    Faturamento,
    FaturamentoMesAnterior,

    Faturamento - FaturamentoMesAnterior
        AS VariacaoValor,

    CASE
        WHEN FaturamentoMesAnterior IS NULL THEN NULL
        WHEN FaturamentoMesAnterior = 0 THEN NULL
        ELSE
            ((Faturamento - FaturamentoMesAnterior) * 100.0)
            / FaturamentoMesAnterior
    END AS VariacaoPercentual

FROM ComparacaoMensal
ORDER BY
    Ano,
    Mes;
GO