
-- product and product relation

CREATE TYPE relation_type AS ENUM ('CUSTOMER', 'SUPPLIER');

CREATE TABLE product
(
    id                           SERIAL PRIMARY KEY,
    establishment_id             INTEGER NOT NULL,
    nomenclature_product_id      INTEGER NOT NULL,
    gtin                         VARCHAR(20) DEFAULT '',
    name                         hstore NOT NULL,
    description                  hstore,
    ratio                        INTEGER DEFAULT 0,
    fake                         BOOLEAN,

    -- traceability
    created_at TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP           DEFAULT NULL,
    updated_by INTEGER    NOT NULL
);

CREATE TABLE product_relation
(
    id                           SERIAL PRIMARY KEY,
    product_id                   INTEGER NOT NULL,
    type                         relation_type,
    establishment_id             INTEGER NOT NULL,
    secondary_product_id         INTEGER,
    strength                     NUMERIC(7, 6) DEFAULT 0,
    public                       BOOLEAN,
    fake                         BOOLEAN,
    accepted                     BOOLEAN,

    -- traceability
    created_at TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP           DEFAULT NULL,
    updated_by INTEGER    NOT NULL
);

ALTER TABLE product
    ADD FOREIGN KEY (establishment_id) REFERENCES establishment ON DELETE CASCADE;
ALTER TABLE product
    ADD FOREIGN KEY (nomenclature_product_id) REFERENCES nomenclature_product;

ALTER TABLE product_relation
    ADD FOREIGN KEY (product_id) REFERENCES product ON DELETE CASCADE;
ALTER TABLE product_relation
    ADD FOREIGN KEY (establishment_id) REFERENCES establishment ON DELETE CASCADE;

