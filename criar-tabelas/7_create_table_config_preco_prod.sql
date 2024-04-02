CREATE TABLE CONFIG_PRECO_PRODUTO (
    id_config_preco_produto SERIAL PRIMARY KEY,
    id_vendedor INTEGER REFERENCES VENDEDORES(id_vendedor),
    id_empresa INTEGER REFERENCES EMPRESA(id_empresa),
    id_produto INTEGER REFERENCES PRODUTOS(id_produto),
    preco_minimo NUMERIC(10, 2),
    preco_maximo NUMERIC(10, 2)
);