
/*
 Add semantic_proximity
 */

ALTER TABLE nomenclature_product_proximity
    add IF NOT EXISTS semantic_proximity numeric(7,6) NOT NULL DEFAULT 0 ;

ALTER TABLE nomenclature_product_proximity
    add IF NOT EXISTS semantic_proximity_2 numeric(7,6) NOT NULL DEFAULT 0 ;

