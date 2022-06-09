
drop table if exists biom ;
create table biom (
                      id int,
                      department_code varchar(4),
                      it_code varchar(8),
                      workforce_group varchar(2),
                      sector_id integer,
                      meta hstore,
                      usual_name varchar(100),
                      enabled bool,
                      administrative_status bool,
                      biom numeric(5,4),
                      q1 int,
                      q2 int,
                      q3 int,
                      q4 int,
                      q5 int,
                      q6 int,
                      q7 int,
                      q8 numeric(5,4),
                      q9 bool,
                      q10 numeric(5,4),
                      q11 bool,
                      q12 bool,
                      q13 int) ;

copy biom (id, department_code, it_code, workforce_group, sector_id, meta, usual_name, enabled, administrative_status, biom, q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13)
    FROM '/srv/httpd/iat-api/sql/fixture/biom.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '"' ESCAPE '"';