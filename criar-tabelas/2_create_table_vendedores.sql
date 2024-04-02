CREATE TABLE VENDEDORES (
    id_vendedor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    salario NUMERIC(10, 2),
    data_admissao DATE,
    inativo BOOLEAN DEFAULT FALSE
);