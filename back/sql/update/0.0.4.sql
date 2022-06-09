

ALTER TABLE address
    ADD COLUMN y_val VARCHAR(2),
    ADD COLUMN z_val VARCHAR(25);

ALTER TABLE establishment
    ADD COLUMN siege           BOOLEAN;

CREATE INDEX address_z_val_idx ON address (z_val);
CREATE INDEX city_insee_code_idx ON city (insee_code);

CREATE INDEX company_siren_idx ON company (siren);
CREATE INDEX company_z_val_idx ON company (z_val);

CREATE INDEX establishment_siret_idx ON establishment (siret);
CREATE INDEX establishment_z_val_idx ON establishment (z_val);

