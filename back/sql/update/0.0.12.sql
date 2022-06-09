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
