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
