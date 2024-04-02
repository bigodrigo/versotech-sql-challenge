CREATE TABLE CLIENTES (
    id_cliente SERIAL PRIMARY KEY,
    razao_social VARCHAR(100) NOT NULL,
    data_cadastro DATE,
    id_vendedor INTEGER REFERENCES VENDEDORES(id_vendedor),
    id_empresa INTEGER REFERENCES EMPRESA(id_empresa),
    inativo BOOLEAN DEFAULT FALSE
);