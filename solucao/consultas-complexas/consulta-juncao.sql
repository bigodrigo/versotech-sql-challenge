-- Versão 1 q n funcionou correto:

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

-- Desmembrando em partes, esta tabela demonstra os pedidos, os produtos, clientes, empresas o preço praticado e qual é o pedido mais atual para o mesmo produto, cliente e empresa!
SELECT 
    pe.id_pedido,
    ip.id_produto,
    pe.id_cliente,
    pe.id_empresa,
    ip.preco_praticado,
    MAX(pe.id_pedido) OVER (PARTITION BY ip.id_produto, pe.id_cliente, pe.id_empresa) AS ultima_config_pedido
FROM 
    ITENS_PEDIDO ip
JOIN 
    PEDIDO pe ON ip.id_pedido = pe.id_pedido;



-- Valor mínimo se não houver na anteriro:
INSERT INTO PRECOS_BASE (id_cliente, id_empresa, id_produto, preco_base)
SELECT 
    cp.id_cliente,
    cp.id_empresa,
    cp.id_produto,
    cp.preco_minimo
FROM 
    CONFIG_PRECO_PRODUTO cp
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM ITENS_PEDIDO ip
        JOIN PEDIDO pe ON ip.id_pedido = pe.id_pedido
        WHERE 
            ip.id_produto = cp.id_produto 
            AND pe.id_empresa = cp.id_empresa 
            AND pe.id_cliente = cp.id_cliente
    );
