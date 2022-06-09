
-- Establishment common information

ALTER TABLE establishment
    ADD COLUMN description  hstore,
    ADD COLUMN phone_fix    VARCHAR(20),
    ADD COLUMN phone_mobile VARCHAR(20),
    ADD COLUMN web_site     VARCHAR(255);

ALTER TABLE product_relation
    ALTER COLUMN product_id DROP NOT NULL;
