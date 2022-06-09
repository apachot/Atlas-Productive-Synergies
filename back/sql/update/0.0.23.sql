
insert into nomenclature_product(code_hs4, code_nc, name, product_chapter_id, updated_by)
select hs4, nc, n, chapter_id, 0
from (values ('1519', '1519', cast('"fr"=>"Acide stéarique"' as hstore),15)
           ,('6908', '6908', cast('"fr"=>"Pavés en céramique émaillée"' as hstore), 69)
           ,('8485', '8485', cast('"fr"=>"Pièces de machines, ne contenant pas de caractéristiques électriques, n.c.a."' as hstore), 83)
           ,('8524', '8524', cast('"fr"=>"Bandes, cassettes, disques et disques compacts"' as hstore), 84)
     ) t (hs4, nc, n, chapter_id)
where not exists (select 1 from nomenclature_product where code_hs4=t.hs4)