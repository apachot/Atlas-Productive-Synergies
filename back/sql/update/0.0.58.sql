DROP TABLE IF EXISTS scrapping_raw ;

CREATE TABLE scrapping_raw
(
    id SERIAL,
    etablissement varchar(255),
    siren varchar(10),
    site varchar(500),
    non_trouve int,
    cat1 varchar(50),
    cat2 varchar(8),
    cat3 varchar(6),
    cat4 varchar(6),
    cat5 varchar(6),
    cat6 varchar(5),
    cat7 varchar(5),
    cat8 varchar(5),
    logistique int,
    no_cat int,
    CONSTRAINT scrapping_raw_pkey PRIMARY KEY (id)
) ;

copy scrapping_raw (etablissement, siren, site, non_trouve, cat1, cat2, cat3, cat4, cat5, cat6, cat7, cat8, logistique, no_cat)
    FROM '/srv/httpd/iat-api/sql/fixture/scrapping.csv' DELIMITER ';' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

update scrapping_raw set cat1 = null where length(cat1)=6 and etablissement = 'HYDRALIANS LOGISTIQUE';
update scrapping_raw set cat1 = substring(cat1, 1,4) where length(cat1)=6 and substring(cat1, 5,2) = '00' ;
update scrapping_raw set cat1 = '0709', cat2='2715', cat3='3204' where cat1='0709 60 91, 2715 00 00, 3204 15 00';
update scrapping_raw set cat1 = '1602', cat2='1601' where cat1='1602,1601';
update scrapping_raw set cat1 = '0709' where cat1='O709';
update scrapping_raw set cat1 = null where length(cat1)>4;
update scrapping_raw set cat1 = '0' || cat1 where length(cat1)=3 ;
update scrapping_raw set cat2 = substring(cat2, 1,4) where length(cat2)=6 and substring(cat2, 5,2) = '00' ;
update scrapping_raw set cat2 = '5208', cat3='5212' where cat2='52085212';
update scrapping_raw set cat2 = '0' || cat2 where length(cat2)=3 ;
update scrapping_raw set cat3 = substring(cat3, 1,4) where length(cat3)=6 and substring(cat3, 5,2) = '00' ;
update scrapping_raw set cat3 = '8706' where cat3='80600' ;
update scrapping_raw set cat3 = '0' || cat3 where length(cat3)=3 ;
update scrapping_raw set cat4 = substring(cat4, 1,4) where length(cat4)=6 and substring(cat4, 5,2) = '00' ;
update scrapping_raw set cat4 = '0' || cat4 where length(cat4)=3 ;
update scrapping_raw set cat5 = substring(cat5, 1,4) where length(cat5)=6 and substring(cat5, 5,2) = '00' ;
update scrapping_raw set cat5 = '0' || cat5 where length(cat5)=3 ;
update scrapping_raw set cat6 = '0' || cat6 where length(cat6)=3 ;
update scrapping_raw set cat7 = '0' || cat7 where length(cat7)=3 ;
update scrapping_raw set cat8 = '0' || cat8 where length(cat8)=3 ;

update scrapping_raw set cat1=null where cat1 in (
    select  cat1 from scrapping_raw
                          left join util_nomenclature_nc2020_lvl1 nc
                                    on nc.code = cat1
    where cat1 is not null and nc.code is null
);

update scrapping_raw set cat2=null where cat2 in (
    select  cat2 from scrapping_raw
                          left join util_nomenclature_nc2020_lvl1 nc
                                    on nc.code = cat2
    where cat2 is not null and nc.code is null
);
update scrapping_raw set cat3=null where cat3 in (
    select  cat3 from scrapping_raw
                          left join util_nomenclature_nc2020_lvl1 nc
                                    on nc.code = cat3
    where cat3 is not null and nc.code is null
);
update scrapping_raw set cat4=null where cat4 in (
    select  cat4 from scrapping_raw
                          left join util_nomenclature_nc2020_lvl1 nc
                                    on nc.code = cat4
    where cat4 is not null and nc.code is null
);
update scrapping_raw set cat5 =null where cat5 in (
    select  cat5 from scrapping_raw
                          left join util_nomenclature_nc2020_lvl1 nc
                                    on nc.code = cat5
    where cat5 is not null and nc.code is null
);
refresh MATERIALIZED VIEW vw_siren ;

DROP TABLE IF EXISTS establishment_prod ;

CREATE TABLE establishment_prod
(
    establishment_id int not null,
    hs4 varchar(4) not null,
    nomenclature_product_id int not null
) ;

with scrap as (
    select siren, cat1 as cat, np.id as nomenclature_product_id
    from scrapping_raw inner join nomenclature_product np on np.code_hs4 = cat1 and length(np.code_nc)=4 and np.macro_sector_naf_id is not null
    where cat1 is not null
    union
    select siren, cat2 as cat, np.id as nomenclature_product_id
    from scrapping_raw inner join nomenclature_product np on np.code_hs4 = cat2 and length(np.code_nc)=4 and np.macro_sector_naf_id is not null
    where cat2 is not null
    union
    select siren, cat3 as cat, np.id as nomenclature_product_id
    from scrapping_raw inner join nomenclature_product np on np.code_hs4 = cat3 and length(np.code_nc)=4 and np.macro_sector_naf_id is not null
    where cat3 is not null
    union
    select siren, cat4 as cat, np.id as nomenclature_product_id
    from scrapping_raw inner join nomenclature_product np on np.code_hs4 = cat4 and length(np.code_nc)=4 and np.macro_sector_naf_id is not null
    where cat4 is not null
    union
    select siren, cat5 as cat, np.id as nomenclature_product_id
    from scrapping_raw inner join nomenclature_product np on np.code_hs4 = cat5 and length(np.code_nc)=4 and np.macro_sector_naf_id is not null
    where cat5 is not null
    union
    select siren, cat6 as cat, np.id as nomenclature_product_id
    from scrapping_raw inner join nomenclature_product np on np.code_hs4 = cat6 and length(np.code_nc)=4 and np.macro_sector_naf_id is not null
    where cat6 is not null
    union
    select siren, cat7 as cat, np.id as nomenclature_product_id
    from scrapping_raw inner join nomenclature_product np on np.code_hs4 = cat7 and length(np.code_nc)=4 and np.macro_sector_naf_id is not null
    where cat7 is not null
    union
    select siren, cat8 as cat, np.id as nomenclature_product_id
    from scrapping_raw inner join nomenclature_product np on np.code_hs4 = cat8 and length(np.code_nc)=4 and np.macro_sector_naf_id is not null
    where cat8 is not null
)
insert into establishment_prod (establishment_id, hs4, nomenclature_product_id)
select vw.id, scrap.cat, scrap.nomenclature_product_id
from scrap
         inner join vw_siren vw
                    on vw.siren  = scrap.siren ;

delete from product where establishment_id in (
    select distinct establishment_id
    from establishment_prod ep
             inner join nomenclature_product np on np.id = ep.nomenclature_product_id
) ;

insert into product (establishment_id, nomenclature_product_id, name, fake, updated_by)
select ep.establishment_id, ep.nomenclature_product_id, np.name, false as fake, 0 as updated_by
from establishment_prod ep
         inner join nomenclature_product np on np.id = ep.nomenclature_product_id ;
