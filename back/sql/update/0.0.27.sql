
create or replace view vw_convert_hs2017_hs1992 as
with hs4_convert_part as (
    select left(hs6_2017,4) hs4_2017, left(hs6_1992,4) hs4_1992, 1.0/count(1) over (partition by left(hs6_2017,4)) coef
    from util_convert_hs2017_hs1992
    where left(hs6_2017,4) != left(hs6_1992,4)
      and not exists (
            select 1
            from vw_nomenclature_product_harvard
            where code_hs4 = left(hs6_2017,4)
              and is_harvard = true
        )
)
select hs4_2017, hs4_1992, round(sum(coef),4) coef
from hs4_convert_part
group by hs4_2017, hs4_1992
;

REFRESH MATERIALIZED VIEW vw_export_harvard_dep_hs4;
REFRESH MATERIALIZED VIEW vw_export_harvard_reg_hs4;
REFRESH MATERIALIZED VIEW vw_export_harvard_it_hs4;
REFRESH MATERIALIZED VIEW vw_rca_by_dep;
REFRESH MATERIALIZED VIEW vw_rca_by_reg;
REFRESH MATERIALIZED VIEW vw_rca_by_it;
REFRESH MATERIALIZED VIEW vw_resilience_reg;
REFRESH MATERIALIZED VIEW vw_resilience_it;

