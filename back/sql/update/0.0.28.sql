
UPDATE util_nomenclature_naf_a38
set name = '"fr"=>"Fabrication de machines et équipements"'
where code='CK';

alter table establishment drop column enabled ;
alter table establishment add column enabled BOOLEAN GENERATED ALWAYS AS (meta->'lat' is not null and meta->'lng' is not null and meta -> 'sector' is not null) stored ;

drop table if exists recup_establishment ;

create table recup_establishment (
                                     siret varchar(14),
                                     meta hstore
);

copy recup_establishment (siret, meta) FROM '/srv/httpd/iat-api/sql/fixture/recup_establishment.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

update establishment
set administrative_status = true
  , meta = case when establishment.meta is null then recup_establishment.meta else establishment.meta || recup_establishment.meta end
from recup_establishment
where recup_establishment.siret = establishment.siret ;

create table macro_secteur_naf (
                                   id int,
                                   code varchar(2),
                                   name hstore
) ;

insert into macro_secteur_naf (id, code, name)
Select t.l, t.c, util_nomenclature_naf_a38."name"
from (
         values (1, 'AZ'), (2, 'BZ'), (3, 'CA'), (4, 'CB'), (5, 'CC'), (6, 'CD'), (7, 'CE'), (8, 'CF'), (9, 'CG'),
                (10, 'CH'), (11, 'CI'), (12, 'CJ'), (13, 'CK'), (14, 'CL'), (15, 'CM'), (16, 'DZ'), (17, 'EZ'), (18, 'FZ')
     ) T(l, c)
         inner join util_nomenclature_naf_a38 on util_nomenclature_naf_a38.code = t.c
;
insert into macro_secteur_naf (id, code, name)
values (19, 'ZZ', '"fr"=>"Autre"');

alter table macro_secteur_naf add CONSTRAINT macro_secteur_naf_pkey PRIMARY KEY (id);

Update city
set department_id = department.id
from department
where department.code = left(city.zip_code,2)
  and coalesce(city.department_id,0) != department.id ;

alter table establishment drop column geo_pos ;
alter table establishment add column geo_pos geometry GENERATED ALWAYS AS (
    ST_MakePoint(
            (meta->'lat')::double precision,
            (meta->'lng')::double precision
        )
    ) stored;

call drop_any_type_of_view_if_exists('vw_resilience_it');
call drop_any_type_of_view_if_exists('vw_rca_by_it');
call drop_any_type_of_view_if_exists('vw_export_harvard_it_hs4');
call drop_any_type_of_view_if_exists('vw_hs4_by_it');

call drop_any_type_of_view_if_exists('vw_hs4_by_dep');

alter table establishment drop column industry_territory_id;
alter table establishment drop column department_code ;
alter table establishment add column department_code varchar(3) GENERATED ALWAYS AS (meta -> 'department'::text) stored ;

CREATE MATERIALIZED VIEW vw_hs4_by_it as
SELECT it.id it_id, np.code_hs4, count(1) nbr
FROM establishment e
         INNER JOIN industry_territory it ON it.national_identifying = e.it_code
         INNER JOIN product p ON p.establishment_id = e.id
         INNER JOIN nomenclature_product np ON np.id = p.nomenclature_product_id
GROUP BY it.id, np.code_hs4 ;

CREATE MATERIALIZED VIEW vw_hs4_by_dep as
SELECT case when department_code in ('2A', '2B') then '20' else department_code end department_code
     , np.code_hs4
     , count(1) as nbr
FROM establishment e
         INNER JOIN product p ON p.establishment_id = e.id
         INNER JOIN nomenclature_product np ON np.id = p.nomenclature_product_id
group by case when department_code in ('2A', '2B') then '20' else department_code end, np.code_hs4
;

CREATE MATERIALIZED VIEW vw_export_harvard_it_hs4 as
With dep_by_it as (
    select it.id, it.national_identifying it_code, case when department.code in ('2A','2B') then '20' else department.code end dep
    FROM industry_territory it
             INNER JOIN industry_territory_dep itd ON itd.industry_territory_id = it.id
             INNER JOIN department on department.id = itd.department_id
),
     nb_by_dep as (
         select it.id, it.it_code, hbd.code_hs4 hs4, it.dep, nbr
         from dep_by_it it
                  inner join vw_hs4_by_dep hbd on hbd.department_code = it.dep
         where exists (select 1 from vw_export_harvard_dep_hs4 ehd where ehd.hs4 = hbd.code_hs4)
     )
        , coef_by_hs4 as (
    select it_code, hs4, nbd.dep, case when nbd.nbr>0 then hbt.nbr::numeric/nbd.nbr::numeric else 0 end coef
    from vw_hs4_by_it hbt
             left join nb_by_dep nbd on nbd.id = hbt.it_id and nbd.hs4 = hbt.code_hs4
    where exists (select 1 from vw_export_harvard_dep_hs4 ehd where ehd.hs4 = hbt.code_hs4)
)
select vw.annee, it.it_code it, vw.hs4, cast(sum(coalesce (vw.exportation::numeric * coef.coef,0)) as bigint) exportation
from dep_by_it it
         left join vw_export_harvard_dep_hs4 vw on vw.dep = it.dep
         left join coef_by_hs4 coef on coef.it_code = it.it_code and coef.hs4=vw.hs4 and coef.dep = vw.dep
group by vw.annee, vw.hs4, it.it_code
order by annee, it, hs4 ;

CREATE MATERIALIZED VIEW vw_rca_by_it AS
WITH part_cumul as (
    select vw.annee, vw.it, sum(exportation) exportation
    from vw_export_harvard_it_hs4 vw
    group by vw.annee, vw.it
),
     part_hs4_cumul as (
         select vw.annee, vw.it, vw.hs4, sum(exportation) exportation
         from vw_export_harvard_it_hs4 vw
         group by vw.annee, vw.it, vw.hs4
     ),
     coef_part as (
         select part_hs4_cumul.annee, part_hs4_cumul.it, part_hs4_cumul.hs4, case when part_cumul.exportation>0 then part_hs4_cumul.exportation / part_cumul.exportation else 0 end coef
         from part_hs4_cumul
                  inner join part_cumul on part_cumul.annee = part_hs4_cumul.annee and part_cumul.it = part_hs4_cumul.it
     )
SELECT coef_part.annee,
       coef_part.hs4,
       coef_part.it,
       CASE
           WHEN world.coef>0 then coef_part.coef/world.coef
           ELSE 0::numeric
           END AS rca
FROM coef_part
         INNER JOIN vw_world_coef world on world.hs4 = coef_part.hs4;

CREATE MATERIALIZED VIEW vw_resilience_it as
with direct as (
    select vw.it, vw.annee, vw.hs4, case when vw.rca>=1.5 then 1 else 0 end ok
    from vw_rca_by_it vw
), indirect as (
    select vw_rca_by_it.it, vw_rca_by_it.annee, vw_rca_by_it.hs4, 1 as ok
    from vw_rca_by_it
             inner join nomenclature_product_proximity npp
                        on npp.main_product_code_hs4 = vw_rca_by_it.hs4
                            and npp.proximity>0.5
             inner join vw_rca_by_it vw
                        on vw.annee = vw_rca_by_it.annee
                            and vw.it = vw_rca_by_it.it
                            and vw.hs4 = npp.secondary_product_code_hs4
                            and vw.rca>=1.5
    where vw_rca_by_it.rca<1.5
    group by vw_rca_by_it.it, vw_rca_by_it.annee, vw_rca_by_it.hs4
    having count(1)>1
)
   , complet as (
    Select d.it, d.annee, d.hs4, coalesce(i.ok, d.ok) ok
    from direct d
             left join indirect i
                       on i.it = d.it and i.annee = d.annee and i.hs4 = d.hs4
)
select complet.annee, complet.it, cast(sum(ok) / 1220.0 as numeric(8,7)) resilience
from complet
group by complet.annee, complet.it
;

CREATE OR REPLACE PROCEDURE update_establishment()
AS $$
DECLARE
    _max bigint;
    _actu bigint;
BEGIN
    _max = (select max(establishment.id) from establishment );
    _actu = 0;
    while (_actu<=_max)
        LOOP
            raise notice 'actu: %-% / %', _actu, _actu+50000, _max;
            update establishment
            set meta = coalesce(establishment.meta,'') || hstore(
                    ARRAY[
                        'sector', cast(macro_secteur_naf.id as varchar),
                        'department', department.code,
                        'region', region.code,
                        'activity', nomenclature_activity.code,
                        'ti', industry_territory.national_identifying
                        ])
            from establishment e
                     left join nomenclature_activity
                     left join util_nomenclature_naf_a732
                     inner join util_nomenclature_naf_a38 ON util_nomenclature_naf_a38.id = util_nomenclature_naf_a732.util_nomenclature_naf_a38_id
                     inner join macro_secteur_naf on macro_secteur_naf.code = util_nomenclature_naf_a38.code
                                on util_nomenclature_naf_a732.code = nomenclature_activity.code
                                on nomenclature_activity.id = e.main_activity_id
                     left join address ON address.id = e.address_id
                     left join city ON city.id = address.city_id
                     left join industry_territory on industry_territory.id = city.industry_territory_id
                     left join department ON department.id = city.department_id
                     left join region on region.id = department.region_id
            where e.administrative_status = true
              and e.id between _actu and _actu+50000
              and establishment.id = e.id;
            _actu = _actu + 50000;
        END LOOP;
END ;
$$ LANGUAGE plpgsql;

call update_establishment() ;

alter table nomenclature_activity add macro_sector_naf_id integer ;

alter table nomenclature_activity add CONSTRAINT nomenclature_activity_macro_sector_naf_id_fkey FOREIGN KEY (macro_sector_naf_id)
    REFERENCES macro_secteur_naf (id) ;

update nomenclature_activity
set macro_sector_naf_id = macro_secteur_naf.id
from util_nomenclature_naf_a732 a732
         inner join util_nomenclature_naf_a38 a38 ON a38.id = a732.util_nomenclature_naf_a38_id
         inner join macro_secteur_naf on macro_secteur_naf.code = a38.code
where a732.code = nomenclature_activity.code ;

with lk_88_38 as (
    select distinct a88.code a88, a38.code a38
    from util_nomenclature_naf_a732 a732
             inner join util_nomenclature_naf_a88 a88
                        on a88.id = a732.util_nomenclature_naf_a88_id
             inner join util_nomenclature_naf_a38 a38
                        ON a38.id = a732.util_nomenclature_naf_a38_id
)
update nomenclature_activity
set macro_sector_naf_id = macro_secteur_naf.id
FROM lk_88_38
         inner join macro_secteur_naf on macro_secteur_naf.code = lk_88_38.a38
where lk_88_38.a88 = nomenclature_activity.code ;

-- first level
update nomenclature_activity
set macro_sector_naf_id = (
    select na.macro_sector_id
    from nomenclature_activity na
    where na.id = nomenclature_activity.parent_activity_id
)
where macro_sector_naf_id is null;

-- second level
update nomenclature_activity
set macro_sector_naf_id = (
    select na.macro_sector_id
    from nomenclature_activity na
    where na.id = nomenclature_activity.parent_activity_id
)
where macro_sector_naf_id is null;

alter table nomenclature_product add macro_sector_naf_id integer ;

alter table nomenclature_product add CONSTRAINT nomenclature_product_macro_sector_naf_id_fkey FOREIGN KEY (macro_sector_naf_id)
    REFERENCES macro_secteur_naf (id) ;

with A129hs8 as (
    select distinct a129, hs8
    from util_export_import
)
   , hs8a38 as (
    select distinct hs8, naf.id naf
    from a129hs8
             inner join util_nomenclature_naf_a129 a129
                        on a129.code = a129hs8.a129
             inner join util_nomenclature_naf_a732 a732
                        on a732.util_nomenclature_naf_a129_id = a129.id
             inner join util_nomenclature_naf_a38 a38
                        on a38.id = a732.util_nomenclature_naf_a38_id
             inner join macro_secteur_naf naf
                        on naf.code = a38.code
)
update nomenclature_product
set macro_sector_naf_id = naf
from hs8a38
where replace(code_nc, ' ', '') = hs8 ;

update nomenclature_product
set macro_sector_naf_id = naf_id
from (
         select distinct na.code_nc, na2.macro_sector_naf_id naf_id
         from nomenclature_product na
                  inner join nomenclature_product na2
                             on left(na2.code_nc,7) = left(na.code_nc,7)
                                 and na2.macro_sector_naf_id is not null
         where na.code_nc like '____ __ __'
           and na.macro_sector_naf_id is null
     ) t
where nomenclature_product.code_nc = t.code_nc ;

update nomenclature_product
set macro_sector_naf_id = naf_id
from (values
      ('0208 60 00', 'C10A', 3),('0210 93 00', 'C10A', 3),('0303 56 00', 'C10B', 3),('0304 55 00', 'C10B', 3),('0304 56 10', 'C10B', 3),
      ('0304 56 20', 'C10B', 3),('0304 56 30', 'C10B', 3),('0304 56 90', 'C10B', 3),('0305 71 00', 'C10B', 3),('0307 88 00', 'C10B', 3),
      ('0501 00 00', 'S96Z', null),('1604 18 00', 'C10B', 3),('2524 10 00', 'B08Z', 2),('2846 10 00', 'C20A', 7),('2904 35 00', 'C20A', 7),
      ('2903 75 00', 'C20A', 7),('2903 94 00', 'C20A', 7),('2904 32 00', 'C20A', 7),('2904 36 00', 'C20A', 7),('2923 40 00', 'C21Z', 8),
      ('2924 23 00', 'C21Z', 8),('2924 24 00', 'C21Z', 8),('2925 12 00', 'C21Z', 8),('2931 37 00', 'C20A', 7),('2935 20 00', 'C21Z', 8),
      ('2939 51 00', 'C21Z', 8),('2939 62 00', 'C21Z', 8),('2939 63 00', 'C21Z', 8),('3003 41 00', 'C21Z', 8),('3003 43 00', 'C21Z', 8),
      ('3804 00 00', 'C20A', 7),('3704 00 10', 'M74Z', null),('3704 00 90', 'M74Z', null),('3705 00 10', 'M74Z', null),('3705 00 90', 'M74Z', null),
      ('3706 10 20', 'J59Z', null),('3706 10 99', 'J59Z', null),('3706 90 52', 'J59Z', null),('3706 90 91', 'J59Z', null),('3706 90 99', 'J59Z', null),
      ('3824 73 00', 'C20C', 7),('4904 00 00', 'J59Z', null),('4106 31 00', 'C15Z', 4),('4903 00 00', 'J58Z', null),('4905 91 00', 'J58Z', null),
      ('4901 10 00', 'J58Z', null),('4901 91 00', 'J58Z', null),('4901 99 00', 'J58Z', null),('4902 10 00', 'J58Z', null),('4902 90 00', 'J58Z', null),
      ('4905 99 00', 'J58Z', null),('4906 00 00', 'M71Z', null),('4907 00 10', 'J58Z', null),('4907 00 30', 'J58Z', null),('4907 00 90', 'J58Z', null),
      ('4908 10 00', 'J58Z', null),('4908 90 00', 'J58Z', null),('4909 00 00', 'J58Z', null),('4910 00 00', 'J58Z', null),('4911 10 10', 'J58Z', null),
      ('4911 10 90', 'J58Z', null),('4911 91 00', 'J58Z', null),('4911 99 00', 'J58Z', null),('7108 20 00', 'C24B', 10),('7118 90 00', 'C32A', 15),
      ('8107 30 00', 'E38Z', 17),('8112 13 00', 'E38Z', 17),('8112 52 00', 'E38Z', 17),('8523 49 10', 'J59Z', null),('8523 49 20', 'J59Z', null),
      ('8523 49 90', 'J59Z', null),('8606 92 00', 'C30B', 14),('8710 00 00', 'C30D', 14),('8805 21 00', 'C30C', 14),('8906 10 00', 'C30A', 14),
      ('9301 10 00', 'C25C', 10),('9301 20 00', 'C25C', 10),('9301 90 00', 'C25C', 10),('9302 00 00', 'C25C', 10),('9305 10 00', 'C25C', 10),
      ('9305 91 00', 'C25C', 10),('9703 00 00', 'R90Z', null),('9701 10 00', 'R90Z', null),('9701 90 00', 'R90Z', null),('9702 00 00', 'R91Z', null),
      ('9704 00 00', 'R91Z', null),('9705 00 00', 'R91Z', null),('9706 00 00', 'R91Z', null)) t(nc,a129,naf_id)
where code_nc = t.nc
  and macro_sector_naf_id is null;

update nomenclature_product
set macro_sector_naf_id=19
where code_nc like '____ __ __'
  and macro_sector_naf_id is null;

with hs4_naf as
         (
             select left(code_nc,4) hs4, count(distinct macro_sector_naf_id) nbr, max(macro_sector_naf_id) naf
             from nomenclature_product
             where code_nc like '____ __ __'
             group by left(code_nc,4)
         )
update nomenclature_product
set macro_sector_naf_id = naf
from hs4_naf
where hs4 = code_nc
  and nbr=1;

with hs4_naf as
         (
             select left(code_nc,4) hs4, count(distinct macro_sector_naf_id) nbr
             from nomenclature_product
             where code_nc like '____ __ __'
             group by left(code_nc,4)
         ),
     h as (
         select left(code_nc,4) hs4, macro_sector_naf_id, count(1) nbr
         from nomenclature_product
         where code_nc like '____ __ __'
         group by left(code_nc,4), macro_sector_naf_id
     )
update nomenclature_product
set macro_sector_naf_id = naf
from hs4_naf
         cross join lateral(
    select macro_sector_naf_id naf
    from h
    where h.hs4 = hs4_naf.hs4
    order by nbr desc
    limit 1
    ) h
where hs4_naf.nbr>1
  and nomenclature_product.code_nc = hs4_naf.hs4
;

create or replace view vw_nomenclature_product_harvard as
select np.id, np.code_hs4, np.macro_sector_naf_id sector_id, np.name
     , exists(select 1
              from nomenclature_product_relationship npr
              where npr.main_product_code_hs4 = np.code_hs4
                 or npr.secondary_product_code_hs4 = np.code_hs4) is_harvard
from nomenclature_product np
where np.code_nc =np.code_hs4
