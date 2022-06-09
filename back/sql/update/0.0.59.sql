drop table if exists nace_proximities;
create table nace_proximities (
                                  src varchar(5),
                                  dest varchar(5),
                                  weight numeric (15,12)
);

copy nace_proximities (src, dest, weight)
    FROM '/srv/httpd/iat-api/sql/fixture/NACE_proximities_gephi_kh_prox.csv' DELIMITER ',' CSV ENCODING 'UTF8' QUOTE '''' ESCAPE '''';
