drop table if exists nace_proximities;
create table nace_proximities (
                                  src varchar(5),
                                  dest varchar(5),
                                  weight numeric (15,12)
);

copy nace_proximities (src, dest, weight)
    FROM '/srv/httpd/iat-api/sql/fixture/NACE_proximities.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

update nace_proximities
set src = '0' || src
where length(substr(src, 0, strpos(src, '.')))<2 ;

update nace_proximities
set dest = '0' || dest
where length(substr(dest, 0, strpos(dest, '.')))<2 ;

update nace_proximities
set src = src || '0'
where length(substr(src, strpos(src, '.')+1,2))<2 ;

update nace_proximities
set dest = dest || '0'
where length(substr(dest, strpos(dest, '.')+1,2))<2 ;

DROP FUNCTION IF EXISTS func_list_partner_alt ;

CREATE FUNCTION func_list_partner_alt (p_e_id integer)
    RETURNS TABLE
            (
                e_id int,
                p_id int,
                distance int,
                coef numeric(12,8)
            )
AS $$
DECLARE
    _cst_nb_partner integer := 25 ;
    _nace_start varchar(5);
    _region_id integer;
    _workforce integer;
    _geo_pos geometry;
BEGIN
    select
        left(na.code, 5),
        d.region_id,
        case
            when e.workforce_count<1 then 0
            when e.workforce_count<4 then 1
            when e.workforce_count<7 then 2
            when e.workforce_count<15 then 3
            when e.workforce_count<35 then 4
            when e.workforce_count<75 then 5
            when e.workforce_count<150 then 6
            when e.workforce_count<225 then 7
            when e.workforce_count<375 then 8
            when e.workforce_count<750 then 9
            when e.workforce_count<1500 then 10
            when e.workforce_count<3500 then 11
            when e.workforce_count<7500 then 12
            else 13
            end workforce ,
        e.geo_pos
    into _nace_start, _region_id, _workforce, _geo_pos
    from establishment e
             inner join nomenclature_activity na ON na.id = e.main_activity_id
             inner join department d on d.code = e.department_code
             left join partner_calc_iot iot on iot.id = e.id
    where e.id=p_e_id;

    RETURN QUERY
        with sel_raw as
                 (
                     select prod.src nace, prod.dest, prod.weight, prod.weight/sum(prod.weight) over (partition by prod.src)*25 nombre
                     from nace_proximities prod
                     where prod.src = _nace_start
                       and prod.dest <> _nace_start
                 )
        select p_e_id e_id,
               part.id p_id,
               round(part.distance/1000)::integer distance,
               max(part.weight) as coef
        from sel_raw sr
                 cross join lateral
            (
            select efp.id, efp.nace, ST_DISTANCE( efp.geo_pos, _geo_pos, false ) distance, sr.weight
            from vw_establishment_for_partener efp
                     left join partner_calc_iot pci on pci.id = efp.id
            where efp.nace = sr.dest
              and efp.region_id = _region_id
            order by abs(efp.workforce - _workforce)+(coalesce(pci.nb_supplier,0) * 0.1), ST_DISTANCE( efp.geo_pos, _geo_pos, false )
            limit sr.nombre
            ) part
        group by part.id, round(part.distance/1000)::integer ;

END ;
$$ LANGUAGE plpgsql;