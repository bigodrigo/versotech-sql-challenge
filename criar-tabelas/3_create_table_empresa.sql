CREATE TABLE EMPRESA (
    id_empresa SERIAL PRIMARY KEY,
    razao_social VARCHAR(100) NOT NULL,
    inativo BOOLEAN DEFAULT FALSE
);