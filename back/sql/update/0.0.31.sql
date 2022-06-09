
call drop_any_type_of_view_if_exists('vw_import_harvard_it_hs4');
call drop_any_type_of_view_if_exists('vw_import_harvard_reg_hs4');
call drop_any_type_of_view_if_exists('vw_import_harvard_dep_hs4');

CREATE MATERIALIZED VIEW vw_import_harvard_dep_hs4
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

CREATE MATERIALIZED VIEW vw_import_harvard_it_hs4
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

CREATE MATERIALIZED VIEW vw_import_harvard_reg_hs4
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
