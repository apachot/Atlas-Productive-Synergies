ALTER TABLE  public.nomenclature_product_relationship
    DROP old_strength,
    owner to iat;

TRUNCATE TABLE nomenclature_product_relationship;

copy nomenclature_product_relationship(id,main_product_code_hs4, secondary_product_code_hs4, created_at, updated_at, deleted_at, updated_by, strength)
    FROM '/srv/httpd/iat-api/sql/fixture/nomenclature_product_relationship.csv' DELIMITER ',' CSV ENCODING 'UTF8' QUOTE '"' ESCAPE '"';


REFRESH MATERIALIZED VIEW vw_export_harvard_dep_hs4;

REFRESH MATERIALIZED VIEW vw_export_harvard_it_hs4;

REFRESH MATERIALIZED VIEW vw_rca_by_it;

REFRESH MATERIALIZED VIEW vw_resilience_it;

REFRESH MATERIALIZED VIEW vw_export_harvard_reg_hs4 ;

REFRESH MATERIALIZED VIEW  vw_rca_by_reg;

REFRESH MATERIALIZED VIEW vw_resilience_reg;

REFRESH MATERIALIZED VIEW vw_rca_by_dep;

REFRESH MATERIALIZED VIEW vw_import_harvard_dep_hs4;

REFRESH MATERIALIZED VIEW vw_import_harvard_it_hs4;

REFRESH MATERIALIZED VIEW vw_import_harvard_reg_hs4;

REFRESH MATERIALIZED VIEW vw_npp_same_meta_code;