CREATE TABLE PEDIDO (
    id_pedido SERIAL PRIMARY KEY,
    id_empresa INTEGER REFERENCES EMPRESA(id_empresa),
    id_cliente INTEGER REFERENCES CLIENTES(id_cliente),
    valor_total NUMERIC(10, 2),
    data_emissao DATE,
    situacao VARCHAR(50)
);