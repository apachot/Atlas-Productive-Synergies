
call drop_any_type_of_view_if_exists('vw_proximity_importation');

/* correspondance sur l'importation HS6 NAF */
create materialized view vw_proximity_importation as
with importation as (
    select hs8, cpf6, sum(importation) as importation
    from util_export_import
    group by hs8, cpf6
),
     exphs6 as (
         select ul732cpf.code_a732 naf, left(e.hs8,6) hs6, e.importation
         from importation e
                  inner join util_link_a732_cpf6 ul732cpf
                             on ul732cpf.code_cpf6 = e.cpf6
     ),
     cumulexphs6 as (
         select naf, hs6, sum(importation) importation
         from exphs6
         group by naf, hs6
     )
select naf, hs6, round(importation / (sum(importation) over (partition by naf)),6) proximity
from cumulexphs6;

call drop_any_type_of_view_if_exists('vw_proximity_importation_dep');

create materialized view vw_proximity_importation_dep as
with nat as (
    select ul732cpf.code_a732 naf, a129, left(cpf6,4) cpf4, left(hs8,4) hs4, sum(importation) importation
    from util_export_import
             inner join util_link_a732_cpf6 ul732cpf
                        on ul732cpf.code_cpf6 = util_export_import.cpf6
    group by naf, a129, cpf4, hs4
),
     coef as (
         select naf, a129, cpf4, hs4, 1.0 * importation / sum(importation) over (partition by naf, cpf4, a129) coef
         from nat
     ),
     naf_hs4 as (
         select dep.dep, coef.naf, coef.hs4, cast(sum(dep.importation*coef.coef) as bigint) importation
         from util_export_import_dep dep
                  inner join coef
                             on dep.cpf4 = coef.cpf4
                                 and dep.a129 = coef.a129
         group by dep.dep, coef.naf, coef.hs4
         having cast(sum(dep.importation*coef.coef) as bigint)>0
     )
select dep, naf, hs4, round(importation / sum(importation) over (partition by dep, naf),6) proximity
from naf_hs4;

