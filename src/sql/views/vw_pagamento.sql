-- Apagar view
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_pagamento]'))
DROP VIEW [dbo].[vw_pagamento]
GO

-- Criar View
CREATE VIEW [dbo].[vw_pagamento]
--WITH ENCRYPTION
AS
    SELECT

    pagamento.pag_id
    ,pagamento.con_id
    ,pagamento.pag_status
    ,pagamento.pag_data
    --,MONTH(pagamento.pag_data) AS pag_data_mes
    --,YEAR(pagamento.pag_data) AS pag_data_ano
    ,pag_data_vencimento
    /* Mês de vencimento, considerando 0 = janeiro */
    ,MONTH(pagamento.pag_data_vencimento) - 1 AS pag_data_vencimento_mes
    ,YEAR(pagamento.pag_data_vencimento) AS pag_data_vencimento_ano
    ,pagamento.pag_valor
    ,pagamento.pag_valor_pago

    ,proposta.prop_numero

    ,cliente.cli_cpfCnpj
    ,cliente.cli_nome
    ,cliente.cli_arquivo

    FROM pagamento AS pagamento

    INNER JOIN proposta AS proposta
    -- Proposta id = Contrato
    ON proposta.prop_id = pagamento.con_id

    INNER JOIN cliente AS cliente
    ON cliente.cli_id = proposta.cli_id
GO