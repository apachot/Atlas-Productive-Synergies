<?php


namespace App\Repository;

use App\Entity\AbstractEntity;
use App\Utility\Sql;
use PDO;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use App\Utility\Json;

/**
 * Specific repository for establishment
 */
class EstablishmentRepository extends EntityRepository
{
    protected string $entityName = "establishment";

    public function findOneById(int $id): AbstractEntity
    {
        $sql = "
SELECT establishment.usual_name,
       establishment.workforce_group

FROM establishment
    

WHERE establishment.id = :establishmentId 
        ;";

        $statement = $this->databaseService->prepare($sql);
        $statement->setFetchMode(PDO::FETCH_ASSOC);
        $statement->bindParam(":establishmentId", $id, PDO::PARAM_INT);
        $statement->execute();
        $data = $statement->fetch();

        return $this->databaseService->createEntity($this->entityName, $data);
    }

    /**
     * @param array $params
     * @return mixed
     * @throws \App\Exception\DatabaseException
     * @throws \JsonException
     */
    public function findByParams(array $params)
    {
        return $this->getEstablishmentList($params);
    }

    /**
     * call the list without partners for optimization
     * @param array $params
     * @param array $additionalWhere
     * @param callable|null $callback
     * @return mixed
     * @throws \App\Exception\DatabaseException
     */
    public function findByParamsWithoutPartners(array $params)
    {
        return $this->getEstablishmentListWithoutPartners($params);
    }


    private function getParamsWithoutEstablishment(array $params) : array
    {
        $paramsWithoutId = $params;
        if (array_key_exists('establishment', $paramsWithoutId)) {
            unset($paramsWithoutId['establishment']);
        }
        return $paramsWithoutId ;
    }

    private function getEstablishmentsOnly(array $params) : array
    {
        $paramsWithoutId = $this->getParamsWithoutEstablishment($params);
        $a129Name = Sql::makeI18nSelect('a129.name', $params, '');
        $a732Name = Sql::makeI18nSelect('a732.name', $params, '');
        $sql = "
            SELECT
               e.id,
               e.siret,
               e.usual_name,
               jsonb_build_array(e.meta->'lat',e.meta->'lng') coordinates,
               e.meta->'activity' as activity_code,
               e.sector_id,
               e.workforce_group,
               cast({$a129Name} as varchar(255)) || '. ' || cast({$a732Name} as varchar(255)) as naf_description,
               exists (select 1 
                        from nomenclature_link_activity_rome nlar 
                        where nlar.activity_naf_code = e.meta->'activity'
                        AND %nlar%
                       )  rome_chapter_exists
            FROM establishment e
                LEFT JOIN nomenclature_activity na ON e.main_activity_id = na.id
                LEFT JOIN util_nomenclature_naf_a732 a732
                    INNER JOIN util_nomenclature_naf_a129 a129
                    ON a129.id = a732.util_nomenclature_naf_a129_id
                ON a732.code = na.code
            WHERE
                %where%
        ;
        ";

        $statement = $this->bindWhereGlobal($paramsWithoutId, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }

        return array_map(
            static function ($establishment) {
                $establishment['coordinates'] = Json::decode($establishment['coordinates']);
                return $establishment;
            },
            $results
        );
    }

    private function getEstablishmentsBiom(array $params) : ?array
    {
        $paramsWithoutId = $this->getParamsWithoutEstablishment($params);
        $sql = "
            with e as (
                select b.*, e.epci_code
                from biom b
                    left join establishment e on e.id = b.id
            ),data as (
                select count(*) nbr
                    , avg(biom) biom
                    , avg(q1) q1
                    , AVG(q2) q2
                    , AVG(q3) q3
                    , AVG(q4) q4
                    , AVG(q5) q5
                    , AVG(q6) q6
                    , AVG(q7) q7
                    , AVG(q8) q8
                    , avg(q10) q10
                from e
                where %where%)
            select jsonb_build_object(
                'nbr', nbr, 
                'biom', round(biom,2),
                'C1', round((q2+q3) / (q1 * 1.0),2), 
                'C2', round((1.0 * q4/q1 ),2),
                'C3', round((1.0 * q5/q1),2),
                'C4', q6,
                'C5', round((1.0 * q7/q1),2),
                'C6', round(q8,2),
                'C8', round(q10,2)
            ) result    
            from data;
        ";

        $statement = $this->bindWhereGlobal($paramsWithoutId, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetch(PDO::FETCH_ASSOC  | PDO::FETCH_UNIQUE)) {
            return null;
        }
        return Json::decode($results["result"]);
    }

    private function getEstablishmentsParity(array $params) : ?float
    {
        $paramsWithoutId = $this->getParamsWithoutEstablishment($params);
        $sql = "
            select avg(score) score
            from establishment e
                inner join parity p
                on p.id=e.id
            where 
                  %where% ;
        ";
        $statement = $this->bindWhereGlobal($paramsWithoutId, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetch(PDO::FETCH_ASSOC  | PDO::FETCH_UNIQUE)) {
            return null;
        }
        return $results["score"];
    }

    private function getEstablishmentsPartner(array $params) : array
    {
        $paramsWithoutId = $this->getParamsWithoutEstablishment($params);
        $a129Name = Sql::makeI18nSelect('a129.name', $params, '');
        $a732Name = Sql::makeI18nSelect('a732.name', $params, '');
        $sql = "
            with start_e as
            (
                select e.id, e.workforce_count
                FROM establishment e
                WHERE 
                    %where%
                order by e.workforce_count desc	
                limit 50
            ),
            partners as (
                select LEAST(start_e.id, p.partner_id) src_id, GREATEST(start_e.id, p.partner_id) dest_id, start_e.workforce_count + p.workforce_count workforce_count
                from start_e 
                cross join lateral (
                    select p.partner_id, p.workforce_count
                    from (
                        select epp.partner_id, e.workforce_count, epp.prov_coef coef
                        from IA_potential_by_iot epp
                            inner join establishment e on e.id = epp.partner_id
                        where 
                            %where%
            
                            and epp.establishment_id = start_e.id 
                            and epp.provider = true
                        UNION ALL
                        select epp.establishment_id, e.workforce_count, epp.prov_coef coef
                        from IA_potential_by_iot epp
                            inner join establishment e on e.id = epp.establishment_id
                        where 
                            %where%
            
                            and epp.partner_id = start_e.id 
                            and epp.provider = true			
                    ) p 
                    order by p.coef
                    limit 5
                ) p
                union
                select LEAST(start_e.id, p.partner_id) src_id, GREATEST(start_e.id, p.partner_id) dest_id, start_e.workforce_count + p.workforce_count workforce_count
                from start_e 
                cross join lateral (
                    select p.partner_id, p.workforce_count
                    from (
                        select epp.partner_id, e.workforce_count, epp.cust_coef coef
                        from IA_potential_by_iot epp
                            inner join establishment e on e.id = epp.partner_id
                        where 
                            %where%
            
                            and epp.establishment_id = start_e.id 
                            and epp.customer = true
                        UNION ALL
                        select epp.establishment_id, e.workforce_count, epp.cust_coef coef
                        from IA_potential_by_iot epp
                            inner join establishment e on e.id = epp.establishment_id
                        where 
                            %where%
            
                            and epp.partner_id = start_e.id 
                            and epp.customer = true			
                    ) p 
                    order by p.coef
                    limit 5
                ) p 
            )
            , establ_part as (
                select src_id id from partners
                UNION select dest_id from partners
            )
            , establ as (
                select e.id, e.meta->'lat' lat, e.meta->'lng' lng, e.sector_id, e.workforce_group
                    , cast({$a129Name} as varchar(255)) || '. ' || cast({$a732Name} as varchar(255)) naf_description,
                   exists (select 1 
                            from nomenclature_link_activity_rome nlar 
                            where nlar.activity_naf_code = e.meta->'activity'
                            AND %nlar%
                           )  rome_chapter_exists	
                from establ_part
                    inner join establishment e on e.id = establ_part.id
                    LEFT JOIN nomenclature_activity na
                        INNER JOIN util_nomenclature_naf_a732 a732
                            INNER JOIN util_nomenclature_naf_a129 a129
                            ON a129.id = a732.util_nomenclature_naf_a129_id
                        ON a732.code = na.code	
                    ON na.id = e.main_activity_id
            )	
            
            select json_build_object(
                'src', jsonb_build_object(
                           'id', e_src.id, 'coordinates', 
                           jsonb_build_array(e_src.lat, e_src.lng),
                           'sector_id', e_src.sector_id,
                           'workforce_group', e_src.workforce_group,
                           'naf_description', e_src.naf_description,
                           'rome_chapter_exists', e_src.rome_chapter_exists
                       ),
                'dest', jsonb_build_object(
                           'id', e_dest.id, 'coordinates', 
                           jsonb_build_array(e_dest.lat, e_dest.lng),
                           'sector_id', e_dest.sector_id,
                           'workforce_group', e_dest.workforce_group,
                           'naf_description', e_dest.naf_description,
                           'rome_chapter_exists', e_dest.rome_chapter_exists
                       )
                ) as partner
            from partners p
                inner join establ e_src ON e_src.id = p.src_id
                inner join establ e_dest ON e_dest.id = p.dest_id
            order by workforce_count desc
            limit 250          
        ";
        $statement = $this->bindWhereGlobal($paramsWithoutId, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }
        return array_map(
            static function ($partner) {
                return Json::decode($partner['partner']);
            },
            $results
        );
    }

    private function getEstablishmentsEmployer(array $params) : array
    {
        $a129Name = Sql::makeI18nSelect('a129.name', $params, '');
        $a732Name = Sql::makeI18nSelect('a732.name', $params, '');
        $sql = "
            SELECT
               e.id,
               e.siret,
               e.usual_name,
               jsonb_build_array(e.meta->'lat',e.meta->'lng') coordinates,
               e.meta->'activity' as activity_code,
               e.sector_id,
               e.workforce_group,
               cast({$a129Name} as varchar(255)) || '. ' || cast({$a732Name} as varchar(255)) naf_description,
               exists (select 1 
                        from nomenclature_link_activity_rome nlar 
                        where nlar.activity_naf_code = e.meta->'activity'
                        AND %nlar%
                       )  rome_chapter_exists
            FROM establishment e
                LEFT JOIN nomenclature_activity na ON e.main_activity_id = na.id
                LEFT JOIN util_nomenclature_naf_a732 a732
                    INNER JOIN util_nomenclature_naf_a129 a129
                    ON a129.id = a732.util_nomenclature_naf_a129_id
                ON a732.code = na.code
            WHERE
                %where%
            ORDER BY e.workforce_count desc, e.usual_name
            LIMIT 10;
        ";
        $paramsMini = $params;
        unset(
            $paramsMini['domain'],
            $paramsMini['sector'],
            $paramsMini['workforce'],
            $paramsMini['rome'],
            $paramsMini['hs4'],
            $paramsMini['establishment']
        );
        $statement = $this->bindWhereGlobal($paramsMini, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }

        return array_map(
            static function ($establishment) {
                $establishment['coordinates'] = Json::decode($establishment['coordinates']);
                return $establishment;
            },
            $results
        );
    }

    /**
     * @param $params
     * @param array $additionalWhere
     * @param callable|null $callback
     * @return mixed
     * @throws \App\Exception\DatabaseException
     * @throws \JsonException
     */
    private function getEstablishmentList($params)
    {
        $part = array_key_exists('part', $params) ? $params['part'] : "all" ;
        $return['establishments'] = in_array($part, ["all", "establishments"]) ? $this->getEstablishmentsOnly($params) : null;
        $return['biom'] = in_array($part, ["all", "biom"]) ? $this->getEstablishmentsBiom($params) : null ;
        $return['parity'] = in_array($part, ["all", "parity"]) ? $this->getEstablishmentsParity($params) : null ;
        $return['partners'] = in_array($part, ["all", "partners"]) ? $this->getEstablishmentsPartner($params) : null ;
        $return['count'] = in_array($part, ["all", "count"]) ? $this->countEntity($params) : null;
        $return['employer'] = in_array($part, ["all", "employer"]) ? $this->getEstablishmentsEmployer($params) : null;
        return $return;
    }

    /**
     * @param $params
     * @param array $additionalWhere
     * @param callable|null $callback
     * @return mixed
     * @throws \App\Exception\DatabaseException
     */
    private function getEstablishmentListWithoutPartners($params)
    {
        $a129Name = Sql::makeI18nSelect('a129.name', $params, '');
        $a732Name = Sql::makeI18nSelect('a732.name', $params, '');

        $paramsWithoutId = $params;
        if (array_key_exists('establishment', $paramsWithoutId)) {
            unset($paramsWithoutId['establishment']);
        }
        $sql = "
   SELECT
       e.id,
       e.siret,
       e.usual_name,
       jsonb_build_array(e.meta->'lat',e.meta->'lng') coordinate,
       e.meta->'activity' as activity_code,
       e.sector_id,
       e.workforce_group,
       cast({$a129Name} as varchar(255)) || '. ' || cast({$a732Name} as varchar(255)) naf_description,   
       exists (select 1 
                from nomenclature_link_activity_rome nlar 
                where nlar.activity_naf_code = e.meta->'activity'
                AND %nlar%
               )  rome_chapter_exists
    FROM establishment e
        LEFT JOIN nomenclature_activity na ON e.main_activity_id = na.id
        LEFT JOIN util_nomenclature_naf_a732 a732
            INNER JOIN util_nomenclature_naf_a129 a129
            ON a129.id = a732.util_nomenclature_naf_a129_id
        ON a732.code = na.code
    WHERE
        %where%
;
";
        $statement = $this->bindWhereGlobal($paramsWithoutId, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }

        $out = array_map(
            static function ($establishment) {
                $establishment['coordinates'] = JSON::decode($establishment['coordinate']);
                return $establishment;
            },
            $results
        );

        $return['establishments'] = $out;
        $return['partners'] = [];
        return $return;
    }

    /**
     * Establishment partner (client and supplier)
     * @param int    $establishmentId
     * @return array
     * @throws \Exception
     */
    public function visualisationPartner(array $params, int $establishmentId): array
    {
        $a129Name = Sql::makeI18nSelect('a129.name', $params, '');
        $a732Name = Sql::makeI18nSelect('a732.name', $params, '');
        $npProduct = Sql::makeI18nSelect('nomenclature_product.name', $params, '');
        $sql = "
SELECT jsonb_build_array(e.meta->'lat', e.meta->'lng') coordinates,
       e.id,
       e.siret,
       e.usual_name,
       na.code activity_code,
       e.sector_id,
       e.workforce_group,
       e.description,
       e.phone_fix,
       e.phone_mobile,
       e.web_site,
       coalesce(a.way_number || ' ', '') || coalesce(a.way_type || ' ', '') || coalesce(way_label,'') as way,
       coalesce(a.complement) as complement,
       coalesce(c.zip_code || ' ', '') || coalesce(c.slug,'') as zip,
       cast({$a129Name} as varchar(255)) || '. ' || cast({$a732Name} as varchar(255)) naf_description,
       exists (select 1 
                from nomenclature_link_activity_rome nlar 
                where nlar.activity_naf_code = e.meta->'activity'
                AND %nlar%
               )  rome_chapter_exists,
	   (
			SELECT distinct Jsonb_agg(jsonb_build_object( 
				'id', nomenclature_product.id, 
				'code_hs4', nomenclature_product.code_hs4, 
				'sector_id', nomenclature_product.macro_sector_naf_id, 
				'name', {$npProduct},
			    'fake', product.fake))
			FROM product 
				inner join nomenclature_product
				on nomenclature_product.id = product.nomenclature_product_id
			where product.establishment_id = e.id	   
	   ) products               
FROM establishment e 
    LEFT JOIN address a ON e.address_id = a.id
    LEFT JOIN city c ON c.id = a.city_id
    INNER JOIN nomenclature_activity na ON e.main_activity_id = na.id
    LEFT JOIN util_nomenclature_naf_a732 a732
        INNER JOIN util_nomenclature_naf_a129 a129
        ON a129.id = a732.util_nomenclature_naf_a129_id
    ON a732.code = na.code
WHERE e.id = :establishmentId
        ";

        $paramWithoutGroup = $params;
        unset($paramWithoutGroup['workforce'], $paramWithoutGroup['sector'], $paramWithoutGroup['domain']);
        $statement = $this->bindWhereGlobal($paramWithoutGroup, false, false, $sql);
        $statement->bindParam(":establishmentId", $establishmentId, PDO::PARAM_INT);
        $statement->execute();
        if (false === $result = $statement->fetch(PDO::FETCH_ASSOC | PDO::FETCH_UNIQUE)) {
            throw new NotFoundHttpException();
        }
        $result['coordinates'] = Json::decode($result['coordinates']);
        $result['products'] = $result['products']?Json::decode($result['products']):[];
        $relations = $this->readRelation($paramWithoutGroup, $establishmentId);

        $result = array_merge($result, $relations);
        $params['establishment'] = $establishmentId;
        $result['count'] = $this->countEntity($params);

        $sql = "
select jsonb_build_object(
    'biom', biom,
    'C1', round((q2+q3) / (q1 * 1.0),2), 
    'C2', round((1.0 * q4/q1 ),2),
    'C3', round((1.0 * q5/q1),2),
    'C4', q6,
    'C5', round((1.0 * q7/q1),2),
    'C6', round(q8,2),
    'C7', q9,
    'C8', round(q10,2),
    'C9', Q11,
    'Q12', q12, 
    'Q13', q13) result
from biom
where biom.id = :establishmentId
        ";
        $statement = $statement = $this->databaseService->prepare($sql);
        $statement->bindParam(":establishmentId", $establishmentId, PDO::PARAM_INT);
        $statement->execute();
        if (false === $biom = $statement->fetch(PDO::FETCH_ASSOC | PDO::FETCH_UNIQUE)) {
            $result['biom'] = null ;
        } else {
            $result['biom'] = Json::decode($biom['result']);
        }

        $sql = "
with avg_e as (
	select avg(p.score) score
	from establishment e
		inner join parity p
		on p.id=e.id
	where 
	    %where%
),
avg_naf as (
	select avg(p.score) score
	 from establishment edep
		inner join establishment e
			inner join parity p
			on p.id=e.id
		on e.sector_id = edep.sector_id
		and %where%
	where edep.id = :establishmentId
)
select jsonb_build_object(
		'score', p.score, 
		'avg_e', (round(avg_e.score*100)/100)::numeric(5,2), 
		'avg_naf', (round(avg_naf.score*100)/100)::numeric(5,2)
	) result
from establishment e
    left join parity p on p.id=e.id
	cross join avg_e
	cross join avg_naf
where e.id = :establishmentId

        ";
        $paramWithoutEstablishment = $params;
        unset(
            $paramWithoutEstablishment['establishment'],
            $paramWithoutEstablishment['workforce'],
            $paramWithoutEstablishment['sector'],
            $paramWithoutEstablishment['domain']
        );
        $statement = $this->bindWhereGlobal($paramWithoutEstablishment, false, false, $sql);
        $statement->bindParam(":establishmentId", $establishmentId, PDO::PARAM_INT);
        $statement->execute();
        if (false === $parity = $statement->fetch(PDO::FETCH_ASSOC | PDO::FETCH_UNIQUE)) {
            $result['parity'] = null ;
        } else {
            $result['parity'] = Json::decode($parity['result']);
        }

        $sql = "
select jsonb_build_object(
	'resilience', resilience_index,
	'local_relief', local_relief_source,
	'agility', agility,
	'versatile_workforce', versatile_workforce,
	'supply_flexibility', supply_flexibility
	) result
from establishment_ri
where id=:id
        ";
        $statement = $statement = $this->databaseService->prepare($sql);
        $statement->bindParam(":id", $establishmentId, PDO::PARAM_INT);
        $statement->execute();
        if (false === $ri = $statement->fetch(PDO::FETCH_ASSOC | PDO::FETCH_UNIQUE)) {
            $result['ri'] = null ;
        } else {
            $result['ri'] = Json::decode($ri['result']);
        }

        return $result;
    }

    /**
     * Read supplier for specific establishment
     * @param int    $establishmentId
     * @return array
     */
    protected function readRelation(array $params, int $establishmentId): array
    {
        $a129Name = Sql::makeI18nSelect('a129.name', $params, '');
        $a732Name = Sql::makeI18nSelect('a732.name', $params, '');

        $sql = "
with rel as (
	select r.p_id partner_id, r.customer, r.provider, r.cust_coef, r.prov_coef, p.score, r.distance, false as alt_provider
	from func_list_partner_iot(:establishmentId) r 
	 	left join parity p on p.id=r.p_id
	UNION ALL
	select r.p_id partner_id, false customer, false provider, null cust_coef, r.coef prov_coef, p.score, r.distance, true as alt_provider
	from func_list_partner_alt(:establishmentId) r 
	 	left join parity p on p.id=r.p_id	 	
),        
relation as (
	select * from (select * from rel where alt_provider=false and cust_coef is not null order by cust_coef desc limit 100) un
	union
	select * from (select * from rel where alt_provider=false and prov_coef is not null order by prov_coef desc limit 100) deux
	union
	select * from (select * from rel where alt_provider=true) trois	
)
SELECT establishment.id,
       establishment.siret,
       establishment.usual_name,
       jsonb_build_array(establishment.meta->'lat', establishment.meta->'lng')  coordinates,
       establishment.sector_id,
       establishment.workforce_group,
       cast({$a129Name} as varchar(255)) || '. ' || cast({$a732Name} as varchar(255)) naf_description,
       exists (select 1 
                from nomenclature_link_activity_rome nlar 
                where nlar.activity_naf_code = establishment.meta->'activity'
                    AND %nlar%
               )  rome_chapter_exists,
	   relation.cust_coef,
	   relation.prov_coef,
	   relation.customer,
	   relation.provider,
	   relation.alt_provider,
	   relation.distance,
	   relation.score
FROM relation
    INNER JOIN establishment 
    ON relation.partner_id = establishment.id
    INNER JOIN nomenclature_activity na ON establishment.main_activity_id = na.id
    LEFT JOIN util_nomenclature_naf_a732 a732
        INNER JOIN util_nomenclature_naf_a129 a129
        ON a129.id = a732.util_nomenclature_naf_a129_id
    ON a732.code = na.code    
WHERE establishment.enabled = true 
and establishment.administrative_status = true        
        " ;
        $statement = $this->bindWhereGlobal($params, false, false, $sql);
        $statement->bindParam(":establishmentId", $establishmentId, PDO::PARAM_INT);
        $statement->execute();
        $relations = $statement->fetchAll(PDO::FETCH_ASSOC);
        return ['partner' => array_map(
            static function ($item) {
                $item['coordinates'] = Json::decode($item['coordinates']);
                $item['cust_coef'] = (float)$item['cust_coef'];
                $item['prov_coef'] = (float)$item['prov_coef'];
                return $item;
            },
            $relations
        )];
    }
}
