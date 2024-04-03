-- PEDIDO não possui id_vendendor, sendo necessário 2 JOIN:
-- Tabela enxuta ordenada pelo faturamento:
SELECT v.nome AS vendedor, SUM(p.valor_total) AS faturamento
FROM VENDEDORES v
JOIN CLIENTES c ON v.id_vendedor = c.id_vendedor
JOIN PEDIDO p ON c.id_cliente = p.id_cliente
GROUP BY v.nome
ORDER BY faturamento DESC;