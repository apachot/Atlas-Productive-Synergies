
drop table if exists parity_raw ;
create table parity_raw (
                            rs varchar(255),
                            siren varchar(9),
                            year int,
                            score int,
                            structure varchar(100),
                            nom_ues varchar(100),
                            siren_ues varchar(12000),
                            region varchar(100),
                            department varchar(100)) ;

copy parity_raw (rs, siren, year, score, structure, nom_ues, siren_ues, region, department)
    FROM '/srv/httpd/iat-api/sql/fixture/parity.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

call drop_any_type_of_view_if_exists('vw_siren');

CREATE MATERIALIZED VIEW vw_siren
AS
select id, left(e.siret,9) siren
from establishment e;

CREATE INDEX vw_siren_idx
    ON vw_siren (siren);

drop table if exists parity ;

create table parity (
                        id int,
                        siren varchar(9),
                        score int
);

CREATE INDEX parity_idx
    ON parity (id);


with denombre as (
    select siren, max(year) y
    from parity_raw
    where score is not null
    group by siren
),
     parity as (
         select pr.siren, pr.score, pr.siren_ues
         from parity_raw pr
                  inner join denombre d
                             on d.siren = pr.siren and d.y = pr.year
     ),
     ns_array as (
         select score, string_to_array(siren_ues, ',') a
         from parity
         where score is not null
           and siren_ues is not null
     ),
     ns_array2 as (
         select score, string_to_array(ns_array.a[s], '(') a
         from ns_array
                  cross join lateral generate_series(1, array_upper(ns_array.a,1)) as s
     )
        , parity_siren as (
    select rtrim(ns_array2.a[array_upper(ns_array2.a,1)], ')') siren, score
    from ns_array2
    union all
    select siren, score
    from parity
)
insert into parity (id, siren, score)
select vw.id, parity_siren.siren, parity_siren.score
from parity_siren
         inner join vw_siren vw on vw.siren = parity_siren.siren;

drop table if exists parity_raw ;