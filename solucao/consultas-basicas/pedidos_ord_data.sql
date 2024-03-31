-- Tabela enxuta:
SELECT data_emissao, id_empresa, id_cliente, valor_total
FROM PEDIDO
ORDER BY data_emissao;

-- Tabela Completa:
-- SELECT * FROM PEDIDO ORDER BY data_emissao;
-- OU 
-- SELECT id_pedido, id_empresa, id_cliente, valor_total, data_emissao, situacao
-- FROM PEDIDO ORDER BY data_emissao;