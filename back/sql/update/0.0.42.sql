
call drop_any_type_of_view_if_exists('vw_proximity_123');
call drop_any_type_of_view_if_exists('vw_npp_same_meta_code');

CREATE MATERIALIZED VIEW vw_npp_same_meta_code
AS
with same_code as (
    select npp.id, npp.main_product_code_hs4 as hs4, npp.secondary_product_code_hs4 as hs4_dest, npp.proximity
    from nomenclature_product_proximity npp
             inner join nomenclature_product np ON np.code_nc = npp.secondary_product_code_hs4
    where left(npp.main_product_code_hs4,1) = left(npp.secondary_product_code_hs4,1)
      AND npp.proximity>0.3
      and np.macro_sector_naf_id is not null
      and exists (
            SELECT 1
            FROM nomenclature_product_relationship npr
            WHERE npr.main_product_code_hs4::text = npp.secondary_product_code_hs4::text
               OR npr.secondary_product_code_hs4::text = npp.secondary_product_code_hs4::text
        )
      and exists (
            SELECT 1
            FROM nomenclature_product_relationship npr
            WHERE npr.main_product_code_hs4::text = npp.main_product_code_hs4::text
               OR npr.secondary_product_code_hs4::text = npp.main_product_code_hs4::text
        )
),
     with_rk as ( select *, row_number () over (partition by hs4 order by proximity desc ) as rk
                  from same_code
     )
select id, hs4, hs4_dest, proximity
from with_rk
where rk <21
;

CREATE VIEW vw_proximity_123 as
With recursive tree as (
    select npp.hs4, npp.hs4 hs4_start, npp.hs4_dest, npp.proximity, 1 as lvl
    from   vw_npp_same_meta_code npp
    UNION ALL
    select tree.hs4, npp.hs4 hs4_start, npp.hs4_dest,
           cast(npp.proximity * tree.proximity as numeric(7,6)) proximity,
           tree.lvl+1 lvl
    from tree
             inner join vw_npp_same_meta_code npp
                        on npp.hs4 = tree.hs4_dest
                            and npp.hs4_dest != tree.hs4_start
    where tree.lvl<2
)
select * from tree ;
