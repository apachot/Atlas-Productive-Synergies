

-- add to translation
with correction as (select np2.name->'en' name_us, np1.id missing_id
                    from nomenclature_product np1
                             inner join nomenclature_product np2
                                        on np2.code_nc = np1.code_nc || ' 00'
                                            and np2.name->'en' is not null
                    where np1.name->'en' is null)
update nomenclature_product
set name = nomenclature_product.name || hstore('en', name_us)
from correction
where correction.missing_id = nomenclature_product.id;

with correction as (select np2.name->'en' name_us, np1.id missing_id
                    from nomenclature_product np1
                             inner join nomenclature_product np2
                                        on np2.code_nc = np1.code_nc || ' 00'
                                            and np2.name->'en' is not null
                    where np1.name->'en' is null)
update nomenclature_product
set name = nomenclature_product.name || hstore('en', name_us)
from correction
where correction.missing_id = nomenclature_product.id;