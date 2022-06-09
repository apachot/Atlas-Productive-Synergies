
/*
 Correction of error on the establishment department
 */

update establishment
set department_code = case when left(city.zip_code,3) in ('971','972','973', '974', '976') then left(city.zip_code,3)
                           else left(city.zip_code,2) end
from address
         inner join city on city.id = address.city_id
where address.id = address_id
  and ( (department_code not in ('2A', '2B', '971', '972', '973', '974', '976') and department_code <> left(city.zip_code,2))
    or (department_code in ('971','972','973', '974', '976') and department_code <> left(city.zip_code,3) )
    or (department_code in ('2A', '2B') and '20' <> left(city.zip_code,2) )
    )	 ;

/*
 Optimisation for IA
 - add geometry in then establishment
 - add index for specific research
 */

alter table establishment add geo_pos geometry;

update establishment set geo_pos = ST_MakePoint(
        coordinates[0]::double precision,
        coordinates[1]::double precision
    )
from address
where address.id = establishment.address_id;

CREATE INDEX establishment_rech_geo_idx
    ON establishment(administrative_status, main_activity_id, department_code) include (geo_pos) ;

/*
    creation of a table to stock IA result
 */

CREATE TABLE IA_establishment_potential_partners (
                                                     id serial,
                                                     establishment_id int not null,
                                                     partner_id int not null,
                                                     created_at timestamp without time zone NOT NULL DEFAULT now(),
                                                     CONSTRAINT IA_establishment_potential_partners_establishment_id_fkey FOREIGN KEY (establishment_id) REFERENCES establishment(id),
                                                     CONSTRAINT IA_establishment_potential_partners_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES establishment(id),
                                                     CONSTRAINT IA_establishment_potential_partners_pkey PRIMARY KEY (id)
) ;

CREATE INDEX IA_establishment_potential_partners_establishment_id_idx
    ON IA_establishment_potential_partners (establishment_id);
/*
 Insertion in the table by a stored proc
 */

CREATE PROCEDURE create_IA_establishment_potential_partners()
AS $$
DECLARE
    _cur_department cursor for
        select distinct department_code, count(1) as nbr from establishment group by department_code order by 1 ;
BEGIN
    truncate table IA_establishment_potential_partners ;
    FOR _record IN _cur_department LOOP
            raise notice 'department_code: % (%)', _record.department_code, _record.nbr;

            insert into IA_establishment_potential_partners (establishment_id, partner_id)
            with naf_etablishment as (
                select e.id as e_id, na.code as naf_etablissement,
                       e.geo_pos as e_pos,
                       e.department_code
                from establishment e
                         inner join nomenclature_activity na ON na.id = e.main_activity_id
                where e.department_code = _record.department_code
                  and e.administrative_status = true
            )
               , hs4_produit as (
                select ne.e_id, ne.naf_etablissement, ne.e_pos, ne.department_code, ap.product_hs4 as hs4_produit
                from naf_etablishment ne
                         cross join lateral (
                    SELECT activite_produit.product_hs4
                    FROM nomenclature_activity_product_proximity activite_produit
                    WHERE activite_produit.activity_naf2 = ne.naf_etablissement
                    ORDER BY activite_produit.proximity DESC
                    LIMIT 1
                    ) ap
            )
               , hs4_produit_client as (
                select hp.e_id, hp.naf_etablissement, hp.e_pos, hp.department_code, hp.hs4_produit, parent.hs4_produit_client
                from hs4_produit hp
                         cross join lateral (
                    SELECT parente.secondary_product_code_hs4 as hs4_produit_client
                    FROM nomenclature_product_proximity parente
                    WHERE parente.semantic_proximity != 'NaN'
                      and parente.secondary_product_code_hs4 != parente.main_product_code_hs4
                      and parente.main_product_code_hs4 = hp.hs4_produit
                    ORDER BY parente.semantic_proximity DESC
                    LIMIT 1
                    ) parent
            )
               , naf_client as (
                select hpc.e_id, hpc.naf_etablissement, hpc.e_pos, hpc.department_code, hpc.hs4_produit, hpc.hs4_produit_client, napp.naf_client, napp.id_naf_client
                from hs4_produit_client hpc
                         cross join lateral (
                    SELECT activite_produit.activity_naf2 as naf_client, na.id id_naf_client
                    FROM nomenclature_activity_product_proximity activite_produit
                             inner join nomenclature_activity na
                                        on na.code = activite_produit.activity_naf2
                    WHERE activite_produit.product_hs4 = hpc.hs4_produit_client
                    ORDER BY activite_produit.proximity DESC
                    LIMIT 1
                    ) napp
            )
               , list_partner as (
                select nc.e_id, nc.naf_etablissement, nc.e_pos, nc.department_code, nc.hs4_produit, nc.hs4_produit_client, nc.naf_client, nc.id_naf_client, lst.p_id
                from naf_client nc
                         cross join lateral (
                    SELECT e.id p_id
                    FROM establishment e
                    WHERE e.administrative_status = true
                      AND e.main_activity_id = nc.id_naf_client
                      AND e.department_code = nc.department_code
                    ORDER BY ST_Distance(
                                     nc.e_pos,
                                     e.geo_pos
                                 )
                    LIMIT 10
                    ) lst
            )
            select lp.e_id as src_id, lp.p_id as partner_id
            from list_partner lp ;

        END LOOP ;
END ;
$$ LANGUAGE plpgsql;

CALL create_IA_establishment_potential_partners();

DROP PROCEDURE create_IA_establishment_potential_partners();