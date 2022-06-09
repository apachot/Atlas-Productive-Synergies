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
CREATE OR REPLACE PROCEDURE drop_any_type_of_view_if_exists(IN _viewname text)
    AS
$$
BEGIN
    RAISE LOG 'Looking for (materialized) view named %', _viewname;
    IF EXISTS (SELECT matviewname from pg_matviews where schemaname = 'public' and matviewname = _viewname) THEN
        RAISE NOTICE 'DROP MATERIALIZED VIEW %', _viewname;
        EXECUTE 'DROP MATERIALIZED VIEW ' || quote_ident(_viewname);
    ELSEIF EXISTS (SELECT viewname from pg_views where schemaname = 'public' and viewname = _viewname) THEN
        RAISE NOTICE 'DROP VIEW %', _viewname;
        EXECUTE 'DROP VIEW ' || quote_ident(_viewname);
    ELSE
        RAISE NOTICE 'NO VIEW % found', _viewname;
    END IF;
END;
$$ LANGUAGE plpgsql;

call drop_any_type_of_view_if_exists('vw_resilience_reg') ;
call drop_any_type_of_view_if_exists('vw_resilience_it') ;

call drop_any_type_of_view_if_exists('vw_rca_by_dep');
call drop_any_type_of_view_if_exists('vw_rca_by_reg');
call drop_any_type_of_view_if_exists('vw_rca_by_it');
call drop_any_type_of_view_if_exists('vw_rca_coef_fr');

call drop_any_type_of_view_if_exists('vw_export_harvard_reg_hs4');
call drop_any_type_of_view_if_exists('vw_export_harvard_it_hs4') ;
call drop_any_type_of_view_if_exists('vw_export_harvard_dep_hs4');

call drop_any_type_of_view_if_exists('vw_world_coef') ;
call drop_any_type_of_view_if_exists('vw_export_harvard_cpf4_hs8_coef');
call drop_any_type_of_view_if_exists('vw_convert_hs2017_hs1992');

drop table if exists export_by_country;
drop table if exists util_convert_hs2017_hs1992;
drop table if exists util_export_import;
drop table if exists util_export_import_dep;

BEGIN;

CREATE TABLE export_by_country (
    country varchar(3),
    name varchar(80),
    export bigint,
    pcent numeric(15,12),
    hs4 varchar(12),
    sector varchar(20)
);

copy export_by_country (country, name, export, pcent, hs4, sector) FROM '/srv/httpd/iat-api/sql/fixture/export_by_country.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

CREATE TABLE util_convert_hs2017_hs1992 (
    hs6_2017 varchar(6),
    hs6_1992 varchar(6)
);

copy util_convert_hs2017_hs1992 (hs6_2017, hs6_1992) FROM '/srv/httpd/iat-api/sql/fixture/util_convert_hs2017_hs1992.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

create table util_export_import (
    annee integer,
    cpf6 varchar(6),
    a129 varchar(4),
    hs8 varchar(8),
    exportation bigint,
    importation bigint
) ;

copy util_export_import (annee, cpf6, a129, hs8, exportation, importation) FROM '/srv/httpd/iat-api/sql/fixture/util_export_import.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

create table util_export_import_dep (
    annee integer,
    dep varchar(3),
    cpf4 varchar(4),
    a129 varchar(4),
    exportation bigint,
    importation bigint
) ;

copy util_export_import_dep (annee, dep, cpf4, a129, exportation, importation) FROM '/srv/httpd/iat-api/sql/fixture/util_export_import_dep.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

create view vw_convert_hs2017_hs1992 as 
	with hs4_convert_part as (	
		select left(hs6_2017,4) hs4_2017, left(hs6_1992,4) hs4_1992, 1.0/count(1) over (partition by left(hs6_2017,4)) coef
		from util_convert_hs2017_hs1992 
		where left(hs6_2017,4) != left(hs6_1992,4)
	)
	select hs4_2017, hs4_1992, round(sum(coef),4) coef
	from hs4_convert_part
	group by hs4_2017, hs4_1992
;

COMMIT;

BEGIN;

CREATE MATERIALIZED VIEW vw_export_harvard_dep_hs4 as
with repartition as (
	-- Répartition CPF4 -> HS8 global
	select annee, left(cpf6,4) cpf4, hs8, a129, 
		case when exportation>0 then exportation/sum(exportation) over (partition by annee, left(cpf6,4), a129) else 0 end coef
	from util_export_import
),
export_dep_hs8 as (
	-- Calcul dep HS8
	select dep.annee, dep.dep, r.hs8, cast(dep.exportation * r.coef as bigint) exportation
	from util_export_import_dep dep
		inner join repartition r
		on r.annee = dep.annee
		and r.cpf4 = dep.cpf4
		and r.a129 = dep.a129
),
export_dep_hs4 as (
		-- Rédution à hs4
	select annee, dep, left(hs8,4) hs4, sum(exportation) exportation
	from export_dep_hs8
	group by annee, dep, left(hs8,4)
)
, export_dep_hs4_1992 as (
	-- convertion vers hs_1992
	select annee, dep, coalesce(vw.hs4_1992, e.hs4) hs4, cast(exportation * coalesce(vw.coef,1) as bigint) exportation
	from export_dep_hs4 e
		left join vw_convert_hs2017_hs1992 vw
		on vw.hs4_2017 = e.hs4
)	
, harvard as (
	-- liste des données harvard
	select p.main_product_code_hs4 hs4
	from nomenclature_product_proximity p
	UNION
	select p.secondary_product_code_hs4 hs4
	from nomenclature_product_proximity p
)
select dep.annee, dep.dep, dep.hs4, dep.exportation
from export_dep_hs4_1992 dep
	inner join harvard h on h.hs4 = dep.hs4 ;
COMMIT;

BEGIN;
CREATE MATERIALIZED VIEW vw_export_harvard_reg_hs4 as
	select vw.annee, region.code region, vw.hs4, sum(vw.exportation) as exportation
	from region
		inner join department ON department.region_id = region.id
		inner join vw_export_harvard_dep_hs4 vw on vw.dep = case when department.code in ('2A','2B') then '20' else department.code end
	group by vw.annee, region.code, vw.hs4
;
COMMIT;

BEGIN;
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
COMMIT;

BEGIN;
CREATE VIEW vw_world_coef as
with harvard as (
	select npp.main_product_code_hs4 hs4
	from nomenclature_product_proximity npp
	UNION
	select npp.secondary_product_code_hs4 hs4
	from nomenclature_product_proximity npp
)
select c.hs4, sum(c.export)/tot.export coef
from export_by_country c
	, (select sum(export) export from export_by_country
	  where exists (select 1 from harvard where harvard.hs4=export_by_country.hs4)) tot
where exists (select 1 from harvard where harvard.hs4=c.hs4 )
group by c.hs4, tot.export ;
COMMIT;

BEGIN;
CREATE MATERIALIZED VIEW vw_rca_by_dep AS
 WITH part_cumul as (
	select vw.annee, vw.dep, sum(exportation) exportation
	from vw_export_harvard_dep_hs4 vw
	group by vw.annee, vw.dep
),
part_hs4_cumul as (
	select vw.annee, vw.dep, vw.hs4, sum(exportation) exportation
	from vw_export_harvard_dep_hs4 vw
	group by vw.annee, vw.dep, vw.hs4
),
coef_part as (
	select part_hs4_cumul.annee, part_hs4_cumul.dep, part_hs4_cumul.hs4, case when part_cumul.exportation>0 then part_hs4_cumul.exportation / part_cumul.exportation else 0 end coef
	from part_hs4_cumul
		inner join part_cumul on part_cumul.annee = part_hs4_cumul.annee and part_cumul.dep = part_hs4_cumul.dep
)
SELECT coef_part.annee,
 	coef_part.hs4,
    coef_part.dep departement,
        CASE
            WHEN world.coef>0 then coef_part.coef/world.coef 
            ELSE 0::numeric
        END AS rca
FROM coef_part
	INNER JOIN vw_world_coef world on  world.hs4 = coef_part.hs4;
COMMIT;

BEGIN;
CREATE MATERIALIZED VIEW vw_rca_by_reg AS
 WITH part_cumul as (
	select vw.annee, vw.region, sum(exportation) exportation
	from vw_export_harvard_reg_hs4 vw
	group by vw.annee, vw.region
),
part_hs4_cumul as (
	select vw.annee, vw.region, vw.hs4, sum(exportation) exportation
	from vw_export_harvard_reg_hs4 vw
	group by vw.annee, vw.region, vw.hs4
),
coef_part as (
	select part_hs4_cumul.annee, part_hs4_cumul.region, part_hs4_cumul.hs4, case when part_cumul.exportation>0 then part_hs4_cumul.exportation / part_cumul.exportation else 0 end coef
	from part_hs4_cumul
		inner join part_cumul on part_cumul.annee = part_hs4_cumul.annee and part_cumul.region = part_hs4_cumul.region
)
SELECT coef_part.annee,
 	coef_part.hs4,
    coef_part.region,
        CASE
            WHEN world.coef>0 then coef_part.coef/world.coef 
            ELSE 0::numeric
        END AS rca
FROM coef_part
	INNER JOIN vw_world_coef world on world.hs4 = coef_part.hs4;
COMMIT;

BEGIN;
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
COMMIT;

BEGIN;
CREATE MATERIALIZED VIEW vw_resilience_reg as
with direct as (
	select vw.region, vw.annee, vw.hs4, case when vw.rca>=1.5 then 1 else 0 end ok
	from vw_rca_by_reg vw 
), indirect as (
	select vw_rca_by_reg.region, vw_rca_by_reg.annee, vw_rca_by_reg.hs4, 1 as ok
	from vw_rca_by_reg  
		inner join nomenclature_product_proximity npp
		on npp.main_product_code_hs4 = vw_rca_by_reg.hs4
		and npp.proximity>0.5
		inner join vw_rca_by_reg vw 
		on vw.annee = vw_rca_by_reg.annee
		and vw.region = vw_rca_by_reg.region
		and vw.hs4 = npp.secondary_product_code_hs4
		and vw.rca>=1.5
	where vw_rca_by_reg.rca<1.5
	group by vw_rca_by_reg.region, vw_rca_by_reg.annee, vw_rca_by_reg.hs4
	having count(1)>1
)
, complet as (
		Select d.region, d.annee, d.hs4, coalesce(i.ok, d.ok) ok
		from direct d
			left join indirect i
			on i.region = d.region and i.annee = d.annee and i.hs4 = d.hs4
)
select complet.annee, complet.region, cast(sum(ok) / 1220.0 as numeric(8,7)) resilience
from complet
group by complet.annee, complet.region 
;
COMMIT;

BEGIN;
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
COMMIT;