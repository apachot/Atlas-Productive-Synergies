call drop_any_type_of_view_if_exists('vw_proximity_123');
DROP TABLE IF EXISTS product_space ;

CREATE TABLE IF NOT EXISTS product_space
(
    id SERIAL,
    source varchar(4) NOT NULL,
    target varchar(4) NOT NULL,
    proximity numeric(7,6),
    CONSTRAINT product_space_pkey PRIMARY KEY (id)
) ;

copy product_space (source, target, proximity)
    FROM '/srv/httpd/iat-api/sql/fixture/productSpace.csv' DELIMITER ';' CSV ENCODING 'UTF8' QUOTE '"' ESCAPE '"';

CREATE OR REPLACE VIEW public.vw_proximity_123
AS
WITH RECURSIVE tree AS (
    SELECT ps.source hs4,
           ps.source AS hs4_start,
           ps.target as hs4_dest,
           ps.proximity,
           1 AS lvl
    FROM product_space ps
    UNION ALL
    SELECT tree_1.hs4,
           ps.source AS hs4_start,
           ps.target as hs4_dest,
           (ps.proximity * tree_1.proximity)::numeric(7,6) AS proximity,
           tree_1.lvl + 1 AS lvl
    FROM tree tree_1
             INNER JOIN product_space ps ON ps.source = tree_1.hs4_dest AND ps.target != tree_1.hs4_start
    WHERE tree_1.lvl < 2
)
SELECT tree.hs4,
       tree.hs4_start,
       tree.hs4_dest,
       tree.proximity,
       tree.lvl
FROM tree;