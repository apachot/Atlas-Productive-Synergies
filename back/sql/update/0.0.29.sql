
create or replace view vw_naf_proximity as
with raw as (
    select na.code naf_main
            , napp.proximity*npr.strength*napp2.proximity proximity,
           napp2.activity_naf2 naf_second
    from nomenclature_activity na
             inner join nomenclature_activity_product_proximity napp on napp.activity_naf2 = na.code
             inner join nomenclature_product_relationship npr on npr.main_product_code_hs4 = napp.product_hs4
             inner join nomenclature_activity_product_proximity napp2
                        on napp2.product_hs4 = npr.secondary_product_code_hs4
                            and napp2.activity_naf2<>na.code
)
select naf_main, sum(proximity) proximity, naf_second
from raw
group by naf_main, naf_second

