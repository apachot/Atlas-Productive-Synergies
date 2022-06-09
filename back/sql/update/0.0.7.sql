
-- product and product relation

CREATE TYPE recommendation_type AS ENUM ('CUSTOMER', 'SUPPLIER', 'PRODUCT', 'PARTNERSHIP', 'PRODUCTION_UNIT');

CREATE TABLE recommendation
(
    id                           SERIAL PRIMARY KEY,
    type                         recommendation_type NOT NULL,
    establishment_id             INTEGER NOT NULL,
    data                         json NOT NULL,
    expired_at                   TIMESTAMP DEFAULT NULL,
    fake                         BOOLEAN DEFAULT FALSE,

    -- traceability
    created_at TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP           DEFAULT NULL,
    updated_by INTEGER    NOT NULL
);

ALTER TABLE recommendation
    ADD FOREIGN KEY (establishment_id) REFERENCES establishment;
