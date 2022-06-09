alter table nomenclature_product_proximity rename to nomenclature_product_proximity_old ;
alter table nomenclature_product_proximity_old drop CONSTRAINT nomenclature_product_proximity_pkey ;

CREATE TABLE IF NOT EXISTS nomenclature_product_proximity
(
    id integer NOT NULL DEFAULT nextval('nomenclature_product_proximity_id_seq'::regclass),
    main_product_code_hs4 varchar(4) NOT NULL,
    proximity numeric(7,6),
    secondary_product_code_hs4 varchar(4) NOT NULL,
    CONSTRAINT nomenclature_product_proximity_pkey PRIMARY KEY (id)
) ;

copy nomenclature_product_proximity (main_product_code_hs4, secondary_product_code_hs4, proximity)
    FROM '/srv/httpd/iat-api/sql/fixture/HS_similarity_usingCF.csv' DELIMITER ',' CSV ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

delete from nomenclature_product_proximity
where nomenclature_product_proximity.main_product_code_hs4 = nomenclature_product_proximity.secondary_product_code_hs4;

delete from nomenclature_product_proximity
where main_product_code_hs4 in ('0719', '2123', '2719', '3428', '3834', '8549')
   or secondary_product_code_hs4 in ('0719', '2123', '2719', '3428', '3834', '8549') ;


DROP INDEX IF EXISTS nomenclature_product_proximity_main_product_code_hs4_idx;

CREATE INDEX IF NOT EXISTS nomenclature_product_proximity_main_product_code_hs4_idx
    ON nomenclature_product_proximity USING btree
        (main_product_code_hs4 COLLATE pg_catalog."default" ASC NULLS LAST) ;


call drop_any_type_of_view_if_exists('vw_naf_proximity');
call drop_any_type_of_view_if_exists('vw_proximity_123');
call drop_any_type_of_view_if_exists('vw_npp_same_meta_code');

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_npp_same_meta_code    
AS
WITH same_code AS (
    SELECT npp.id,
           npp.main_product_code_hs4 AS hs4,
           npp.secondary_product_code_hs4 AS hs4_dest,
           npp.proximity
    FROM nomenclature_product_proximity npp
             JOIN nomenclature_product np ON np.code_nc::text = npp.secondary_product_code_hs4::text
    WHERE "left"(npp.main_product_code_hs4::text, 1) = "left"(npp.secondary_product_code_hs4::text, 1)
      AND npp.proximity > 0.3
      AND np.macro_sector_naf_id IS NOT NULL
      AND (EXISTS ( SELECT 1
            FROM nomenclature_product_relationship npr
            WHERE npr.main_product_code_hs4::text = npp.secondary_product_code_hs4::text
               OR npr.secondary_product_code_hs4::text = npp.secondary_product_code_hs4::text))
      AND (EXISTS ( SELECT 1
            FROM nomenclature_product_relationship npr
            WHERE npr.main_product_code_hs4::text = npp.main_product_code_hs4::text
               OR npr.secondary_product_code_hs4::text = npp.main_product_code_hs4::text))
    ),
    with_rk AS (
    SELECT same_code.id,
           same_code.hs4,
           same_code.hs4_dest,
           same_code.proximity,
           row_number() OVER (PARTITION BY same_code.hs4 ORDER BY same_code.proximity DESC) AS rk
    FROM same_code
)
SELECT with_rk.id,
       with_rk.hs4,
       with_rk.hs4_dest,
       with_rk.proximity
FROM with_rk
WHERE with_rk.rk < 21
WITH DATA;


CREATE VIEW vw_proximity_123
AS
WITH RECURSIVE tree AS (
    SELECT npp.hs4,
           npp.hs4 AS hs4_start,
           npp.hs4_dest,
           npp.proximity,
           1 AS lvl
    FROM vw_npp_same_meta_code npp
    UNION ALL
    SELECT tree_1.hs4,
           npp.hs4 AS hs4_start,
           npp.hs4_dest,
           (npp.proximity * tree_1.proximity)::numeric(7,6) AS proximity,
           tree_1.lvl + 1 AS lvl
    FROM tree tree_1
             JOIN vw_npp_same_meta_code npp ON npp.hs4::text = tree_1.hs4_dest::text AND npp.hs4_dest::text <> tree_1.hs4_start::text
    WHERE tree_1.lvl < 2
)
SELECT tree.hs4,
       tree.hs4_start,
       tree.hs4_dest,
       tree.proximity,
       tree.lvl
FROM tree;

call drop_any_type_of_view_if_exists('vw_proximity_123_mat');

/*
CREATE MATERIALIZED VIEW IF NOT EXISTS public.vw_proximity_123_mat
AS
 WITH RECURSIVE tree AS (
         SELECT npp.main_product_code_hs4 AS hs4,
            npp.main_product_code_hs4 AS hs4_start,
            npp.secondary_product_code_hs4 AS hs4_dest,
            npp.proximity,
            1 AS lvl
           FROM nomenclature_product_proximity npp
          WHERE npp.proximity > 0.6 AND (EXISTS ( SELECT 1
                   FROM nomenclature_product_relationship npr
                  WHERE npr.main_product_code_hs4::text = npp.secondary_product_code_hs4::text OR npr.secondary_product_code_hs4::text = npp.secondary_product_code_hs4::text))
        UNION ALL
         SELECT tree_1.hs4,
            npp.main_product_code_hs4 AS hs4_start,
            npp.secondary_product_code_hs4 AS hs4_dest,
            (npp.proximity * tree_1.proximity)::numeric(7,6) AS proximity,
            tree_1.lvl + 1 AS lvl
           FROM tree tree_1
             JOIN nomenclature_product_proximity npp ON npp.main_product_code_hs4::text = tree_1.hs4_dest::text AND npp.secondary_product_code_hs4::text <> tree_1.hs4_start::text
          WHERE tree_1.lvl < 3 AND npp.proximity > 0.6 AND (EXISTS ( SELECT 1
                   FROM nomenclature_product_relationship npr
                  WHERE npr.main_product_code_hs4::text = npp.secondary_product_code_hs4::text OR npr.secondary_product_code_hs4::text = npp.secondary_product_code_hs4::text))
        )
 SELECT tree.hs4,
    tree.hs4_start,
    tree.hs4_dest,
    tree.proximity,
    tree.lvl
   FROM tree
WITH DATA;
*/

call drop_any_type_of_view_if_exists('vw_resilience_it');

/*
 CREATE MATERIALIZED VIEW IF NOT EXISTS public.vw_resilience_it
AS
 WITH direct AS (
         SELECT vw.it,
            vw.annee,
            vw.hs4,
                CASE
                    WHEN vw.rca >= 1.5 THEN 1
                    ELSE 0
                END AS ok
           FROM vw_rca_by_it vw
        ), indirect AS (
         SELECT vw_rca_by_it.it,
            vw_rca_by_it.annee,
            vw_rca_by_it.hs4,
            1 AS ok
           FROM vw_rca_by_it
             JOIN nomenclature_product_proximity npp ON npp.main_product_code_hs4::text = vw_rca_by_it.hs4 AND npp.proximity > 0.5
             JOIN vw_rca_by_it vw ON vw.annee = vw_rca_by_it.annee AND vw.it::text = vw_rca_by_it.it::text AND vw.hs4 = npp.secondary_product_code_hs4::text AND vw.rca >= 1.5
          WHERE vw_rca_by_it.rca < 1.5
          GROUP BY vw_rca_by_it.it, vw_rca_by_it.annee, vw_rca_by_it.hs4
         HAVING count(1) > 1
        ), complet AS (
         SELECT d.it,
            d.annee,
            d.hs4,
            COALESCE(i.ok, d.ok) AS ok
           FROM direct d
             LEFT JOIN indirect i ON i.it::text = d.it::text AND i.annee = d.annee AND i.hs4 = d.hs4
        )
 SELECT complet.annee,
    complet.it,
    (sum(complet.ok)::numeric / 1220.0)::numeric(8,7) AS resilience
   FROM complet
  GROUP BY complet.annee, complet.it
WITH DATA;
 */

call drop_any_type_of_view_if_exists('vw_resilience_reg');
/*
 CREATE MATERIALIZED VIEW IF NOT EXISTS public.vw_resilience_reg
AS
 WITH direct AS (
         SELECT vw.region,
            vw.annee,
            vw.hs4,
                CASE
                    WHEN vw.rca >= 1.5 THEN 1
                    ELSE 0
                END AS ok
           FROM vw_rca_by_reg vw
        ), indirect AS (
         SELECT vw_rca_by_reg.region,
            vw_rca_by_reg.annee,
            vw_rca_by_reg.hs4,
            1 AS ok
           FROM vw_rca_by_reg
             JOIN nomenclature_product_proximity npp ON npp.main_product_code_hs4::text = vw_rca_by_reg.hs4 AND npp.proximity > 0.5
             JOIN vw_rca_by_reg vw ON vw.annee = vw_rca_by_reg.annee AND vw.region::text = vw_rca_by_reg.region::text AND vw.hs4 = npp.secondary_product_code_hs4::text AND vw.rca >= 1.5
          WHERE vw_rca_by_reg.rca < 1.5
          GROUP BY vw_rca_by_reg.region, vw_rca_by_reg.annee, vw_rca_by_reg.hs4
         HAVING count(1) > 1
        ), complet AS (
         SELECT d.region,
            d.annee,
            d.hs4,
            COALESCE(i.ok, d.ok) AS ok
           FROM direct d
             LEFT JOIN indirect i ON i.region::text = d.region::text AND i.annee = d.annee AND i.hs4 = d.hs4
        )
 SELECT complet.annee,
    complet.region,
    (sum(complet.ok)::numeric / 1220.0)::numeric(8,7) AS resilience
   FROM complet
  GROUP BY complet.annee, complet.region
WITH DATA;
 */

call drop_any_type_of_view_if_exists('vw_rca_by_it');
call drop_any_type_of_view_if_exists('vw_export_harvard_it_hs4');
call drop_any_type_of_view_if_exists('vw_import_harvard_it_hs4');
call drop_any_type_of_view_if_exists('vw_import_harvard_reg_hs4');
call drop_any_type_of_view_if_exists('vw_import_harvard_dep_hs4');
call drop_any_type_of_view_if_exists('vw_rca_by_reg');
call drop_any_type_of_view_if_exists('vw_export_harvard_reg_hs4') ;
call drop_any_type_of_view_if_exists('vw_rca_by_dep');
call drop_any_type_of_view_if_exists('vw_export_harvard_dep_hs4');
call drop_any_type_of_view_if_exists('vw_world_coef') ;

CREATE OR REPLACE VIEW vw_world_coef
AS
WITH harvard AS (
    SELECT npp.main_product_code_hs4 AS hs4
    FROM nomenclature_product_proximity npp
    UNION
    SELECT npp.secondary_product_code_hs4 AS hs4
    FROM nomenclature_product_proximity npp
)
SELECT c.hs4,
       sum(c.export) / tot.export AS coef
FROM export_by_country c,
     ( SELECT sum(export_by_country.export) AS export
       FROM export_by_country
       WHERE (EXISTS ( SELECT 1
                       FROM harvard
                       WHERE harvard.hs4::text = export_by_country.hs4::text))) tot
WHERE (EXISTS ( SELECT 1
                FROM harvard
                WHERE harvard.hs4::text = c.hs4::text))
GROUP BY c.hs4, tot.export;

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_export_harvard_dep_hs4
AS
WITH repartition AS (
    SELECT util_export_import.annee,
           "left"(util_export_import.cpf6::text, 4) AS cpf4,
           util_export_import.hs8,
           util_export_import.a129,
           CASE
               WHEN util_export_import.exportation > 0 THEN util_export_import.exportation::numeric / sum(util_export_import.exportation) OVER (PARTITION BY util_export_import.annee, ("left"(util_export_import.cpf6::text, 4)), util_export_import.a129)
               ELSE 0::numeric
               END AS coef
    FROM util_export_import
), export_dep_hs8 AS (
    SELECT dep_1.annee,
           dep_1.dep,
           r.hs8,
           (dep_1.exportation::numeric * r.coef)::bigint AS exportation
    FROM util_export_import_dep dep_1
             JOIN repartition r ON r.annee = dep_1.annee AND r.cpf4 = dep_1.cpf4::text AND r.a129::text = dep_1.a129::text
), export_dep_hs4 AS (
    SELECT export_dep_hs8.annee,
           export_dep_hs8.dep,
           "left"(export_dep_hs8.hs8::text, 4) AS hs4,
           sum(export_dep_hs8.exportation) AS exportation
    FROM export_dep_hs8
    GROUP BY export_dep_hs8.annee, export_dep_hs8.dep, ("left"(export_dep_hs8.hs8::text, 4))
), export_dep_hs4_1992 AS (
    SELECT e.annee,
           e.dep,
           COALESCE(vw.hs4_1992, e.hs4) AS hs4,
           (e.exportation * COALESCE(vw.coef, 1::numeric))::bigint AS exportation
    FROM export_dep_hs4 e
             LEFT JOIN vw_convert_hs2017_hs1992 vw ON vw.hs4_2017 = e.hs4
), harvard AS (
    SELECT p.main_product_code_hs4 AS hs4
    FROM nomenclature_product_proximity p
    UNION
    SELECT p.secondary_product_code_hs4 AS hs4
    FROM nomenclature_product_proximity p
)
SELECT dep.annee,
       dep.dep,
       dep.hs4,
       dep.exportation
FROM export_dep_hs4_1992 dep
         JOIN harvard h ON h.hs4::text = dep.hs4
WITH DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_rca_by_dep
AS
WITH part_cumul AS (
    SELECT vw.annee,
           vw.dep,
           sum(vw.exportation) AS exportation
    FROM vw_export_harvard_dep_hs4 vw
    GROUP BY vw.annee, vw.dep
), part_hs4_cumul AS (
    SELECT vw.annee,
           vw.dep,
           vw.hs4,
           sum(vw.exportation) AS exportation
    FROM vw_export_harvard_dep_hs4 vw
    GROUP BY vw.annee, vw.dep, vw.hs4
), coef_part AS (
    SELECT part_hs4_cumul.annee,
           part_hs4_cumul.dep,
           part_hs4_cumul.hs4,
           CASE
               WHEN part_cumul.exportation > 0::numeric THEN part_hs4_cumul.exportation / part_cumul.exportation
               ELSE 0::numeric
               END AS coef
    FROM part_hs4_cumul
             JOIN part_cumul ON part_cumul.annee = part_hs4_cumul.annee AND part_cumul.dep::text = part_hs4_cumul.dep::text
)
SELECT coef_part.annee,
       coef_part.hs4,
       coef_part.dep AS departement,
       CASE
           WHEN world.coef > 0::numeric THEN coef_part.coef / world.coef
           ELSE 0::numeric
           END AS rca
FROM coef_part
         JOIN vw_world_coef world ON world.hs4::text = coef_part.hs4
WITH DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS public.vw_export_harvard_reg_hs4
AS
SELECT vw.annee,
       region.code AS region,
       vw.hs4,
       sum(vw.exportation) AS exportation
FROM region
         JOIN department ON department.region_id = region.id
         JOIN vw_export_harvard_dep_hs4 vw ON vw.dep::text =
                                              CASE
                                                  WHEN department.code::text = ANY (ARRAY['2A'::character varying, '2B'::character varying]::text[]) THEN '20'::character varying
                                                  ELSE department.code
                                                  END::text
GROUP BY vw.annee, region.code, vw.hs4
WITH DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_rca_by_reg
AS
WITH part_cumul AS (
    SELECT vw.annee,
           vw.region,
           sum(vw.exportation) AS exportation
    FROM vw_export_harvard_reg_hs4 vw
    GROUP BY vw.annee, vw.region
), part_hs4_cumul AS (
    SELECT vw.annee,
           vw.region,
           vw.hs4,
           sum(vw.exportation) AS exportation
    FROM vw_export_harvard_reg_hs4 vw
    GROUP BY vw.annee, vw.region, vw.hs4
), coef_part AS (
    SELECT part_hs4_cumul.annee,
           part_hs4_cumul.region,
           part_hs4_cumul.hs4,
           CASE
               WHEN part_cumul.exportation > 0::numeric THEN part_hs4_cumul.exportation / part_cumul.exportation
               ELSE 0::numeric
               END AS coef
    FROM part_hs4_cumul
             JOIN part_cumul ON part_cumul.annee = part_hs4_cumul.annee AND part_cumul.region::text = part_hs4_cumul.region::text
)
SELECT coef_part.annee,
       coef_part.hs4,
       coef_part.region,
       CASE
           WHEN world.coef > 0::numeric THEN coef_part.coef / world.coef
           ELSE 0::numeric
           END AS rca
FROM coef_part
         JOIN vw_world_coef world ON world.hs4::text = coef_part.hs4
WITH DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_import_harvard_dep_hs4
AS
WITH repartition AS (
    SELECT util_export_import.annee,
           "left"(util_export_import.cpf6::text, 4) AS cpf4,
           util_export_import.hs8,
           util_export_import.a129,
           CASE
               WHEN util_export_import.importation > 0 THEN util_export_import.importation::numeric / sum(util_export_import.importation) OVER (PARTITION BY util_export_import.annee, ("left"(util_export_import.cpf6::text, 4)), util_export_import.a129)
               ELSE 0::numeric
               END AS coef
    FROM util_export_import
), import_dep_hs8 AS (
    SELECT dep_1.annee,
           dep_1.dep,
           r.hs8,
           (dep_1.importation::numeric * r.coef)::bigint AS importation
    FROM util_export_import_dep dep_1
             JOIN repartition r ON r.annee = dep_1.annee AND r.cpf4 = dep_1.cpf4::text AND r.a129::text = dep_1.a129::text
), import_dep_hs4 AS (
    SELECT import_dep_hs8.annee,
           import_dep_hs8.dep,
           "left"(import_dep_hs8.hs8::text, 4) AS hs4,
           sum(import_dep_hs8.importation) AS importation
    FROM import_dep_hs8
    GROUP BY import_dep_hs8.annee, import_dep_hs8.dep, ("left"(import_dep_hs8.hs8::text, 4))
), import_dep_hs4_1992 AS (
    SELECT e.annee,
           e.dep,
           COALESCE(vw.hs4_1992, e.hs4) AS hs4,
           (e.importation * COALESCE(vw.coef, 1::numeric))::bigint AS importation
    FROM import_dep_hs4 e
             LEFT JOIN vw_convert_hs2017_hs1992 vw ON vw.hs4_2017 = e.hs4
), harvard AS (
    SELECT p.main_product_code_hs4 AS hs4
    FROM nomenclature_product_proximity p
    UNION
    SELECT p.secondary_product_code_hs4 AS hs4
    FROM nomenclature_product_proximity p
)
SELECT dep.annee,
       dep.dep,
       dep.hs4,
       dep.importation
FROM import_dep_hs4_1992 dep
         JOIN harvard h ON h.hs4::text = dep.hs4
WITH DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_import_harvard_reg_hs4
AS
SELECT vw.annee,
       region.code AS region,
       vw.hs4,
       sum(vw.importation) AS importation
FROM region
         JOIN department ON department.region_id = region.id
         JOIN vw_import_harvard_dep_hs4 vw ON vw.dep::text =
                                              CASE
                                                  WHEN department.code::text = ANY (ARRAY['2A'::character varying::text, '2B'::character varying::text]) THEN '20'::character varying
                                                  ELSE department.code
                                                  END::text
GROUP BY vw.annee, region.code, vw.hs4
WITH DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_import_harvard_it_hs4
AS
WITH dep_by_it AS (
    SELECT it_1.id,
           it_1.national_identifying AS it_code,
           CASE
               WHEN department.code::text = ANY (ARRAY['2A'::character varying::text, '2B'::character varying::text]) THEN '20'::character varying
               ELSE department.code
               END AS dep
    FROM industry_territory it_1
             JOIN industry_territory_dep itd ON itd.industry_territory_id = it_1.id
             JOIN department ON department.id = itd.department_id
), nb_by_dep AS (
    SELECT it_1.id,
           it_1.it_code,
           hbd.code_hs4 AS hs4,
           it_1.dep,
           hbd.nbr
    FROM dep_by_it it_1
             JOIN vw_hs4_by_dep hbd ON hbd.department_code::text = it_1.dep::text
    WHERE (EXISTS ( SELECT 1
                    FROM vw_import_harvard_dep_hs4 ehd
                    WHERE ehd.hs4 = hbd.code_hs4::text))
), coef_by_hs4 AS (
    SELECT nbd.it_code,
           nbd.hs4,
           nbd.dep,
           CASE
               WHEN nbd.nbr > 0 THEN hbt.nbr::numeric / nbd.nbr::numeric
               ELSE 0::numeric
               END AS coef
    FROM vw_hs4_by_it hbt
             LEFT JOIN nb_by_dep nbd ON nbd.id = hbt.it_id AND nbd.hs4::text = hbt.code_hs4::text
    WHERE (EXISTS ( SELECT 1
                    FROM vw_import_harvard_dep_hs4 ehd
                    WHERE ehd.hs4 = hbt.code_hs4::text))
)
SELECT vw.annee,
       it.it_code AS it,
       vw.hs4,
       sum(COALESCE(vw.importation::numeric * coef.coef, 0::numeric))::bigint AS importation
FROM dep_by_it it
         LEFT JOIN vw_import_harvard_dep_hs4 vw ON vw.dep::text = it.dep::text
         LEFT JOIN coef_by_hs4 coef ON coef.it_code::text = it.it_code::text AND coef.hs4::text = vw.hs4 AND coef.dep::text = vw.dep::text
GROUP BY vw.annee, vw.hs4, it.it_code
ORDER BY vw.annee, it.it_code, vw.hs4
WITH DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_export_harvard_it_hs4
AS
WITH dep_by_it AS (
    SELECT it_1.id,
           it_1.national_identifying AS it_code,
           CASE
               WHEN department.code::text = ANY (ARRAY['2A'::character varying, '2B'::character varying]::text[]) THEN '20'::character varying
               ELSE department.code
               END AS dep
    FROM industry_territory it_1
             JOIN industry_territory_dep itd ON itd.industry_territory_id = it_1.id
             JOIN department ON department.id = itd.department_id
), nb_by_dep AS (
    SELECT it_1.id,
           it_1.it_code,
           hbd.code_hs4 AS hs4,
           it_1.dep,
           hbd.nbr
    FROM dep_by_it it_1
             JOIN vw_hs4_by_dep hbd ON hbd.department_code::text = it_1.dep::text
    WHERE (EXISTS ( SELECT 1
                    FROM vw_export_harvard_dep_hs4 ehd
                    WHERE ehd.hs4 = hbd.code_hs4::text))
), coef_by_hs4 AS (
    SELECT nbd.it_code,
           nbd.hs4,
           nbd.dep,
           CASE
               WHEN nbd.nbr > 0 THEN hbt.nbr::numeric / nbd.nbr::numeric
               ELSE 0::numeric
               END AS coef
    FROM vw_hs4_by_it hbt
             LEFT JOIN nb_by_dep nbd ON nbd.id = hbt.it_id AND nbd.hs4::text = hbt.code_hs4::text
    WHERE (EXISTS ( SELECT 1
                    FROM vw_export_harvard_dep_hs4 ehd
                    WHERE ehd.hs4 = hbt.code_hs4::text))
)
SELECT vw.annee,
       it.it_code AS it,
       vw.hs4,
       sum(COALESCE(vw.exportation::numeric * coef.coef, 0::numeric))::bigint AS exportation
FROM dep_by_it it
         LEFT JOIN vw_export_harvard_dep_hs4 vw ON vw.dep::text = it.dep::text
         LEFT JOIN coef_by_hs4 coef ON coef.it_code::text = it.it_code::text AND coef.hs4::text = vw.hs4 AND coef.dep::text = vw.dep::text
GROUP BY vw.annee, vw.hs4, it.it_code
ORDER BY vw.annee, it.it_code, vw.hs4
WITH DATA;

CREATE MATERIALIZED VIEW IF NOT EXISTS vw_rca_by_it
AS
WITH part_cumul AS (
    SELECT vw.annee,
           vw.it,
           sum(vw.exportation) AS exportation
    FROM vw_export_harvard_it_hs4 vw
    GROUP BY vw.annee, vw.it
), part_hs4_cumul AS (
    SELECT vw.annee,
           vw.it,
           vw.hs4,
           sum(vw.exportation) AS exportation
    FROM vw_export_harvard_it_hs4 vw
    GROUP BY vw.annee, vw.it, vw.hs4
), coef_part AS (
    SELECT part_hs4_cumul.annee,
           part_hs4_cumul.it,
           part_hs4_cumul.hs4,
           CASE
               WHEN part_cumul.exportation > 0::numeric THEN part_hs4_cumul.exportation / part_cumul.exportation
               ELSE 0::numeric
               END AS coef
    FROM part_hs4_cumul
             JOIN part_cumul ON part_cumul.annee = part_hs4_cumul.annee AND part_cumul.it::text = part_hs4_cumul.it::text
)
SELECT coef_part.annee,
       coef_part.hs4,
       coef_part.it,
       CASE
           WHEN world.coef > 0::numeric THEN coef_part.coef / world.coef
           ELSE 0::numeric
           END AS rca
FROM coef_part
         JOIN vw_world_coef world ON world.hs4::text = coef_part.hs4
WITH DATA;



