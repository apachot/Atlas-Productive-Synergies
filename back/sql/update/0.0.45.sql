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

call drop_any_type_of_view_if_exists('vw_establishment_for_partener');

Update nomenclature_product_proximity
set semantic_proximity=0
where not (semantic_proximity between 0.0 and 1.0);

Update nomenclature_product_proximity
set semantic_proximity=0
where semantic_proximity is null;

alter table establishment drop column geo_pos;
alter table establishment add geo_pos geometry GENERATED ALWAYS AS (st_makepoint(((meta -> 'lng'::text))::double precision, ((meta -> 'lat'::text))::double precision)) STORED;

call drop_any_type_of_view_if_exists('vw_naf_proximity');

DROP TABLE IF EXISTS partner_calc ;

CREATE TABLE IF NOT EXISTS partner_calc
(
    id integer,
    nb_semantic integer,
    nb_proximity integer,
    calc boolean,
    PRIMARY KEY (id)
);
create index if not exists partner_calc_idx on partner_calc(id);

CREATE MATERIALIZED VIEW vw_naf_proximity
AS
with prox_naf_hs as (
    select napp.activity_naf2 naf, napp.product_hs4 hs4, napp.proximity
    from nomenclature_activity_product_proximity napp
    where napp.proximity>0.10
),
     raw_prox_naf2 as (
         select pnh.naf, pnh2.naf naf_dest, sum((npp.proximity*pnh.proximity)) naf_dest_proximity
         from prox_naf_hs pnh
                  inner join nomenclature_product_proximity npp
                  inner join prox_naf_hs pnh2
                             on pnh2.hs4 = npp.secondary_product_code_hs4
                             on npp.main_product_code_hs4 = pnh.hs4
                                 and npp.main_product_code_hs4 != npp.secondary_product_code_hs4
                                 and pnh2.naf != pnh.naf
         where npp.proximity>0.10
         group by pnh.naf, pnh2.naf
     ),
     raw_prox_sem_naf2 as (
         select pnh.naf, pnh2.naf naf_dest, sum((npp.semantic_proximity*pnh.proximity)) naf_dest_semantic_proximity
         from prox_naf_hs pnh
                  inner join nomenclature_product_proximity npp
                  inner join prox_naf_hs pnh2
                             on pnh2.hs4 = npp.secondary_product_code_hs4
                             on npp.main_product_code_hs4 = pnh.hs4
                                 and npp.main_product_code_hs4 != npp.secondary_product_code_hs4
                                 and pnh2.naf != pnh.naf
         where npp.semantic_proximity>0.10
         group by pnh.naf, pnh2.naf
     )
select na.id naf_id,
       na_dest.id naf_id_dest,
       coalesce(rpn2.naf_dest_proximity,0) proximity,
       coalesce(rpsn2.naf_dest_semantic_proximity, 0) semantic_proximity
from raw_prox_naf2 rpn2
         full join raw_prox_sem_naf2 rpsn2
                   on rpsn2.naf = rpn2.naf
                       and rpsn2.naf_dest = rpn2.naf_dest
         inner join nomenclature_activity na ON na.code = coalesce(rpsn2.naf, rpn2.naf)
         inner join nomenclature_activity na_dest ON na_dest.code = coalesce(rpsn2.naf_dest, rpn2.naf_dest)
;

CREATE INDEX vw_naf_proximity_idx  ON vw_naf_proximity (naf_id);

drop TABLE if exists IA_establishment_potential_partners ;

CREATE TABLE IA_establishment_potential_partners (
    establishment_id int not null,
    partner_id int not null,
    proximity numeric(7,6),
    semantic_proximity numeric(7,6),
    distance int,
    CONSTRAINT IA_establishment_potential_partners_establishment_id_fkey FOREIGN KEY (establishment_id) REFERENCES establishment(id),
    CONSTRAINT IA_establishment_potential_partners_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES establishment(id),
    PRIMARY KEY (establishment_id, partner_id)
) ;

CREATE INDEX IA_establishment_potential_partners_establishment_id_idx
    ON IA_establishment_potential_partners (establishment_id, partner_id);

CREATE MATERIALIZED VIEW vw_establishment_for_partener
AS
select e.id, e.geo_pos, e.department_code, d.region_id, e.main_activity_id,
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
           end workforce
from establishment e
         inner join department d on d.code = e.department_code
where e.administrative_status = true and e.enabled=true ;

CREATE INDEX vw_establishment_for_partener_idx  ON vw_establishment_for_partener (region_id, main_activity_id);
CREATE INDEX vw_establishment_for_partener_id_idx  ON vw_establishment_for_partener (id);

truncate table IA_establishment_potential_partners;

DROP FUNCTION IF EXISTS func_list_partner ;

CREATE FUNCTION func_list_partner (p_establishment_id integer)
    RETURNS TABLE (
                      e_id int,
                      p_id int,
                      proximity numeric(7,6),
                      semantic_proximity numeric(7,6),
                      distance int
                  )
as $$
declare
    _cst_nb_partner integer := 25 ;
    _nb_semantic integer;
    _nb_proximity integer;
    _calc bool;
BEGIN
    select nb_semantic, nb_proximity, calc
    into _nb_semantic, _nb_proximity, _calc
    from partner_calc
    where id=p_establishment_id;

    -- already calc ?
    IF ((_calc is null) or (not _calc))  THEN
        CREATE TABLE if not exists tmp_epp (
                                               establishment_id int not null,
                                               partner_id int not null,
                                               proximity numeric(7,6),
                                               semantic_proximity numeric(7,6),
                                               distance int
        );
        delete from tmp_epp where establishment_id = p_establishment_id ;

        INSERT INTO partner_calc (id, nb_semantic, nb_proximity, calc)
        VALUES (p_establishment_id, 0, 0, true)
        ON CONFLICT(id) do UPDATE SET calc = true ;

        IF (coalesce(_nb_semantic, 0)<_cst_nb_partner) THEN
            -- semantic
            INSERT INTO tmp_epp (establishment_id, partner_id, proximity, semantic_proximity, distance)
            with ent_dep as (
                select id, geo_pos, region_id, main_activity_id, workforce
                from vw_establishment_for_partener
                where id = p_establishment_id
            ),
                 ent_and_naf as (
                     select ed.id, ed.geo_pos, ed.region_id, ed.main_activity_id, ed.workforce, wnp.naf_id_dest, wnp.proximity, wnp.semantic_proximity
                     from ent_dep ed
                              inner join vw_naf_proximity wnp
                                         on wnp.naf_id = ed.main_activity_id
                     order by wnp.semantic_proximity desc
                     limit 5
                 ),
                 ent_and_pot_part as (
                     select (1-((abs(efp.workforce-ean.workforce)+1)/30.0))* ean.semantic_proximity coef,
                            round(ST_DISTANCE( efp.geo_pos, ean.geo_pos, false )/10)/100 distance,
                            ean.id, ean.geo_pos, ean.proximity, ean.semantic_proximity, efp.id id_dest
                     from ent_and_naf ean
                              inner join vw_establishment_for_partener efp
                                         on efp.region_id = ean.region_id
                                             and efp.main_activity_id = ean.naf_id_dest
                                             and not exists (select 1 from IA_establishment_potential_partners epp where epp.establishment_id = ean.id and epp.partner_id = efp.id)
                                             and not exists (select 1 from IA_establishment_potential_partners epp where epp.partner_id = ean.id and epp.establishment_id = efp.id)
                              left join partner_calc pc on pc.id = efp.id
                     order by (1-((abs(efp.workforce-ean.workforce)+1)/30.0))* ean.semantic_proximity * (1-((LEAST(greatest(pc.nb_semantic, 25), 100)-25)/25.0*0.75)) desc
                     limit 100
                 ),
                 min_max as (
                     select min(eapp.distance) mind, max(eapp.distance)-min(eapp.distance) maxd
                     from ent_and_pot_part eapp
                 )
            select eapp.id establishment_id, eapp.id_dest partner_id, eapp.proximity, eapp.semantic_proximity, round(eapp.distance)::integer distance
            from ent_and_pot_part eapp
                     cross join min_max mm
            order by (0.75 + ((eapp.distance-mm.mind)/greatest(mm.maxd,0.0001))/4) * eapp.coef desc
            limit (_cst_nb_partner - (coalesce(_nb_semantic,0))) ;

            INSERT INTO IA_establishment_potential_partners(establishment_id, partner_id, proximity, semantic_proximity, distance)
            Select LEAST(epp.establishment_id, epp.partner_id) establishment_id, GREATEST(epp.establishment_id, epp.partner_id) partner_id, epp.proximity, epp.semantic_proximity, epp.distance
            from tmp_epp epp
            ON CONFLICT (establishment_id, partner_id) DO NOTHING;

            INSERT INTO partner_calc (id, nb_semantic, nb_proximity, calc)
            select establishment_id id, count(1) nbr_s, 0 nb_p, true calc
            from tmp_epp epp
            group by establishment_id
            union all
            select partner_id, count(1), 0, false
            from tmp_epp epp
            group by partner_id
            on CONFLICT(id)
                DO UPDATE SET
                              nb_semantic = partner_calc.nb_semantic+EXCLUDED.nb_semantic,
                              calc = partner_calc.calc or excluded.calc ;
            delete from tmp_epp where establishment_id = p_establishment_id ;
        END IF ;

        IF (coalesce(_nb_proximity, 0)<_cst_nb_partner) THEN
            -- standard
            INSERT INTO tmp_epp(establishment_id, partner_id, proximity, semantic_proximity, distance)
            with ent_dep as (
                select id, geo_pos, region_id, main_activity_id, workforce
                from vw_establishment_for_partener
                where id = p_establishment_id
            ),
                 ent_and_naf as (
                     select ed.id, ed.geo_pos, ed.region_id, ed.main_activity_id, ed.workforce, wnp.naf_id_dest, wnp.proximity, wnp.semantic_proximity
                     from ent_dep ed
                              inner join vw_naf_proximity wnp
                                         on wnp.naf_id = ed.main_activity_id
                     order by wnp.proximity desc
                     limit 5
                 ),
                 ent_and_pot_part as (
                     select (1-((abs(efp.workforce-ean.workforce)+1)/30.0))* ean.semantic_proximity coef,
                            round(ST_DISTANCE( efp.geo_pos, ean.geo_pos, false )/10)/100 distance,
                            ean.id, ean.geo_pos, ean.proximity, ean.semantic_proximity, efp.id id_dest
                     from ent_and_naf ean
                              inner join vw_establishment_for_partener efp
                                         on efp.region_id = ean.region_id
                                             and efp.main_activity_id = ean.naf_id_dest
                                             and not exists (select 1 from IA_establishment_potential_partners epp where epp.establishment_id = ean.id and epp.partner_id = efp.id)
                                             and not exists (select 1 from IA_establishment_potential_partners epp where epp.partner_id = ean.id and epp.establishment_id = efp.id)
                              left join partner_calc pc on pc.id = efp.id
                     order by (1-((abs(efp.workforce-ean.workforce)+1)/30.0))* ean.semantic_proximity * (1-((LEAST(greatest(pc.nb_proximity, 25), 100)-25)/25.0*0.75)) desc
                     limit 100
                 ),
                 min_max as (
                     select min(eapp.distance) mind, max(eapp.distance)-min(eapp.distance) maxd
                     from ent_and_pot_part eapp
                 )
            select eapp.id establishment_id, eapp.id_dest partner_id, eapp.proximity, eapp.semantic_proximity, round(eapp.distance)::integer distance
            from ent_and_pot_part eapp
                     cross join min_max mm
            order by (0.75 + ((eapp.distance-mm.mind)/greatest(mm.maxd,0.0001))/4) * eapp.coef desc
            limit (_cst_nb_partner - (coalesce(_nb_proximity,0))) ;

            INSERT INTO IA_establishment_potential_partners(establishment_id, partner_id, proximity, semantic_proximity, distance)
            Select LEAST(epp.establishment_id, epp.partner_id) establishment_id, GREATEST(epp.establishment_id, epp.partner_id) partner_id, epp.proximity, epp.semantic_proximity, epp.distance
            from tmp_epp epp
            ON CONFLICT (establishment_id, partner_id) DO NOTHING;

            INSERT INTO partner_calc (id, nb_proximity, nb_semantic, calc)
            select establishment_id id, count(1) nbr_s, 0 nb_p, true calc
            from tmp_epp epp
            group by establishment_id
            union all
            select partner_id, count(1), 0, false
            from tmp_epp epp
            group by partner_id
            on CONFLICT(id)
                DO UPDATE SET
                              nb_proximity = partner_calc.nb_proximity+EXCLUDED.nb_proximity,
                              calc = partner_calc.calc or excluded.calc ;
            delete from tmp_epp where establishment_id = p_establishment_id ;
        END IF ;
    END IF;

    RETURN QUERY
        select epp.establishment_id, epp.partner_id, epp.proximity, epp.semantic_proximity, epp.distance
        from IA_establishment_potential_partners epp
        WHERE epp.establishment_id = p_establishment_id
        UNION ALL
        select epp.partner_id, epp.establishment_id, epp.proximity, epp.semantic_proximity, epp.distance
        from IA_establishment_potential_partners epp
        WHERE epp.partner_id = p_establishment_id
    ;
END ;
$$ LANGUAGE plpgsql;


SET client_min_messages TO WARNING;

DROP PROCEDURE IF EXISTS create_IA_establishment_potential_partners ;

CREATE PROCEDURE create_IA_establishment_potential_partners(_workforce_min int)
AS $$
DECLARE
    _nbr int ;
    _offset int ;
    _limit int = 100 ;
    _workforce int = 13;
    _nbr_actu int = 0;
    _nbr_max int = 3999;
BEGIN
    <<workforce>>
    LOOP
        select count(1) into _nbr
        from vw_establishment_for_partener wefp
        where workforce=_workforce
          and not exists (select 1 from partner_calc where partner_calc.id = wefp.id and calc = true) ;
        if (_nbr>0) then
            _offset := 0 ;
            <<offset>>
            LOOP
                _nbr_actu = _nbr_actu + _limit;
                raise warning 'workforce %: % / %', _workforce, LEAST(_offset + _limit, _nbr), _nbr;
                PERFORM
                    (
                        with wefp as (
                            select wefp.id
                            from vw_establishment_for_partener wefp
                            where wefp.workforce=_workforce
                              and not exists (select 1 from partner_calc where partner_calc.id = wefp.id and calc = true)
                            order by wefp.id
                            limit _limit
                        )
                        select count(1) from wefp cross join lateral func_list_partner(wefp.id) flp
                    ) ;
                BEGIN
                    COMMIT;
                EXCEPTION WHEN OTHERS THEN
                END ;
                if (_nbr_actu > _nbr_max) THEN
                    exit offset;
                END IF;
                _offset = _offset + _limit ;
                if (_offset > _nbr) THEN
                    EXIT offset;
                END IF ;
            END LOOP offset;
        END IF ;
        if (_nbr_actu > _nbr_max) THEN
            exit workforce;
        END IF;
        _workforce := _workforce - 1 ;
        if (_workforce < _workforce_min ) then
            exit workforce;
        end if;
    END LOOP workforce;
END ;
$$ LANGUAGE plpgsql;

-- CALL create_IA_establishment_potential_partners(4);
-- CALL create_IA_establishment_potential_partners(4);
-- CALL create_IA_establishment_potential_partners(4);
-- CALL create_IA_establishment_potential_partners(4);

-- DROP PROCEDURE IF EXISTS create_IA_establishment_potential_partners ;