
DROP VIEW IF EXISTS vw_proximity_123;

CREATE VIEW vw_proximity_123 as
With recursive tree as (
    select npp.main_product_code_hs4 hs4, npp.main_product_code_hs4 hs4_start, npp.secondary_product_code_hs4 hs4_dest, npp.proximity, 1 as lvl
    from   nomenclature_product_proximity npp
    where npp.proximity>0.6
      and exists (
            SELECT 1
            FROM nomenclature_product_relationship npr
            WHERE npr.main_product_code_hs4::text = npp.secondary_product_code_hs4::text
               OR npr.secondary_product_code_hs4::text = npp.secondary_product_code_hs4::text
        )
    UNION ALL
    select tree.hs4, npp.main_product_code_hs4 hs4_start, npp.secondary_product_code_hs4 hs4_dest,
           cast(npp.proximity * tree.proximity as numeric(7,6)) proximity,
           tree.lvl+1 lvl
    from tree
             inner join nomenclature_product_proximity npp
                        on npp.main_product_code_hs4 = tree.hs4_dest
                            and npp.secondary_product_code_hs4 != tree.hs4_start
    where tree.lvl<3
      AND npp.proximity>0.6
      and exists (
            SELECT 1
            FROM nomenclature_product_relationship npr
            WHERE npr.main_product_code_hs4::text = npp.secondary_product_code_hs4::text
               OR npr.secondary_product_code_hs4::text = npp.secondary_product_code_hs4::text
        )
)
select * from tree;