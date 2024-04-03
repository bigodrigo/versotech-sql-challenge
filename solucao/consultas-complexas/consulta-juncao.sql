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


-- COMENTÁRIOS
-- Desmembrando em partes, esta tabela demonstra os pedidos, os produtos, clientes, empresas o preço praticado e qual é o pedido mais atual para o mesmo produto, cliente e empresa!
SELECT 
    pe.id_pedido,
    ip.id_produto,
    pe.id_cliente,
    pe.id_empresa,
    ip.preco_praticado,
    MAX(pe.id_pedido) OVER (PARTITION BY ip.id_produto, pe.id_empresa) AS ultima_config_pedido
FROM 
    ITENS_PEDIDO ip
JOIN 
    PEDIDO pe ON ip.id_pedido = pe.id_pedido;


-- Consulta na config:
    SELECT 
    id_config_preco_produto,
    id_vendedor,
    id_empresa,
    id_produto,
    preco_minimo,
    preco_maximo
FROM 
    CONFIG_PRECO_PRODUTO;




-- Valores dentro do min e máximo:
SELECT 
	pe.id_pedido,
    ip.id_produto,
    pe.id_cliente,
    pe.id_empresa,
    ip.preco_praticado,
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
    CONFIG_PRECO_PRODUTO cp ON ip.id_produto = cp.id_produto AND pe.id_empresa = cp.id_empresa;


-- Tudo?
SELECT 
    pe.id_pedido,
    ip.id_produto,
    pe.id_cliente,
    pe.id_empresa,
    ip.preco_praticado,
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

UNION ALL

SELECT 
    NULL AS id_pedido,
    cp.id_produto,
    NULL AS id_cliente,
    cp.id_empresa,
    NULL AS preco_praticado,
    CASE 
        WHEN cp.preco_minimo IS NULL THEN 'Sem configuração'
        ELSE cp.preco_minimo::TEXT
    END AS preco_minimo,
    CASE 
        WHEN cp.preco_maximo IS NULL THEN 'Sem configuração'
        ELSE cp.preco_maximo::TEXT
    END AS preco_maximo,
    'Sem configuração' AS situacao_preco
FROM 
    CONFIG_PRECO_PRODUTO cp
LEFT JOIN 
    (
        SELECT 
            DISTINCT ip.id_produto,
            pe.id_empresa
        FROM 
            ITENS_PEDIDO ip
        JOIN 
            PEDIDO pe ON ip.id_pedido = pe.id_pedido
    ) AS pedido_info ON cp.id_produto = pedido_info.id_produto AND cp.id_empresa = pedido_info.id_empresa
WHERE 
    pedido_info.id_produto IS NULL
    OR pedido_info.id_empresa IS NULL;
