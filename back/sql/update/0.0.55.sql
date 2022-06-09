
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