-- Pode ser interessante mostrar o id_cliente:
-- SELECT c.id_cliente, c.razao_social AS cliente, SUM(p.valor_total) AS faturamento
-- Tabela enxuta ordenada pelo faturamento:
SELECT c.razao_social AS cliente, SUM(p.valor_total) AS faturamento
FROM CLIENTES c
JOIN PEDIDO p ON c.id_cliente = p.id_cliente
GROUP BY c.razao_social
ORDER BY faturamento DESC;

-- Podemos ordenar pela razão social ou "nome":
-- ORDER BY faturamento c.razao_social;
