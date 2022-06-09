DROP TABLE IF EXISTS epci ;
create table epci (
                      dep_epci varchar(3),
                      siren_epci varchar(9),
                      nom_complet varchar(250),
                      nj_epci2021 varchar(5),
                      fisc_epci2021 varchar(3),
                      nb_com_2021 integer,
                      ptot_epci_2021 integer,
                      pmun_epci_2021 integer
) ;

copy epci (dep_epci, siren_epci, nom_complet, nj_epci2021, fisc_epci2021, nb_com_2021, ptot_epci_2021, pmun_epci_2021)
    FROM '/srv/httpd/iat-api/sql/fixture/epcisanscom2021.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

DROP TABLE IF EXISTS epci_city ;
create table epci_city
(
    dept varchar(3),
    siren varchar(9),
    raison_sociale varchar(255),
    nature_juridique varchar(5),
    mode_financ varchar(3),
    nb_membres int,
    total_pop_tot int,
    total_pop_mun int,
    dep_com varchar(3),
    insee varchar(5),
    siren_membre varchar(9),
    nom_membre varchar(255),
    ptot_2021 int,
    pmun_2021 int
) ;

copy epci_city (dept, siren, raison_sociale, nature_juridique, mode_financ, nb_membres, total_pop_tot, total_pop_mun, dep_com, insee,
                siren_membre, nom_membre, ptot_2021, pmun_2021)
    FROM '/srv/httpd/iat-api/sql/fixture/epcicom2021.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

alter table establishment add column if not exists epci_code varchar(9) ;

update establishment
set epci_code = epci_city.siren
from address
         INNER join city ON city.id = address.city_id
         inner join epci_city on epci_city.insee = city.insee_code
where address.id = establishment.address_id
  and establishment.id between 0 and 250000;

update establishment
set epci_code = epci_city.siren
from address
         INNER join city ON city.id = address.city_id
         inner join epci_city on epci_city.insee = city.insee_code
where address.id = establishment.address_id
  and establishment.id between 250000+1 and 500000;

update establishment
set epci_code = epci_city.siren
from address
         INNER join city ON city.id = address.city_id
         inner join epci_city on epci_city.insee = city.insee_code
where address.id = establishment.address_id
  and establishment.id between 500000+1 and 750000;

update establishment
set epci_code = epci_city.siren
from address
         INNER join city ON city.id = address.city_id
         inner join epci_city on epci_city.insee = city.insee_code
where address.id = establishment.address_id
  and establishment.id between 750000+1 and 1000000;

update establishment
set epci_code = epci_city.siren
from address
         INNER join city ON city.id = address.city_id
         inner join epci_city on epci_city.insee = city.insee_code
where address.id = establishment.address_id
  and establishment.id between 1000000+1 and 1250000;

update establishment
set epci_code = epci_city.siren
from address
         INNER join city ON city.id = address.city_id
         inner join epci_city on epci_city.insee = city.insee_code
where address.id = establishment.address_id
  and establishment.id between 1250000+1 and 1500000;

update establishment
set epci_code = epci_city.siren
from address
         INNER join city ON city.id = address.city_id
         inner join epci_city on epci_city.insee = city.insee_code
where address.id = establishment.address_id
  and establishment.id > 1500000;

drop table if exists epci_polylines;
drop table if exists region_polylines ;
drop table if exists polylines_polyline ;
drop table if exists polylines ;
drop table if exists polyline_point ;
drop table if exists polyline ;
drop table if exists point ;

create table point (
                       id serial primary key,
                       arrange integer,
                       lat numeric (15,12),
                       lng numeric (15,12)
);
create index point_idx on point(id) ;

create table polyline (
    id serial primary key
) ;
create index polyline_idx on polyline(id) ;

create table polyline_point (
                                polyline_id integer not null,
                                point_id  integer not null
);
ALTER TABLE polyline_point ADD FOREIGN KEY (polyline_id) REFERENCES polyline ON DELETE CASCADE;
ALTER TABLE polyline_point ADD FOREIGN KEY (point_id) REFERENCES point ON DELETE CASCADE;

create table polylines (
    id serial primary key
) ;
create index polylines_idx on polylines(id) ;

create table polylines_polyline (
                                    polylines_id integer not null,
                                    polyline_id  integer not null
);
ALTER TABLE polylines_polyline ADD FOREIGN KEY (polylines_id) REFERENCES polylines ON DELETE CASCADE;
ALTER TABLE polylines_polyline ADD FOREIGN KEY (polyline_id) REFERENCES polyline ON DELETE CASCADE;

create table region_polylines (
                                  code varchar(10) not null,
                                  polylines_id integer not null
);

ALTER TABLE region_polylines ADD FOREIGN KEY (polylines_id) REFERENCES polylines ON DELETE CASCADE;

create table epci_polylines (
                                code varchar(10) not null,
                                polylines_id integer not null
);

ALTER TABLE epci_polylines ADD FOREIGN KEY (polylines_id) REFERENCES polylines ON DELETE CASCADE;

copy point (id, arrange, lat, lng)
    FROM '/srv/httpd/iat-api/sql/fixture/points.csv' DELIMITER ';' CSV ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

copy polyline (id)
    FROM '/srv/httpd/iat-api/sql/fixture/polyline.csv' DELIMITER ';' CSV ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

copy polyline_point (polyline_id, point_id)
    FROM '/srv/httpd/iat-api/sql/fixture/polyline_point.csv' DELIMITER ';' CSV ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

copy polylines (id)
    FROM '/srv/httpd/iat-api/sql/fixture/polylines.csv' DELIMITER ';' CSV ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

copy polylines_polyline (polylines_id, polyline_id)
    FROM '/srv/httpd/iat-api/sql/fixture/polylines_polyline.csv' DELIMITER ';' CSV ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

copy region_polylines (code, polylines_id)
    FROM '/srv/httpd/iat-api/sql/fixture/region_polylines.csv' DELIMITER ';' CSV ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

copy epci_polylines (code, polylines_id)
    FROM '/srv/httpd/iat-api/sql/fixture/epci_polylines.csv' DELIMITER ';' CSV ENCODING 'UTF8' QUOTE '''' ESCAPE '''';
