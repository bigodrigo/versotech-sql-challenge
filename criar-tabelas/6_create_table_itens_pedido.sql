CREATE TABLE ITENS_PEDIDO (
    id_item_pedido SERIAL PRIMARY KEY,
    id_pedido INTEGER REFERENCES PEDIDO(id_pedido),
    id_produto INTEGER REFERENCES PRODUTOS(id_produto),
    preco_praticado NUMERIC(10, 2),
    quantidade INTEGER
);