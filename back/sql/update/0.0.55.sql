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
drop table if exists entreprise_ri_raw ;
create table entreprise_ri_raw (
                                   siret varchar(14),
                                   naf varchar(6),
                                   ri numeric(15,2),
                                   local_relief_source numeric(8,2),
                                   agility numeric(8,2),
                                   versatile_workforce numeric(8,2),
                                   supply_flexibility numeric(8,2) ) ;

copy entreprise_ri_raw (siret, naf, ri, local_relief_source, agility, versatile_workforce, supply_flexibility)
    FROM '/srv/httpd/iat-api/sql/fixture/computed_RI_for_officies.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

drop table if exists establishment_ri ;

create table establishment_ri (
                                  id int,
                                  resilience_index numeric(15,2),
                                  local_relief_source numeric(8,2),
                                  agility numeric(8,2),
                                  versatile_workforce numeric(8,2),
                                  supply_flexibility numeric(8,2)
);

insert into establishment_ri (id, resilience_index, local_relief_source, agility, versatile_workforce, supply_flexibility)
select e.id, ri, local_relief_source, agility, versatile_workforce, supply_flexibility
from entreprise_ri_raw err
         inner join establishment e
                    on e.siret = err.siret ;