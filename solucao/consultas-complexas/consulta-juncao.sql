-- Solução para buscar todas as informações pedidas, o preço praticado, o pedido mais atual e as informações de intervalo.
SELECT 
	pe.id_pedido,
    ip.id_produto,
    p.descricao AS descricao_produto,
    pe.id_cliente,
    c.razao_social AS razao_social_cliente,
    c.id_vendedor,
    v.nome AS nome_vendedor,
    pe.id_empresa,
    e.razao_social AS razao_social_empresa,
    ip.preco_praticado AS preco_praticado_no_pedido,
    MAX(pe.id_pedido) OVER (PARTITION BY ip.id_produto, pe.id_empresa) AS pedido_mais_atual,
    CASE 
        WHEN cp.preco_minimo IS NULL THEN 'Sem configuração'
        ELSE cp.preco_minimo::TEXT
    END AS preco_minimo,
    CASE 
        WHEN cp.preco_maximo IS NULL THEN 'Sem configuração'
        ELSE cp.preco_maximo::TEXT
    END AS preco_maximo,
    CASE
        WHEN cp.preco_minimo IS NULL OR cp.preco_maximo IS NULL THEN 'Sem configuração'
        WHEN ip.preco_praticado >= cp.preco_minimo AND ip.preco_praticado <= cp.preco_maximo THEN 'Dentro do Intervalo'
        ELSE 'Fora do Intervalo'
    END AS situacao_preco
FROM 
    ITENS_PEDIDO ip
JOIN 
    PEDIDO pe ON ip.id_pedido = pe.id_pedido
LEFT JOIN 
    CONFIG_PRECO_PRODUTO cp ON ip.id_produto = cp.id_produto AND pe.id_empresa = cp.id_empresa
LEFT JOIN 
    PRODUTOS p ON ip.id_produto = p.id_produto
LEFT JOIN 
    CLIENTES c ON pe.id_cliente = c.id_cliente
LEFT JOIN 
    VENDEDORES v ON c.id_vendedor = v.id_vendedor
LEFT JOIN 
    EMPRESA e ON pe.id_empresa = e.id_empresa;