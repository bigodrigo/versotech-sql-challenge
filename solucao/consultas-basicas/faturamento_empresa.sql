-- Pode ser interessante mostrar o id_cliente:
-- SELECT c.id_cliente, c.razao_social AS cliente, SUM(p.valor_total) AS faturamento
-- Tabela enxuta ordenada pelo faturamento:
SELECT e.razao_social AS empresa, SUM(p.valor_total) AS faturamento
FROM EMPRESA e
JOIN PEDIDO p ON e.id_empresa = p.id_empresa
GROUP BY e.razao_social
ORDER BY faturamento DESC;

-- Podemos ordenar pela razão social ou "nome":
-- ORDER BY e.razao_social;