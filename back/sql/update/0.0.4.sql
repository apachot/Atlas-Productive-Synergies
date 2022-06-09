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

-- establishment initialisation optimisation

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

