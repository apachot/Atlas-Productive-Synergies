-- IAT API v
SET client_encoding = 'UTF8';
SET row_security = off;
SET default_tablespace = '';
SET default_with_oids = false;

CREATE EXTENSION IF NOT EXISTS hstore;

-- -----------------
-- Global management

CREATE TABLE app_config
(
    app_key       VARCHAR(255) PRIMARY KEY,
    app_value     VARCHAR(255),
    app_value_two VARCHAR(255)       DEFAULT NULL,

    -- traceability
    created_at    TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at    TIMESTAMP          DEFAULT NULL,
    updated_by    INTEGER   NOT NULL
);

-- -----------------
-- Cities management

CREATE TABLE address
(
    id                   SERIAL PRIMARY KEY,
    city_id              INTEGER,
    cedex                VARCHAR(9),
    cedex_label          VARCHAR(100),
    complement           text,
    coordinates          point,
    repetition_index     VARCHAR(5),
    special_distribution VARCHAR(50),
    way_label            VARCHAR(100),
    way_number           VARCHAR(6),
    way_type             VARCHAR(25),

    -- traceability
    created_at           TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at           TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at           TIMESTAMP          DEFAULT NULL,
    updated_by           INTEGER   NOT NULL
);

CREATE TABLE city
(
    id            SERIAL PRIMARY KEY,
    coordinates   point,
    department_id INTEGER,
    insee_code    VARCHAR(7) NOT NULL,
    name          hstore     NOT NULL,
    slug          VARCHAR(255),
    zip_code      VARCHAR(7),

    -- traceability
    created_at    TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at    TIMESTAMP           DEFAULT NULL,
    updated_by    INTEGER    NOT NULL
);

CREATE TABLE country
(
    id         SERIAL PRIMARY KEY,
    iso31663   VARCHAR(3),
    long_name  hstore    NOT NULL,
    name       hstore    NOT NULL,

    -- traceability
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP          DEFAULT NULL,
    updated_by INTEGER   NOT NULL
);

CREATE TABLE department
(
    id         SERIAL PRIMARY KEY,
    code       VARCHAR(4),
    region_id  INTEGER   NOT NULL,
    name       hstore    NOT NULL,
    slug       VARCHAR(255),

    -- traceability
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP          DEFAULT NULL,
    updated_by INTEGER   NOT NULL
);

CREATE TABLE region
(
    id         SERIAL PRIMARY KEY,
    code       VARCHAR(4),
    country_id INTEGER   NOT NULL,
    name       hstore    NOT NULL,
    slug       VARCHAR(255),

    -- traceability
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP          DEFAULT NULL,
    updated_by INTEGER   NOT NULL
);

-- -----------------------
-- Nomenclature management

CREATE TABLE nomenclature_activity
(
    id                 SERIAL PRIMARY KEY,
    code               VARCHAR(7) NOT NULL,
    macro_sector_id    INTEGER,
    name_ref2          hstore     NOT NULL,
    parent_activity_id INTEGER             DEFAULT NULL,
    section_id         INTEGER    NOT NULL,
    -- traceability
    created_at         TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at         TIMESTAMP           DEFAULT NULL,
    updated_by         INTEGER    NOT NULL
);

CREATE TABLE nomenclature_activity_product_proximity
(
    id            SERIAL PRIMARY KEY,
    activity_naf2 VARCHAR(7)    NOT NULL,
    product_hs4   VARCHAR(4)    NOT NULL,
    proximity     NUMERIC(7, 6) NOT NULL,

    -- traceability
    created_at    TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMP     NOT NULL DEFAULT NOW(),
    deleted_at    TIMESTAMP              DEFAULT NULL,
    updated_by    INTEGER       NOT NULL
);

CREATE TABLE nomenclature_activity_section
(
    id         SERIAL PRIMARY KEY,
    code       VARCHAR(10) NOT NULL,
    name_naf2  hstore      not null,
    -- traceability
    created_at TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP   NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP            DEFAULT NULL,
    updated_by INTEGER     NOT NULL
);

CREATE TABLE nomenclature_link_activity_rome
(
    id                SERIAL PRIMARY KEY,
    activity_naf_code VARCHAR(7)   NOT NULL,
    rome_code         VARCHAR(7)   NOT NULL,

    -- traceability
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at        TIMESTAMP          DEFAULT NULL,
    updated_by        INTEGER   NOT NULL
);

CREATE TABLE nomenclature_product
(
    id                 SERIAL PRIMARY KEY,
    code_cpf4          VARCHAR(4),
    code_cpf6          VARCHAR(6),
    code_hs4           VARCHAR(4)  NOT NULL,
    code_nc            VARCHAR(10) NOT NULL,
    macro_sector_id    INTEGER,
    name               hstore      NOT NULL,
    product_chapter_id INTEGER     NOT NULL,

    -- traceability
    created_at         TIMESTAMP   NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMP   NOT NULL DEFAULT NOW(),
    deleted_at         TIMESTAMP            DEFAULT NULL,
    updated_by         INTEGER     NOT NULL
);

CREATE TABLE nomenclature_product_chapter
(
    id                 SERIAL PRIMARY KEY,
    name               hstore,
    product_section_id INTEGER   NOT NULL,
    short_name         VARCHAR(255),

    -- traceability
    created_at         TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at         TIMESTAMP          DEFAULT NULL,
    updated_by         INTEGER   NOT NULL
);

CREATE TABLE nomenclature_product_proximity
(
    id                         SERIAL PRIMARY KEY,
    main_product_code_hs4      VARCHAR(4) NOT NULL,
    proximity                  NUMERIC(7, 6),
    secondary_product_code_hs4 VARCHAR(4) NOT NULL,

    -- traceability
    created_at                 TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at                 TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at                 TIMESTAMP           DEFAULT NULL,
    updated_by                 INTEGER    NOT NULL
);

CREATE TABLE nomenclature_product_relationship
(
    id                         SERIAL PRIMARY KEY,
    main_product_code_hs4      VARCHAR(4) NOT NULL,
    secondary_product_code_hs4 VARCHAR(4) NOT NULL,
    strength                   NUMERIC(11, 10),

    -- traceability
    created_at                 TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at                 TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at                 TIMESTAMP           DEFAULT NULL,
    updated_by                 INTEGER    NOT NULL
);

CREATE TABLE nomenclature_product_section
(
    id              SERIAL PRIMARY KEY,
    macro_sector_id INTEGER,
    name            hstore    NOT NULL,
    short_name      VARCHAR(255),

    -- traceability
    created_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMP          DEFAULT NULL,
    updated_by      INTEGER   NOT NULL
);

CREATE TABLE nomenclature_rome
(
    id                     SERIAL PRIMARY KEY,
    code                   VARCHAR(7)   NOT NULL,
    name                   VARCHAR(255) NOT NULL,
    ogr                    VARCHAR(10)           DEFAULT NULL,
    professional_domain_id INTEGER      NOT NULL,

    -- traceability
    created_at             TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMP    NOT NULL DEFAULT NOW(),
    deleted_at             TIMESTAMP             DEFAULT NULL,
    updated_by             INTEGER      NOT NULL
);

CREATE TABLE nomenclature_rome_main_domain
(
    id         SERIAL PRIMARY KEY,
    code       VARCHAR(2)   NOT NULL,
    name       VARCHAR(255) NOT NULL,

    -- traceability
    created_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP    NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP             DEFAULT NULL,
    updated_by INTEGER      NOT NULL
);

CREATE TABLE nomenclature_rome_professional_domain
(
    id              SERIAL PRIMARY KEY,
    code            VARCHAR(4) NOT NULL,
    main_domaine_id INTEGER    NOT NULL,
    name            hstore     NOT NULL,

    -- traceability
    created_at      TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at      TIMESTAMP           DEFAULT NULL,
    updated_by      INTEGER    NOT NULL
);

--
-- visualisation management

CREATE TABLE macro_sector
(
    id         SERIAL PRIMARY KEY,
    code       VARCHAR(3) NOT NULL,
    name       hstore     NOT NULL,

    -- traceability
    created_at TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP           DEFAULT NULL,
    updated_by INTEGER    NOT NULL
);


-- ------------------
-- Company management

CREATE TABLE company
(
    id             SERIAL,

    address_id     INTEGER,
    name           text,
    siren          VARCHAR(9) NOT NULL,

    z_val          VARCHAR(25),

    -- traceability
    created_at     TIMESTAMP  NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP  NOT NULL DEFAULT NOW(),
    deleted_at     TIMESTAMP           DEFAULT NULL,
    updated_by     INTEGER    NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE establishment
(
    id                     SERIAL,

    address_id             INTEGER,
    administrative_status  BOOLEAN,
    company_id             INTEGER,
    creation_date          DATE,
    diffusion_status       BOOLEAN,
    employer_nature        BOOLEAN,
    history_status_number  INTEGER,
    history_start_date     DATE,
    label_1                hstore,
    label_2                hstore,
    label_3                hstore,
    main_activity_id       INTEGER,
    nic                    VARCHAR(5),
    secondary_address_id   INTEGER,
    sirene_updated_date    TIMESTAMP,
    siret                  VARCHAR(14),
    usual_name             VARCHAR(100),
    workforce_group        VARCHAR(4),
    workforce_year         VARCHAR(5),

    z_val                  VARCHAR(25),

    -- traceability
    created_at             TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at             TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at             TIMESTAMP          DEFAULT NULL,
    updated_by             INTEGER   NOT NULL,

    PRIMARY KEY (id)
);

-- -----------
-- Foreign Key

-- Cities
ALTER TABLE address
    ADD FOREIGN KEY (city_id) REFERENCES city;
ALTER TABLE region
    ADD FOREIGN KEY (country_id) REFERENCES country;
ALTER TABLE department
    ADD FOREIGN KEY (region_id) REFERENCES region;
ALTER TABLE city
    ADD FOREIGN KEY (department_id) REFERENCES department;
-- Nomenclature
ALTER TABLE nomenclature_activity
    ADD FOREIGN KEY (parent_activity_id) REFERENCES nomenclature_activity;
ALTER TABLE nomenclature_activity
    ADD FOREIGN KEY (section_id) REFERENCES nomenclature_activity_section;
ALTER TABLE nomenclature_product
    ADD FOREIGN KEY (product_chapter_id) REFERENCES nomenclature_product_chapter;
ALTER TABLE nomenclature_product
    ADD FOREIGN KEY (macro_sector_id) REFERENCES macro_sector;
ALTER TABLE nomenclature_product_chapter
    ADD FOREIGN KEY (product_section_id) REFERENCES nomenclature_product_section;
ALTER TABLE nomenclature_rome_professional_domain
    ADD FOREIGN KEY (main_domaine_id) REFERENCES nomenclature_rome_main_domain;
ALTER TABLE nomenclature_rome
    ADD FOREIGN KEY (professional_domain_id) REFERENCES nomenclature_rome_professional_domain;
-- visualisation
-- Company management
ALTER TABLE company
    ADD FOREIGN KEY (address_id) REFERENCES address;
ALTER TABLE establishment
    ADD FOREIGN KEY (address_id) REFERENCES address;
ALTER TABLE establishment
    ADD FOREIGN KEY (company_id) REFERENCES company;
ALTER TABLE establishment
    ADD FOREIGN KEY (main_activity_id) REFERENCES nomenclature_activity;
ALTER TABLE establishment
    ADD FOREIGN KEY (secondary_address_id) REFERENCES address;

-- -----
-- Index
CREATE INDEX nomenclature_product_code_hs4_idx ON nomenclature_product (code_hs4);
CREATE INDEX nomenclature_product_code_nc_idx ON nomenclature_product (code_nc);
CREATE INDEX city_zip_code_idx ON city (zip_code);


-- ----
-- Init
INSERT INTO app_config (app_key, app_value, updated_by)
VALUES ('database_version', '0.0.1', 0);

INSERT INTO macro_sector (id, code, name, updated_by)
VALUES
(1, 1, 'fr => "Animaux vivants et produits du r??gne animal"', 0),
(2, 2, 'fr => "Produits du r??gne v??g??tal"', 0),
(3, 3, 'fr => "Graisses et huiles animales ou v??g??tales??; produits de leur dissociation??; graisses alimentaires ??labor??es??; cires d''origine animale ou v??g??tale"', 0),
(4, 4, 'fr => "Produits des industries alimentaires??; boissons, liquides alcooliques et vinaigres??; tabac et succ??dan??s de tabac fabriqu??s"', 0),
(5, 5, 'fr => "Produits min??raux"', 0),
(6, 6, 'fr => "Produits des industries chimiques ou des industries connexes"', 0),
(7, 7, 'fr => "Mati??res plastiques et ouvrages en ces mati??res??; caoutchouc et ouvrages en caoutchouc"', 0),
(8, 8, 'fr => "Peaux, cuirs, pelleteries et ouvrages en ces mati??res??; articles de bourrellerie ou de sellerie??; articles de voyage, sacs ?? main et contenants similaires??; ouvrages en boyaux"', 0),
(9, 9, 'fr => "Bois, charbon de bois et ouvrages en bois??; li??ge et ouvrages en li??ge??; ouvrages de sparterie ou de vannerie"', 0),
(10, 10, 'fr => "P??tes de bois ou d''autres mati??res fibreuses cellulosiques??; papier ou carton ?? recycler (d??chets et rebuts)??; papier et ses applications"', 0),
(11, 11, 'fr => "Mati??res textiles et ouvrages en ces mati??res"', 0),
(12, 12, 'fr => "Chaussures, coiffures, parapluies, parasols, cannes, fouets, cravaches et leurs parties??; plumes appr??t??es et articles en plumes??; fleurs artificielles??; ouvrages en cheveux"', 0),
(13, 13, 'fr => "Ouvrages en pierres, pl??tre, ciment, amiante, mica ou mati??res analogues??; produits c??ramiques??; verre et ouvrages en verre"', 0),
(14, 14, 'fr => "Perles fines ou de culture, pierres gemmes ou similaires, m??taux pr??cieux, plaqu??s ou doubl??s de m??taux pr??cieux et ouvrages en ces mati??res??; bijouterie de fantaisie??; monnaies"', 0),
(15, 15, 'fr => "M??taux communs et ouvrages en ces m??taux"', 0),
(16, 16, 'fr => "Machines et appareils, mat??riel ??lectrique et leurs parties??; appareils d''enregistrement ou de reproduction du son, appareils d''enregistrement ou de reproduction des images et du son en t??l??vision, et parties et accessoires de ces appareils"', 0),
(17, 17, 'fr => "Mat??riel de transport"', 0),
(18, 18, 'fr => "Instruments et appareils d''optique, de photographie ou de cin??matographie, de mesure, de contr??le ou de pr??cision??; instruments et appareils m??dico-chirurgicaux??; horlogerie??; instruments de musique??; parties et accessoires de ces instruments ou appareils"', 0),
(19, 19, 'fr => "Autres produits"', 0),
(20, 20, 'fr => "TOTAL"', 0);

INSERT INTO nomenclature_product_section (id, macro_sector_id, name, short_name, updated_by)
VALUES
(1, 1, 'fr => "ANIMAUX VIVANTS ET PRODUITS DU R??GNE ANIMAL"', 'SECTION??I', 0),
(2, 2, 'fr => "PRODUITS DU R??GNE V??G??TAL"', 'SECTION??II', 0),
(3, 3, 'fr => "GRAISSES ET HUILES ANIMALES OU V??G??TALES; PRODUITS DE LEUR DISSOCIATION; GRAISSES ALIMENTAIRES ??LABOR??ES; CIRES D''ORIGINE ANIMALE OU V??G??TALE"', 'SECTION??III', 0),
(4, 4, 'fr => "PRODUITS DES INDUSTRIES ALIMENTAIRES; BOISSONS, LIQUIDES ALCOOLIQUES ET VINAIGRES; TABACS ET SUCC??DAN??S DE TABAC FABRIQU??S"', 'SECTION??IV', 0),
(5, 5, 'fr => "PRODUITS MIN??RAUX"', 'SECTION??V', 0),
(6, 6, 'fr => "PRODUITS DES INDUSTRIES CHIMIQUES OU DES INDUSTRIES CONNEXES"', 'SECTION??VI', 0),
(7, 7, 'fr => "MATI??RES PLASTIQUES ET OUVRAGES EN CES MATI??RES; CAOUTCHOUC ET OUVRAGES EN CAOUTCHOUC"', 'SECTION??VII', 0),
(8, 8, 'fr => "PEAUX, CUIRS, PELLETERIES ET OUVRAGES EN CES MATI??RES; ARTICLES DE BOURRELLERIE OU DE SELLERIE; ARTICLES DE VOYAGE, SACS ?? MAIN ET CONTENANTS SIMILAIRES; OUVRAGES EN BOYAUX"', 'SECTION??VIII', 0),
(9, 9, 'fr => "BOIS, CHARBON DE BOIS ET OUVRAGES EN BOIS; LI??GE ET OUVRAGES EN LI??GE; OUVRAGES DE SPARTERIE OU DE VANNERIE"', 'SECTION??IX', 0),
(10, 10, 'fr => "P??TES DE BOIS OU D''AUTRES MATI??RES FIBREUSES CELLULOSIQUES; PAPIER OU CARTON ?? RECYCLER (D??CHETS ET REBUTS); PAPIER ET SES APPLICATIONS"', 'SECTION??X', 0),
(11, 11, 'fr => "MATI??RES TEXTILES ET OUVRAGES EN CES MATI??RES"', 'SECTION??XI', 0),
(12, 12, 'fr => "CHAUSSURES, COIFFURES, PARAPLUIES, PARASOLS, CANNES, FOUETS, CRAVACHES ET LEURS PARTIES; PLUMES APPR??T??ES ET ARTICLES EN PLUMES; FLEURS ARTIFICIELLES; OUVRAGES EN CHEVEUX"', 'SECTION??XII', 0),
(13, 13, 'fr => "OUVRAGES EN PIERRES, PL??TRE, CIMENT, AMIANTE, MICA OU MATI??RES ANALOGUES; PRODUITS C??RAMIQUES; VERRE ET OUVRAGES EN VERRE"', 'SECTION??XIII', 0),
(14, 14, 'fr => "PERLES FINES OU DE CULTURE, PIERRES GEMMES OU SIMILAIRES, M??TAUX PR??CIEUX, PLAQU??S OU DOUBL??S DE M??TAUX PR??CIEUX ET OUVRAGES EN CES MATI??RES; BIJOUTERIE DE FANTAISIE; MONNAIES"', 'SECTION??XIV', 0),
(15, 15, 'fr => "M??TAUX COMMUNS ET OUVRAGES EN CES M??TAUX"', 'SECTION??XV', 0),
(16, 16, 'fr => "MACHINES ET APPAREILS, MAT??RIEL ??LECTRIQUE ET LEURS PARTIES; APPAREILS D''ENREGISTREMENT OU DE REPRODUCTION DU SON, APPAREILS D''ENREGISTREMENT OU DE REPRODUCTION DES IMAGES ET DU SON EN T??L??VISION, ET PARTIES ET ACCESSOIRES DE CES APPAREILS"', 'SECTION??XVI', 0),
(17, 17, 'fr => "MAT??RIEL DE TRANSPORT"', 'SECTION??XVII', 0),
(18, 18, 'fr => "INSTRUMENTS ET APPAREILS D''OPTIQUE, DE PHOTOGRAPHIE OU DE CIN??MATOGRAPHIE, DE MESURE, DE CONTR??LE OU DE PR??CISION; INSTRUMENTS ET APPAREILS M??DICO-CHIRURGICAUX; HORLOGERIE; INSTRUMENTS DE MUSIQUE; PARTIES ET ACCESSOIRES DE CES INSTRUMENTS OU APPAREILS"', 'SECTION??XVIII', 0),
(19, 19, 'fr => "ARMES, MUNITIONS ET LEURS PARTIES ET ACCESSOIRES"', 'SECTION??XIX', 0),
(20, 19, 'fr => "MARCHANDISES ET PRODUITS DIVERS"', 'SECTION??XX', 0),
(21, 19, 'fr => "OBJETS D''ART, DE COLLECTION OU D''ANTIQUIT??"', 'SECTION??XXI', 0);

ALTER SEQUENCE nomenclature_product_section_id_seq START WITH 21;