SELECT 
    p.id_produto,
    p.descricao AS descricao_produto,
    c.id_cliente,
    c.razao_social AS razao_social_cliente,
    pe.id_empresa,
    e.razao_social AS razao_social_empresa,
    v.id_vendedor,
    v.nome AS nome_vendedor,
    cp.preco_minimo,
    cp.preco_maximo,
    COALESCE(ip.preco_praticado, cp.preco_minimo) AS preco_base
FROM 
    PRODUTOS p
JOIN 
    CONFIG_PRECO_PRODUTO cp ON p.id_produto = cp.id_produto
JOIN 
    CLIENTES c ON cp.id_empresa = c.id_empresa
JOIN 
    PEDIDO pe ON c.id_cliente = pe.id_cliente AND cp.id_empresa = pe.id_empresa
JOIN 
    EMPRESA e ON pe.id_empresa = e.id_empresa
JOIN 
    VENDEDORES v ON c.id_vendedor = v.id_vendedor
LEFT JOIN 
    (
        SELECT 
            ip.id_produto,
            ip.id_pedido,
            MAX(data_emissao) AS ultima_compra_data
        FROM 
            PEDIDO pe
        JOIN 
            ITENS_PEDIDO ip ON pe.id_pedido = ip.id_pedido
        GROUP BY 
            ip.id_produto, ip.id_pedido
    ) AS ultima_compra ON cp.id_produto = ultima_compra.id_produto AND pe.id_pedido = ultima_compra.id_pedido
LEFT JOIN 
    ITENS_PEDIDO ip ON ultima_compra.ultima_compra_data = pe.data_emissao AND ultima_compra.id_produto = ip.id_produto;
