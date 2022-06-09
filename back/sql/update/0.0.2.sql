-- add territory industry
CREATE TABLE industry_territory
(
    id                   SERIAL PRIMARY KEY,
    name                 hstore NOT NULL,
    national_identifying VARCHAR(8) NOT NULL,

    -- traceability
    created_at           TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMP          DEFAULT NULL,
    updated_by           INTEGER   NOT NULL
);

ALTER TABLE city
ADD COLUMN industry_territory_id INTEGER DEFAULT NULL;

ALTER TABLE city
    ADD FOREIGN KEY (industry_territory_id) REFERENCES industry_territory;