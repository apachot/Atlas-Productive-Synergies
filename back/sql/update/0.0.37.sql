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

-- add to translation
with correction as (select np2.name->'en' name_us, np1.id missing_id
                    from nomenclature_product np1
                             inner join nomenclature_product np2
                                        on np2.code_nc = np1.code_nc || ' 00'
                                            and np2.name->'en' is not null
                    where np1.name->'en' is null)
update nomenclature_product
set name = nomenclature_product.name || hstore('en', name_us)
from correction
where correction.missing_id = nomenclature_product.id;

with correction as (select np2.name->'en' name_us, np1.id missing_id
                    from nomenclature_product np1
                             inner join nomenclature_product np2
                                        on np2.code_nc = np1.code_nc || ' 00'
                                            and np2.name->'en' is not null
                    where np1.name->'en' is null)
update nomenclature_product
set name = nomenclature_product.name || hstore('en', name_us)
from correction
where correction.missing_id = nomenclature_product.id;