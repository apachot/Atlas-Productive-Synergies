truncate table partner_calc_iot;

CREATE OR REPLACE FUNCTION public.func_list_partner_iot(
    p_e_id integer)
    RETURNS TABLE(e_id integer, p_id integer, customer boolean, provider boolean, distance integer, cust_coef numeric, prov_coef numeric)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    _cst_nb_partner integer := 25 ;
    _min_coef numeric(10,8) := 0.03;
    _nb_supplier integer;
    _nb_customer integer;
    _calc boolean;
    _nace_start varchar(5);
    _region_id integer;
    _workforce integer;
    _geo_pos geometry;
BEGIN
    select
        iot.nb_supplier,
        iot.nb_customer,
        iot.calc,
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
    into _nb_supplier, _nb_customer, _calc, _nace_start, _region_id, _workforce, _geo_pos
    from establishment e
             inner join nomenclature_activity na ON na.id = e.main_activity_id
             inner join department d on d.code = e.department_code
             left join partner_calc_iot iot on iot.id = e.id
    where e.id=p_e_id;

    IF (_calc is null or not _calc) THEN
        delete from tmp_iot where establishment_id = p_e_id;
        /* Manage the list of establishment that provide the selected establishment */
        /* Insert into a temporary sheet the partner_id table from customer coefficient */
        INSERT INTO tmp_iot ( establishment_id, partner_id, customer, provider, distance, cust_coef, prov_coef)
        with sel_raw as
                 (
                     /* Select all naces that are destinated to be supplier of the nace of selected establishment */
                     select dest, round(qte/ sum(qte) over (partition by nace) * 100) :: integer nombre, qte/ sum(qte) over (partition by nace) coef

                     from (
                              /* Select the nace of the establishment, the nace of suppliers, the quantity of intermediate consumption and the quantity for each nace */
                              select prod.nace, prod.dest, prod.qte, prod.qte / sum(prod.qte) over (partition by prod.nace) _sum
                                  /* _sum is equal to the intermediate consumptiuon from nace.dest divided by the sum of intermediate consumption */
                                  /* from table iot_consume_nace_prod we register all naces that are suppliers for the nace of selected establishment */
                              from iot_consume_nace prod
                              where prod.nace = _nace_start
                                  /* Don't take the same nace of the establishment */
                                and prod.dest <> _nace_start
                          )
                              /* Register the query as t */
                              t
                         /* Delete all naces that don't have coeff larger than 0.03 as supplier */
                     where t._sum>_min_coef
                     ORDER BY t._sum DESC
                 )
            /* Select all etablishment id which have same nace than supplier nace */
        select  		p_e_id e_id,
                      part.id p_id,
                      false as customer,
                      true as provider,
                      round(part.distance/1000)::integer distance,
                      null::numeric(12,8) as cust_coef,
                      max(part.coef) as prov_coef
        from sel_raw sr
                 cross join lateral
            (
            select efp.id, efp.nace, ST_DISTANCE( efp.geo_pos, _geo_pos, false ) distance, sr.coef
                /* From the materialized view vw_establishment for partener as efp */
            from vw_establishment_for_partener efp
                     /* We merge all companies that have the same id */
                     left join partner_calc_iot pci on pci.id = efp.id
                /* Here  we select all companies that have the same nace than the dest of the main nace of the requested establishment */
            where efp.nace = sr.dest
                /* And located in the same region thant the selected company */
              and efp.region_id = _region_id
                /* Order results by the difference of number of employees, and then by distance */
            order by abs(efp.workforce - _workforce)+(coalesce(pci.nb_supplier,0) * 0.1), ST_DISTANCE( efp.geo_pos, _geo_pos, false )
            --limit 100
            ) part
        group by part.id, round(part.distance/1000)::integer ;
        /* Out of this, we have the
        - etablishment id in input of the function
        - partner_id from materialized view vw_establishment_for_partener
        - provider which is a boleean if partner establishment is provider or not
        - customer which is a bolean if partner establishment is customer or noter
        - customer coeff which is the intermediate consumption from selected establishment to partner (not null)
        - provider coeff which is the intermediate consumption from selected establishment to partner (empty)
        - distance which is the computed distance between both establishment
        */

/* Insert into IA_potential_by_iot table, rows with selected value for the selected establishment */
        INSERT INTO IA_potential_by_iot (establishment_id, partner_id, customer, provider, distance, cust_coef, prov_coef)
        select LEAST(tmp_iot.establishment_id, tmp_iot.partner_id),
               GREATEST(tmp_iot.establishment_id, tmp_iot.partner_id),
               tmp_iot.customer,
               tmp_iot.provider,
               tmp_iot.distance,
               tmp_iot.cust_coef,
               tmp_iot.prov_coef
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        ON CONFLICT (establishment_id, partner_id) DO
            UPDATE SET provider = true, prov_coef=excluded.prov_coef ;
        /* In output we have :
        - Selected establishment id as establishment_id
        - ID of partner's establishment
        - Customer is the same bolean as above
        - Supplier is the same bolean as above
        - Distance is the distance computed before
        - Cust_coeff is also the coef on intermediate consumption computed above (null value)
        - Same for prov_coeff (existing value)
        */

/* Insert into partner_calc_iot table the value of :
- The establishment id selected
- The number of registered supplier
- The number of registered customer
- A bolean variable that indicate if the calcul was already done or not
*/
        INSERT INTO partner_calc_iot (id, nb_supplier, nb_customer, calc)
        select tmp_iot.establishment_id, Count(1) nbr_s, 0 nbr_p, true
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        group by tmp_iot.establishment_id
        UNION ALL
        select tmp_iot.partner_id, count(1), 0, false
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        group by tmp_iot.partner_id
        ON CONFLICT (id) DO
            UPDATE SET
                       nb_supplier = partner_calc_iot.nb_supplier+excluded.nb_supplier,
                       calc = partner_calc_iot.calc or excluded.calc ;
        /* We don't have interested output from this part */

/* Delete the temporary sheet computed before */
        delete from tmp_iot where establishment_id = p_e_id;

/* Same part than before for the customer establishment */
        INSERT INTO tmp_iot ( establishment_id, partner_id, customer, provider, distance, cust_coef, prov_coef)
        with sel_raw as
                 (
                     select dest, round(qte/ sum(qte) over (partition by nace) * 100) :: integer nombre, qte/ sum(qte) over (partition by nace) coef
                     from (
                              select prod.nace, prod.dest, qte, (qte / sum(qte) over (partition by prod.nace)) _sum
                              from iot_production_nace prod
                              where prod.nace = _nace_start
                                and prod.dest <> _nace_start
                          ) t
                     where t._sum> _min_coef
                     ORDER BY t._sum DESC
                 )
        select p_e_id e_id,
               part.id p_id,
               true as customer,
               false as provider,
               round(part.distance/1000)::integer distance,
               max(part.coef) as cust_coef,
               null::numeric(12,8) as prov_coef
        from sel_raw sr
                 cross join lateral (
            select efp.id, efp.nace, ST_DISTANCE( efp.geo_pos, _geo_pos, false ) distance, sr.coef
            from vw_establishment_for_partener efp
                     left join partner_calc_iot pci on pci.id = efp.id
            where efp.nace = sr.dest
              and efp.region_id = _region_id
              and sr.coef IS NOT NULL
            order by sr.coef DESC NULLS LAST, abs(efp.workforce - _workforce)+(coalesce(pci.nb_customer,0) * 0.1), ST_DISTANCE( efp.geo_pos, _geo_pos, false )
            --limit 100
            ) part
        group by part.id, round(part.distance/1000)::integer ;

        INSERT INTO IA_potential_by_iot (establishment_id, partner_id, customer, provider, distance, cust_coef, prov_coef)
        select LEAST(tmp_iot.establishment_id, tmp_iot.partner_id),
               GREATEST(tmp_iot.establishment_id, tmp_iot.partner_id),
               tmp_iot.customer,
               tmp_iot.provider,
               tmp_iot.distance,
               tmp_iot.cust_coef,
               tmp_iot.prov_coef
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        ON CONFLICT (establishment_id, partner_id) DO
            UPDATE SET customer = true, cust_coef = excluded.cust_coef;

        INSERT INTO partner_calc_iot (id, nb_supplier, nb_customer, calc)
        select tmp_iot.establishment_id, 0 nbr_s, Count(1) nbr_p, true
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        group by tmp_iot.establishment_id
        UNION ALL
        select tmp_iot.partner_id, 0, count(1), false
        from tmp_iot
        where tmp_iot.establishment_id = p_e_id
        group by tmp_iot.partner_id
        ON CONFLICT (id) DO
            UPDATE SET
                       nb_customer = partner_calc_iot.nb_customer+excluded.nb_customer,
                       calc = partner_calc_iot.calc or excluded.calc ;

        -- cleaning
        delete from tmp_iot where establishment_id = p_e_id;
    END IF ;

    RETURN QUERY
        (
            SELECT * FROM
                (	select epp.establishment_id, epp.partner_id, epp.customer, epp.provider, epp.distance, epp.cust_coef, epp.prov_coef
                     from IA_potential_by_iot epp
                         /* Select only establishment that are partner id */
                     WHERE epp.establishment_id = p_e_id

                     UNION ALL
                     /* Select the part of customer  displayed in the request */
                     select epp.partner_id, epp.establishment_id, epp.customer, epp.provider, epp.distance, epp.cust_coef customer, epp.prov_coef
                     from IA_potential_by_iot epp
                         /* Select only establishment that are partner id */
                     WHERE epp.partner_id = p_e_id

                ) sel
/* Limit at the 100 first companies which have the higher provider coeff */
            ORDER BY sel.prov_coef   DESC NULLS LAST
            limit 100
        )
        UNION
        (
            SELECT * FROM
                (	select epp.establishment_id, epp.partner_id, epp.customer, epp.provider, epp.distance, epp.cust_coef, epp.prov_coef
                     from IA_potential_by_iot epp
                         /* Select only establishment that are partner id */
                     WHERE epp.establishment_id = p_e_id

                     UNION ALL
                     /* Select the part of customer  displayed in the request */
                     select epp.partner_id, epp.establishment_id, epp.customer, epp.provider, epp.distance, epp.cust_coef customer, epp.prov_coef
                     from IA_potential_by_iot epp
/* Select only establishment that are partner id */
                     WHERE epp.partner_id = p_e_id

                ) sel
            ORDER BY  sel.cust_coef   DESC NULLS LAST
/* Limit at the 100 first companies which have the higher provider coeff */
            limit 100
        )
    ;
END ;
$BODY$;

ALTER FUNCTION public.func_list_partner_iot(integer)
    OWNER TO iat;

call create_IA_establishment_potential_partners(10) ;

with list as (
    select 'C10D' as code, hstore('en', 'Manufacture of vegetable and animal oils and fats') as name
    union all select 'C16Z', hstore('en', 'Woodworking and manufacture of articles of wood and cork, except furniture; manufacture of articles of basketwork and esparto')
    union all select 'C20C', hstore('en', 'Manufacture of other chemicals and man-made fibers')
    union all select 'C23B', hstore('en', 'Manufacture of other non-metallic mineral products except glass')
    union all select 'C24A', hstore('en', 'Iron and steel industry and primary steel processing')
    union all select 'C25B', hstore('en', 'Manufacture of tanks, cisterns and containers of metal; manufacture of steam generators, except central heating boilers')
    union all select 'C25D', hstore('en', 'Forging, metal processing, machining')
    union all select 'C25E', hstore('en', 'Manufacture of cutlery, tools, hardware and other articles of metal')
    union all select 'C26G', hstore('en', 'Manufacture of optical and photographic equipment; manufacture of magnetic and optical media')
    union all select 'C27B', hstore('en', 'Manufacture of other electrical equipment')
    union all select 'C28A', hstore('en', 'Manufacture of general-purpose machinery and equipment')
    union all select 'C29A', hstore('en', 'Construction of motor vehicles; manufacture of bodies and trailers')
    union all select 'C32A', hstore('en', 'Manufacture of jewelery, jewelry and musical instruments')
    union all select 'C32C', hstore('en', 'Manufacture of sporting goods, games and toys and other manufacturing activities')
    union all select 'D35B', hstore('en', 'Production and distribution of gaseous fuels, steam and air conditioning')
    union all select 'G46Z', hstore('en', 'Wholesale trade, except of motor vehicles and motorcycles')
    union all select 'G47Z', hstore('en', 'Retail trade, except of motor vehicles and motorcycles')
    union all select 'H49A', hstore('en', 'Rail transport')
    union all select 'H49C', hstore('en', 'Road freight and pipeline transport')
    union all select 'L68A', hstore('en', 'Activities of real estate dealers and real estate activities for third parties')
)
update util_nomenclature_naf_a129
set name = util_nomenclature_naf_a129.name || list.name
from list
where util_nomenclature_naf_a129.code = list.code and util_nomenclature_naf_a129.name->'en' is null;

with list as (
    select '25.50A' code, hstore('en', 'Forging, stamping, forging; powder metallurgy') as name
    union all select '47.52A', hstore('en', 'Retail sale of hardware, paints and glasses in small outlets (less than 400 m²)')
    union all select '47.52B', hstore('en', 'Retail sale of hardware, paints and glasses in supermarkets (400 m² and more)')
    union all select '59.13B', hstore('en', 'Video editing and distribution')
    union all select '60.20A', hstore('en', 'Editing generalist channels')
    union all select '60.20B', hstore('en', 'Editing of thematic channels')
    union all select '58.29B', hstore('en', 'Software publishing development tools and languages')
    union all select '58.29C', hstore('en', 'Application software publishing')
    union all select '87.10C', hstore('en', 'Healthcare accommodation for disabled adults and other healthcare accommodation')
    union all select '87.30B', hstore('en', 'Social housing for physically disabled')
    union all select '88.99A', hstore('en', 'Other reception or support without accommodation for children and adolescents')
)
update util_nomenclature_naf_a732
set name = util_nomenclature_naf_a732.name || list.name
from list
where util_nomenclature_naf_a732.code = list.code and util_nomenclature_naf_a732.name->'en' is null;