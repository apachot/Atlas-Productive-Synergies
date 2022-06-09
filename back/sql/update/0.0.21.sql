
truncate table nomenclature_activity_product_proximity;

insert into nomenclature_activity_product_proximity (activity_naf2, product_hs4, proximity, updated_by)
select naf_a732, nc2020_lvl1, proximity, 1
from util_link_a732_nc2020;

drop table util_link_a732_nc2020;
