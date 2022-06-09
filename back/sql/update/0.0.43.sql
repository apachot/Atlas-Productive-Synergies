/*************************************************************************
 *
 * OPEN STUDIO
 * __________________
 *
 *  [2020] - [2021] Open Studio All Rights Reserved.
 *
 * NOTICE: All information contained herein is, and remains the property of
 * Open Studio. The intellectual and technical concepts contained herein are
 * proprietary to Open Studio and may be covered by France and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is strictly
 * forbidden unless prior written permission is obtained from Open Studio.
 * Access to the source code contained herein is hereby forbidden to anyone except
 * current Open Studio employees, managers or contractors who have executed
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */
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