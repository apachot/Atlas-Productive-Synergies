/*************************************************************************
 *
 * OPEN STUDIO
 * __________________
 *
 *  [2020] - [2021] Open Studio All Rights Reserved.
 *
 * NOTICE: All information contained herein is, and remains the property of
 * Open Studio. The intellectual and technical concepts contained herein are
 * proprietary to Open Studio and may be covered by France and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is strictly
 * forbidden unless prior written permission is obtained from Open Studio.
 * Access to the source code contained herein is hereby forbidden to anyone except
 * current Open Studio employees, managers or contractors who have executed
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */
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

