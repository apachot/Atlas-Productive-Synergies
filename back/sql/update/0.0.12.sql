
-- product and product relation

DROP TABLE product_relation;
DROP TYPE relation_type;

CREATE TYPE relation_type AS ENUM ('PARTNER');

CREATE TABLE relation
(
    id                           SERIAL PRIMARY KEY,
    type                         relation_type,
    establishment_id             INTEGER NOT NULL,
    secondary_establishment_id   INTEGER NOT NULL,
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

ALTER TABLE relation
    ADD FOREIGN KEY (establishment_id) REFERENCES establishment ON DELETE CASCADE;
ALTER TABLE relation
    ADD FOREIGN KEY (secondary_establishment_id) REFERENCES establishment ON DELETE CASCADE;

CREATE INDEX relation_establishment_id_idx
    ON relation (establishment_id);
CREATE INDEX relation_secondary_establishment_id_idx
    ON relation (secondary_establishment_id);
