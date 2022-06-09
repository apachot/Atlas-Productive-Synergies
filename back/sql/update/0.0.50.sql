drop table if exists nace_proximities;
create table nace_proximities (
                                  src varchar(5),
                                  dest varchar(5),
                                  weight numeric (15,12)
);

copy nace_proximities (src, dest, weight)
    FROM '/srv/httpd/iat-api/sql/fixture/NACE_proximities.csv' DELIMITER ',' CSV HEADER ENCODING 'UTF8' QUOTE '''' ESCAPE '''';

CREATE OR REPLACE FUNCTION public.func_list_partner_alt(
    p_e_id integer)
    RETURNS TABLE(e_id integer, p_id integer, distance integer, coef numeric)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    _cst_nb_partner integer := 30 ;
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
                     select dest, round(qte/ sum(qte) over (partition by nace) * 100) :: integer nombre, qte/ sum(qte) over (partition by nace) * _cst_nb_partner coef
                     from (
                              select distinct prod.nace, prox.dest, prod.qte, prod.qte / sum(prod.qte) over (partition by prod.nace) _sum
                              from iot_consume_nace prod
                                       inner join nace_proximities prox
                                                  on prox.dest = prod.dest
                              where prod.nace = _nace_start
                                and prod.dest <> _nace_start
                              order by _sum desc
                              limit 5
                          ) t
                 )

        select p_e_id e_id,
               part.id p_id,
               round(part.distance/1000)::integer distance,
               max(sr.coef) as coef
        from sel_raw sr
                 cross join lateral
            (
            select efp.id, efp.nace, ST_DISTANCE( efp.geo_pos, _geo_pos, false ) distance
            from vw_establishment_for_partener efp
                     left join partner_calc_iot pci on pci.id = efp.id
            where efp.nace = sr.dest
              and efp.region_id = _region_id
            order by ST_DISTANCE( efp.geo_pos, _geo_pos, false ), abs(efp.workforce - _workforce)+(coalesce(pci.nb_supplier,0) * 0.1)
            limit sr.coef
            ) part

        group by part.id, round(part.distance/1000)::integer ;
END ;
$BODY$;

