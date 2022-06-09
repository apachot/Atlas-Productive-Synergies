<?php


namespace App\Repository;

use App\Utility\Json;
use App\Utility\Sql;
use PDO;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

/**
 * Specific repository for product
 */
class ProductRepository extends EntityRepository
{

    public function findByHs4(array $params, string $hs4)
    {
        $sql = "
SELECT 
   e.id,
   e.siret,
   e.usual_name,
   jsonb_build_array(e.meta->'lat',e.meta->'lng') coordinates,
   e.meta->'activity' as activity_code,
   e.sector_id,
   e.workforce_group,
   exists (select 1 
                from nomenclature_link_activity_rome nlar 
                where nlar.activity_naf_code = e.meta->'activity'
                AND %nlar%
               )  rome_chapter_exists    
FROM establishment e
WHERE
    %where%
    AND exists(
        select 1 
        from product p
            INNER JOIN nomenclature_product np on p.nomenclature_product_id = np.id
        where p.establishment_id = e.id
        and np.code_hs4 = :hs4
        )

;
";
        $statement = $this->bindWhereGlobal($params, false, false, $sql);
        $statement->bindParam(":hs4", $hs4, PDO::PARAM_STR);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }

        $return['establishments'] = array_map(
            static function ($establishment) {
                $establishment['coordinates'] = Json::decode($establishment['coordinates']);
                return $establishment;
            },
            $results
        );

        $sql = "
With partners as (
	SELECT LEAST(e.id, e_dest.id) src_id, GREATEST(e.id, e_dest.id) dest_id
		, e.workforce_count+e_dest.workforce_count workforce_count
    FROM establishment e
        INNER JOIN IA_establishment_potential_partners r 
			INNER JOIN establishment e_dest on 
			e_dest.id = r.partner_id
		ON r.establishment_id = e.id  
		and r.partner_id<>e.id
    WHERE 
        %where%
    AND exists(
            select 1 
            from product p
                INNER JOIN nomenclature_product np on p.nomenclature_product_id = np.id
            where p.establishment_id = e.id
            and np.code_hs4 = :hs4
            )      
    AND exists(
            select 1 
            from product p
                INNER JOIN nomenclature_product np on p.nomenclature_product_id = np.id
            where p.establishment_id = e_dest.id
            and np.code_hs4 = :hs4
            )                
UNION
	SELECT LEAST(e.id, e_dest.id) src_id, GREATEST(e.id, e_dest.id) dest_id
	, e.workforce_count+e_dest.workforce_count
    FROM establishment e
        INNER JOIN IA_establishment_potential_partners r 
			INNER JOIN establishment e_dest on 
			e_dest.id = r.establishment_id
		ON r.partner_id = e.id  
		and r.establishment_id<>e.id
    WHERE 
        %where%
    AND exists(
            select 1 
            from product p
                INNER JOIN nomenclature_product np on p.nomenclature_product_id = np.id
            where p.establishment_id = e.id
            and np.code_hs4 = :hs4
            )      
    AND exists(
            select 1 
            from product p
                INNER JOIN nomenclature_product np on p.nomenclature_product_id = np.id
            where p.establishment_id = e_dest.id
            and np.code_hs4 = :hs4
            )             
)
select json_build_object(
	'src', jsonb_build_object(
			   'id', e_src.id, 'coordinates', 
			   jsonb_build_array(e_src.meta->'lat', e_src.meta->'lng'),
			   'sector_id', e_src.sector_id,
			   'workforce_group', e_src.workforce_group
		   ),
	'dest', jsonb_build_object(
			   'id', e_dest.id, 'coordinates', 
			   jsonb_build_array(e_dest.meta->'lat', e_dest.meta->'lng'),
			   'sector_id', e_dest.sector_id,
			   'workforce_group', e_dest.workforce_group
		   )
	) as partner
from partners p
	inner join establishment e_src ON e_src.id = p.src_id
	inner join establishment e_dest ON e_dest.id = p.dest_id
order by p.workforce_count desc
limit 1000
        " ;
        $statement = $this->bindWhereGlobal($params, false, true, $sql);
        $statement->bindParam(":hs4", $hs4, PDO::PARAM_STR);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }

        $return['partners'] = array_map(
            static function ($partner) {
                return Json::decode($partner['partner']) ;
            },
            $results
        );
        if (!array_key_exists('hs4', $params)) {
            $params['hs4'] = $hs4;
        }
        $return['count'] = $this->countEntity($params);

        return $return;
    }

    public function findProductsBySector($params): array
    {
        unset($params['hs4']);
        $sql = "
SELECT
   np.code_hs4, count(*) as value
FROM
  product p
      INNER JOIN nomenclature_product np on p.nomenclature_product_id = np.id
      INNER JOIN establishment e on p.establishment_id = e.id
WHERE
  %where%
GROUP BY np.code_hs4; 
        ";

        $statement = $this->bindWhereGlobal($params, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_KEY_PAIR)) {
            throw new NotFoundHttpException();
        }

        return $results;
    }

    public function findProductsBySectorWithValue($params): array
    {
        $paramsWithoutId = $params;
        if (array_key_exists('hs4', $paramsWithoutId)) {
            unset($paramsWithoutId['hs4']);
        }
        $sql = "
with product_filtered as (
SELECT
   	np.code_hs4, 
	count(*) as value
FROM product p
  	INNER JOIN nomenclature_product np on p.nomenclature_product_id = np.id
  	INNER JOIN establishment e on p.establishment_id = e.id
WHERE
	%where%
GROUP BY np.code_hs4	
)
SELECT distinct np.code_hs4, coalesce(pf.value,0) as value
FROM nomenclature_product np
	left join product_filtered pf
	on pf.code_hs4 = np.code_hs4
order by 1	        
        ";
        $statement = $this->bindWhereGlobal($paramsWithoutId, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }

        return [
            'data' => array_map(
                static function ($product) {
                    return ['id' => (string)$product["code_hs4"], 'value' => (float) $product["value"]];
                },
                $results
            ),
            'config' => [
                'min' => 0,
                'max' => (float)array_reduce(
                    $results,
                    static function ($carry, $item) {
                        if ($carry < $item["value"]) {
                            $carry = $item["value"];
                        }
                        return $carry;
                    },
                    0
                )
            ],
            'rca' => $this->findRCA($params),
            'made' => $this->findMadeProduct($params),
            'count' => $this->countEntity($params)
        ];
    }

    /**
     * Get a product By hs4 code
     *
     * @param array $params
     * @param string $hs4
     *
     * @return array
     */
    public function findOneByHs4(array $params, string $hs4): array
    {
        $npName = Sql::makeI18nSelect('np.name', $params, 'name');

        $sql = "
WITH tree as (
        SELECT np.id, 
            np.code_hs4, 
            np.macro_sector_naf_id as sector_id, 
            {$npName},
            exists (select 1 
					from nomenclature_product_proximity npp
					WHERE npp.main_product_code_hs4 = np.code_hs4
					AND npp.proximity > 0.6
				   ) as hasProximity
        FROM nomenclature_product np
        WHERE np.code_nc = :hs4 
    ),
    workforceGroup as (
        SELECT t.id, array_agg(distinct e.workforce_group) as workforce_group
        FROM tree t
            INNER JOIN nomenclature_product np ON np.code_hs4 = t.code_hs4 
            INNER JOIN product p ON p.nomenclature_product_id = np.id
            INNER JOIN establishment e ON p.establishment_id = e.id
        where 
            %where%
        group by t.id		
    )
SELECT t.id, t.code_hs4, t.sector_id, t.name, wg.workforce_group, t.hasProximity
FROM tree t
    LEFT JOIN workforceGroup wg ON wg.id = t.id      
        " ;

        $statement = $this->bindWhereGlobal($params, false, false, $sql);
        $statement->setFetchMode(PDO::FETCH_ASSOC);
        $statement->bindParam(":hs4", $hs4, PDO::PARAM_STR);
        $statement->execute();
        if (false === $product = $statement->fetch()) {
            throw new NotFoundHttpException();
        }

        $product['workforce_group'] =
            $product['workforce_group'] === null ?
                [] :
                explode(',', trim($product['workforce_group'], '{}'));
        return $product;
    }

    /**
     * Find products related to a hs4 code, first and second level.
     *
     * @param string $hs4
     * @param float  $proximity
     *
     * @return array
     */
    protected function findProximities($params, string $hs4): array
    {
        $npName = Sql::makeI18nSelect('np.name', $params, 'name');

        $sql = "
WITH tree as (
        select np.id,
               np.code_hs4,
               np.macro_sector_naf_id,
               {$npName},
               vw.proximity,
               vw.hs4_start parent,
               vw.lvl
        from vw_proximity_123 vw
            inner join nomenclature_product np ON np.code_nc = vw.hs4_dest
        where vw.hs4 = :hs4
        and np.macro_sector_naf_id is not null
    ),
    agregate as (
        SELECT tree.id, tree.code_hs4, tree.macro_sector_naf_id, tree.name, min(tree.lvl) as lvl,
            cast(sum(tree.proximity)/count(*) as numeric(7,6)) as proximity, 
            array_agg(distinct tree.parent) as parents, 
            sum(case when tree.lvl=1 then tree.proximity else NULL end) as proximity_lvl1 
        FROM tree
        WHERE tree.code_hs4 <> :hs4 
        GROUP BY tree.id, tree.code_hs4, tree.macro_sector_naf_id, tree.name),
    workforceGroup as (
        select agregate.id, array_agg(distinct e.workforce_group) as workforce_group
        from agregate 
            inner join nomenclature_product np on np.code_hs4 = agregate.code_hs4
            inner join product p on p.nomenclature_product_id = np.id
            inner join establishment e on p.establishment_id = e.id
        where 
            %where%
        group by agregate.id
    ),
    linkLvl1 as (
        select t1.id,  array_agg(distinct t2.code_hs4) proximity_lvl1
        from tree t1
            left join tree t2 on (t1.code_hs4 = t2.parent or t2.code_hs4 = t1.parent) 
        where exists (select 1 from tree t3 where t3.code_hs4=t2.code_hs4 and t3.lvl<3)
        group by t1.id
        order by 1		
    )    
    SELECT 
        ag.id, 
        ag.code_hs4, 
        ag.macro_sector_naf_id macro_sector_id, 
        ag.name, 
        ag.lvl as level, 
        ag.parents, 
        case when ag.lvl=1 then ag.proximity_lvl1 else ag.proximity end as proximity, 
        wg.workforce_group,
        lk.proximity_lvl1,
		coalesce(rbn.maslow_norm,0) maslow_norm,
		coalesce(rpr.resilience_norm,0) resilience_norm,
		coalesce(rgp.green_norm,0) green_norm,
		coalesce(reg.pci_norm,0) pci_norm,
		coalesce(case when max(rca.rca) over (partition by 1) - min(rca.rca) over (partition by 1) = 0 then 1
			else (rca.rca - min(rca.rca) over (partition by 1)) / (max(rca.rca) over (partition by 1) - min(rca.rca) over (partition by 1))
		end,0) advantage_norm
    FROM agregate ag 
        left join workforceGroup wg on wg.id = ag.id
        left join linkLvl1 lk on lk.id = ag.id
		left join rank_basic_necessities rbn on rbn.hs4 = ag.code_hs4
		left join rank_productive_resilience rpr on rpr.hs4 = ag.code_hs4
		left join rank_green_production rgp on rgp.hs4 = ag.code_hs4
		left join rank_economic_growth reg on reg.hs4 = ag.code_hs4
		%rca%        
    ORDER BY level, proximity DESC;
" ;
        $rca = "";
        if (array_key_exists("region", $params)) {
            if (strtoupper($params["region"]) !== "ALL") {
                $rca = "left join vw_rca_by_reg rca on rca.region in ('".$params["region"]."') and rca.annee=2020 and rca.hs4=ag.code_hs4 ";
            } else {
                $rca = "left join vw_rca rca on rca.hs4=ag.code_hs4 " ;
            }
        } elseif (array_key_exists("industry_territory", $params)) {
            $rca = "left join vw_rca_by_it rca on rca.it='".$params["industry_territory"]."'  and rca.annee=2020 and rca.hs4= ag.code_hs4 " ;
        } elseif (array_key_exists("epci", $params)) {
            $rca = "left join epci 
                        inner join vw_rca_by_dep rca 
                        on rca.annee=2020 
                        and rca.departement = case epci.dep_epci when '2A' then '20' when '2B' then '20' else epci.dep_epci end 
                    on siren_epci = '".$params["epci"]."' and rca.hs4=ag.code_hs4  " ;
        }
        $sql = str_replace('%rca%', $rca, $sql);
        $statement = $this->bindWhereGlobal($params, false, false, $sql);
        $statement->setFetchMode(PDO::FETCH_ASSOC);
        $statement->bindParam(":hs4", $hs4, PDO::PARAM_STR);
        $statement->execute();
        if (false === $closeness = $statement->fetchAll()) {
            throw new NotFoundHttpException();
        }
        return $closeness;
    }

    /**
     * Find kinship products related to a hs4 code, first and second level.
     *
     * @param $params
     * @param string $hs4
     *
     * @return array
     */
    protected function findKinship($params, string $hs4): array
    {
        $npName = Sql::makeI18nSelect('np.name', $params, 'name');

        $sql = "
WITH RECURSIVE   
    tree as (
        SELECT np.id, 
                np.code_hs4, 
                np.macro_sector_naf_id, 
                {$npName}, 
                ps.proximity, 
                ps.source as parent, 
                ps.target, 1 as lvl
        FROM product_space ps
            LEFT JOIN nomenclature_product np ON ps.target = np.code_nc
        WHERE ps.source = :hs4
        and np.macro_sector_naf_id is not null
    UNION ALL
      SELECT np.id, 
                np.code_hs4, 
                np.macro_sector_naf_id, 
                {$npName}, 
                cast(ps.proximity * tree.proximity as numeric(7,6)), 
                tree.code_hs4, 
                ps.target, 
                tree.lvl+1 as lvl
      FROM tree
        INNER JOIN product_space ps ON tree.code_hs4 = ps.source
        INNER JOIN nomenclature_product np ON ps.target = np.code_nc
      WHERE tree.lvl < 2
      and np.macro_sector_naf_id is not null
    ),
    agregate as (
        SELECT tree.id, tree.code_hs4, tree.macro_sector_naf_id, tree.name, min(tree.lvl) as lvl,
            CAST(sum(tree.proximity)/count(*) as numeric(11,10)) as strength,
            array_agg(distinct tree.parent) as parents,
            sum(case when tree.lvl=1 then tree.proximity else NULL end) as strength_lvl1 
        FROM tree
        WHERE tree.code_hs4 <> :hs4
        GROUP BY tree.id, tree.code_hs4, tree.macro_sector_naf_id, tree.name),
    workforceGroup as (
        SELECT agregate.id, array_agg(distinct e.workforce_group) as workforce_group
        FROM agregate 
            INNER JOIN nomenclature_product np ON np.code_hs4 = agregate.code_hs4
            INNER JOIN product p ON p.nomenclature_product_id = np.id
            INNER JOIN establishment e ON p.establishment_id = e.id
        WHERE 
            %where%
        GROUP BY agregate.id
    )
    SELECT ag.id, ag.code_hs4, ag.macro_sector_naf_id macro_sector_id, ag.name, ag.lvl as level, ag.parents, 
            case when ag.lvl=1 then ag.strength_lvl1 else ag.strength end as proximity, wg.workforce_group
    FROM agregate ag 
        LEFT JOIN workforceGroup wg on wg.id = ag.id
    ORDER BY level, proximity desc;
" ;

        $statement = $this->bindWhereGlobal($params, false, false, $sql);
        $statement->setFetchMode(PDO::FETCH_ASSOC);
        $statement->bindParam(":hs4", $hs4, PDO::PARAM_STR);
        $statement->execute();
        if (false === $kinship = $statement->fetchAll()) {
            throw new NotFoundHttpException();
        }

        return $kinship;
    }

    public function findMadeProduct($params): array
    {
        $bind = [];
        $where = "";
        if (array_key_exists("sector", $params)) {
            $sectors = is_string($params["sector"]) ?
                preg_split('/,/', $params["sector"], -1, PREG_SPLIT_NO_EMPTY) :
                $params["sector"]
            ;
            $count = count($sectors);
            if ($count < 19) {

                $part = $this->createBindPartForIn($sectors, $bind, "sector", PDO::PARAM_STR) ;
                if ($part === '') {
                    $part = "9999";
                }
                $where = "and nph.sector_id IN (" . $part . ")";
            }
        }
        if (array_key_exists("industry_territory", $params)) {
            $nameSelect = Sql::makeI18nSelect('nph.name', $params);
            $sql = "
select nph.id, 
		nph.code_hs4, 
		nph.sector_id, 
		{$nameSelect}
		, ehh.exportation
from vw_export_harvard_it_hs4 ehh
	inner join vw_nomenclature_product_harvard nph
		on nph.code_hs4 = ehh.hs4 
		   and nph.is_harvard = true
where ehh.it = :it
and ehh.annee = 2019
{$where}
order by ehh.exportation desc	
limit 10;
            ";
            $bind["it"] = ['v' => $params["industry_territory"], 'p' => PDO::PARAM_STR];
        } elseif (array_key_exists("region", $params)) {
            $nameSelect = Sql::makeI18nSelect('nph.name', $params);
            $sql = "
select nph.id, 
		nph.code_hs4, 
		nph.sector_id, 
		{$nameSelect}
		, ehh.exportation
from vw_export_harvard_reg_hs4 ehh
	inner join vw_nomenclature_product_harvard nph
		on nph.code_hs4 = ehh.hs4 
		   and nph.is_harvard = true
where ehh.region = :region
and ehh.annee = 2019
{$where}
order by ehh.exportation desc	
limit 10;
            ";
            $bind["region"] = ['v' => $params["region"], 'p' => PDO::PARAM_STR];
        } elseif (array_key_exists("epci", $params)) {
            $nameSelect = Sql::makeI18nSelect('nph.name', $params);
            $sql = "
select nph.id, 
		nph.code_hs4, 
		nph.sector_id, 
		{$nameSelect}
		, ehh.exportation
from epci
	inner join vw_export_harvard_dep_hs4 ehh
    on ehh.dep = case when epci.dep_epci = '2A' or epci.dep_epci = '2B' THEN '20' else epci.dep_epci end
	inner join vw_nomenclature_product_harvard nph
		on nph.code_hs4 = ehh.hs4 
		   and nph.is_harvard = true
where epci.siren_epci = :epci
and ehh.annee = 2019
{$where}
order by ehh.exportation desc	
limit 10;
            ";
            $bind["epci"] = ['v' => $params["epci"], 'p' => PDO::PARAM_STR];
        } else {
            return [];
        }
        $statement = $this->databaseService->prepare($sql);
        $statement->setFetchMode(PDO::FETCH_ASSOC);
        foreach ($bind as $key => $value) {
            $statement->bindParam(":{$key}", $value['v'], $value['p']);
        }
        $statement->execute();
        if (false === $out = $statement->fetchAll()) {
            throw new NotFoundHttpException();
        }
        return $out;
    }

    /**
     * @param $params
     * @return array
     */
    public function findRCA($params): array
    {
        $bind = [];
        $where = "";
        if (array_key_exists("sector", $params)) {
            $sectors = is_string($params["sector"]) ?
                preg_split('/,/', $params["sector"], -1, PREG_SPLIT_NO_EMPTY) :
                $params["sector"]
            ;
            $count = count($sectors);
            if ($count < 19) {

                $part = $this->createBindPartForIn($sectors, $bind, "sector", PDO::PARAM_STR) ;
                if ($part === '') {
                    $part = "9999";
                }
                $where = "and nph.sector_id IN (" . $part . ")";
            }
        }

        if (array_key_exists("industry_territory", $params)) {
            $nameSelect = Sql::makeI18nSelect('nph.name', $params);
            $sql = "
select nph.id, 
		nph.code_hs4, 
		nph.sector_id, 
		{$nameSelect}
		, round(rca.rca,4) as rca
from vw_rca_by_it rca 
	inner join vw_nomenclature_product_harvard nph
	on nph.code_hs4 = rca.hs4 
	   and nph.is_harvard = true
where rca.it = :it
and rca.annee = 2019
{$where}
order by rca desc
limit 10;            
            ";
            $bind["it"] = ['v' => $params["industry_territory"], 'p' => PDO::PARAM_STR];
        } elseif (array_key_exists("region", $params)) {
            $nameSelect = Sql::makeI18nSelect('nph.name', $params);
            $sql = "
select nph.id, 
		nph.code_hs4, 
		nph.sector_id, 
		{$nameSelect}
		, round(rca.rca,4) as rca
from vw_rca_by_reg rca 
	inner join vw_nomenclature_product_harvard nph
	on nph.code_hs4 = rca.hs4
	   and nph.is_harvard = true
where rca.region = :region
and rca.annee = 2019
{$where}
order by rca desc
limit 10;
            ";
            $bind["region"] = ['v' => $params["region"], 'p' => PDO::PARAM_STR];
        } elseif (array_key_exists("epci", $params)) {
            $nameSelect = Sql::makeI18nSelect('nph.name', $params);
            $sql = "
select nph.id, 
		nph.code_hs4, 
		nph.sector_id, 
		{$nameSelect}
		, round(rca.rca,4) as rca
from epci
	inner join vw_rca_by_dep rca 
	on rca.departement = case when epci.dep_epci = '2A' or epci.dep_epci = '2B' THEN '20' else epci.dep_epci end
	inner join vw_nomenclature_product_harvard nph
	on nph.code_hs4 = rca.hs4
	   and nph.is_harvard = true
where epci.siren_epci = :epci
and rca.annee = 2019
{$where}
order by rca desc
limit 10;
            ";
            $bind["epci"] = ['v' => $params["epci"], 'p' => PDO::PARAM_STR];
        } else {
            return [];
        }

        $statement = $this->databaseService->prepare($sql);
        $statement->setFetchMode(PDO::FETCH_ASSOC);
        foreach ($bind as $key => $value) {
            $statement->bindParam(":{$key}", $value['v'], $value['p']);
        }
        $statement->execute();
        if (false === $out = $statement->fetchAll()) {
            throw new NotFoundHttpException();
        }
        return $out;
    }

    /**
     * @param string $hs4
     * @param bool $byProximity
     * @param array $params
     * @return array
     * @throws \JsonException
     */
    public function findProductAndNearLvl(string $hs4, bool $byProximity, array $params): array
    {
        $paramWithoutGroup = $params;
        unset(
            $paramWithoutGroup['workforce'],
            $paramWithoutGroup['sector'],
            $paramWithoutGroup['domain'],
            $paramWithoutGroup['hs4']
        );
        $product = $this->findOneByHs4($params, $hs4);

        $relations = [];
        $closeness = [];
        $hs4s = [$hs4];

        // get number of product on location
        $densities = $this->findProductsBySector($paramWithoutGroup);

        // Get proximity of level 1 and 2
        foreach (
            (
            $byProximity ?
                $this->findProximities($paramWithoutGroup, $hs4) :
                $this->findKinship($paramWithoutGroup, $hs4)
            ) as $px
        ) {
            $proximity = $px;
            $relations[] = [$hs4, $px['code_hs4']];
            $hs4s[] = $hs4;
            $proximity['value'] = $densities[$px['code_hs4']] ?? 0;
            $proximity['parents'] = explode(',', trim($px['parents'], '{}'));
            $proximity['workforce_group'] =
                $px['workforce_group'] === null ?
                    [] :
                    explode(',', trim($px['workforce_group'], '{}'));
            $proximity['proximity'] = (float) $proximity['proximity'];
            foreach ($proximity['parents'] as $parent) {
                $relations[] = [$px['code_hs4'], $parent];
                $hs4s[] = $px['code_hs4'];
            }
            if ($byProximity) {
                $proximity['proximity_lvl1'] = explode(',', trim($px['proximity_lvl1'], '{}'));
                $proximity['maslow_norm'] = (float)$proximity['maslow_norm'] ;
                $proximity['resilience_norm'] = (float)$proximity['resilience_norm'] ;
                $proximity['green_norm'] = (float)$proximity['green_norm'] ;
                $proximity['pci_norm'] = (float)$proximity['pci_norm'] ;
                $proximity['advantage_norm'] = (float)$proximity['advantage_norm'] ;
            }
            $closeness[] = $proximity;
        }
        $product['value'] = $densities[$hs4] ?? 0;
        $params['hs4'] = $hs4;
        return [
            'product' => $product,
            'proximities' => $closeness,
            'relations' => $relations,
            'count' => $this->countEntity($params),
            'hs4s' => $hs4s
        ];
    }

    /**
     * @param array $params
     * @return array
     */
    public function findProductsExportation(array $params): array
    {
        $view = "vw_export_harvard_reg_hs4 hh inner join region n on n.code = hh.region" ;
        $name = Sql::makeI18nSelect('n.name', $params, 'nom');
        $and = "";
        if (array_key_exists("region", $params)) {
            if (strtoupper($params["region"]) !== "ALL") {
                $and = "and region = :region";
            } else {
                $view = "vw_export_harvard_reg_hs4 hh";
                $name = "'France' nom";
            }
        } elseif (array_key_exists("industry_territory", $params)) {
            $view = "vw_export_harvard_it_hs4 hh inner join industry_territory n on n.national_identifying = hh.it" ;
            $and = "and it = :it";
        } else {
            return [] ;
        }

        $msnName = Sql::makeI18nSelect('msn.name', $params, 'nom');
        $chapName = Sql::makeI18nSelect('chap.libelle', $params, 'chap_nom');
        $nphName = Sql::makeI18nSelect('nph.name', $params, 'hs4_nom');
        $sql = "
with s as (
		select sector_id, color, {$msnName}
	from (values 
		  (1, '#8ABF4F'), (2, '#FFDC50'), (3, '#DDC4DF'), (4, '#F6A961'), (5, '#E2AC7D'), (6, '#F5B2AB'), 
		  (7, '#EA8286'), (8, '#D1E5CA'), (9, '#E4CAB4'), (10, '#B8CFD1'), (11, '#CEEAFB'), (12, '#83C5A3'), 
		  (13, '#00A99D'), (14, '#A3A33A'), (15, '#FFA4D8'), (16, '#7DC8CF'), (17, '#42CFF4'), (18, '#F5B2AB'), 
		  (19, '#1F8DC1')
		 ) t(sector_id, color)
		inner join macro_secteur_naf msn on msn.id = t.sector_id
)
select distinct nph.sector_id secteur_id, s.color secteur_color, s.nom secteur_nom,
		chap.id chap_id, {$chapName},
		hs4, {$nphName}, 
		sum(exportation) over (partition by nph.sector_id) secteur_size,
		sum(exportation) over (partition by nph.sector_id, chap.id) chap_size,
		sum(exportation) over (partition by nph.sector_id, chap.id, hs4) hs4_size,
		round(
            case when (sum(exportation) over (partition by annee))>0 THEN
                (sum(exportation) over (partition by nph.sector_id)) / 
                (sum(exportation) over (partition by annee)) * 100 ELSE 0 END 
            , 2) secteur_pcent,
        round(
            CASE WHEN (sum(exportation) over (partition by annee))>0 THEN
                (sum(exportation) over (partition by nph.sector_id, chap.id)) / 
                (sum(exportation) over (partition by annee)) * 100 ELSE 0 END 
            , 2) chap_pcent,
		round(
            CASE WHEN (sum(exportation) over (partition by annee))>0 THEN
                (sum(exportation) over (partition by nph.sector_id, chap.id, hs4)) / 
                (sum(exportation) over (partition by annee)) * 100 ELSE 0 END 
            , 2) hs4_pcent,
		$name
from $view 
	inner join vw_nomenclature_product_harvard nph on nph.code_hs4 = hh.hs4 
	inner join util_nomenclature_nc2020_lvl1 lvl1 on lvl1.code = hh.hs4
	inner join util_nomenclature_nc2020_chapter chap ON chap.id = lvl1.util_nomenclature_nc2020_chapter_id
	inner join s on s.sector_id = nph.sector_id
where annee = 2019 and exportation>0
$and
order by secteur_size desc, chap_size desc, hs4_size desc
            ";
        $statement = $this->databaseService->prepare($sql);
        if (array_key_exists("region", $params)) {
            if (strtoupper($params["region"]) !== "ALL") {
                $statement->bindParam(":region", $params["region"], PDO::PARAM_STR);
                $id = $params["region"];
            } else {
                $id = 'ALL';
            }
        } elseif (array_key_exists("industry_territory", $params)) {
            $statement->bindParam(":it", $params["industry_territory"], PDO::PARAM_STR);
            $id = $params["industry_territory"];
        }
        $statement->execute();
        if (false === $out = $statement->fetchAll()) {
            throw new NotFoundHttpException();
        }

        $result = array() ;
        $lastSector  = -1;
        $lastChapter = -1 ;
        $autreSector = array(
            'id' => '9999',
            'color' => '#050505',
            'nom' => 'Moins de 0.05%',
            'size' => 0,
            'level' => 1
        ) ;
        foreach ($out as $value) {
            if ((float)$value['hs4_pcent'] <= 0.05) {
                $autreSector["size"] += (float)$value['hs4_size'] ;
            } else {
                $hs4 = array(
                    'id' => $value['hs4'],
                    'nom' => $value['hs4_nom'],
                    'size' => (float)$value['hs4_size'],
                    'pcent' => (float)$value['hs4_pcent'],
                    'color' => $value['secteur_color'],
                    'level' => 3
                );
                if ($value['secteur_id'] !== $lastSector) {
                    $chapter = array(
                        'id' => $value['chap_id'],
                        'nom' => $value['chap_nom'],
                        'color' => $value['secteur_color'],
                        // 'size' => (float)$value['chap_size'],
                        'pcent' => (float)$value['chap_pcent'],
                        'children' => array($hs4),
                        'level' => 2
                    );
                    $sector = array(
                        'id' => $value['secteur_id'],
                        'color' => $value['secteur_color'],
                        'nom' => $value['secteur_nom'],
                        //'size' => (float)$value['secteur_size'],
                        'pcent' => (float)$value['secteur_pcent'],
                        'children' => array($chapter),
                        'level' => 1
                    );
                    $result[] = $sector;
                    $lastSector = $value['secteur_id'];
                    $lastChapter = $value['chap_id'];
                } elseif ($value['chap_id'] !== $lastChapter) {
                    $sector_pass = &$result[count($result) - 1]['children'];
                    $chapter = array(
                        'id' => $value['chap_id'],
                        'nom' => $value['chap_nom'],
                        'color' => $value['secteur_color'],
                        //'size' => (float)$value['chap_size'],
                        'pcent' => (float)$value['chap_pcent'],
                        'children' => array($hs4),
                        'level' => 2
                    );
                    $sector_pass[] = $chapter;
                    $lastChapter = $value['chap_id'];
                } else {
                    $sector_pass = &$result[count($result) - 1]['children'];
                    $chapter_pass = &$sector_pass[count($sector_pass) - 1]['children'];
                    $chapter_pass[] = $hs4;
                }
            }
        }
        /*
        if ($autreSector["size"] > 0) {
            array_push($result, $autreSector);
        }
        */
        $out = [
            'id' => $id,
            'nom' => $out[0]["nom"],
            'children' => $result,
            'color' => '#F0F0F0',
            'level' => 0
        ];
        return $out;
    }

    public function findProductsImportation (array $params): array
    {
        $view = "vw_import_harvard_reg_hs4 hh inner join region n on n.code = hh.region" ;
        $name = Sql::makeI18nSelect('n.name', $params, 'nom');
        $and = "";
        if (array_key_exists("region", $params)) {
            if (strtoupper($params["region"]) !== "ALL") {
                $and = "and region = :region";
            } else {
                $name = "'France' nom";
                $view = "vw_import_harvard_reg_hs4 hh" ;
            }
        } elseif (array_key_exists("industry_territory", $params)) {
            $view = "vw_import_harvard_it_hs4 hh inner join industry_territory n on n.national_identifying = hh.it" ;
            $and = "and it = :it";
        } else {
            return [] ;
        }
        $msnName = Sql::makeI18nSelect('msn.name', $params, 'nom');
        $chapName = Sql::makeI18nSelect('chap.libelle', $params, 'chap_nom');
        $nphName = Sql::makeI18nSelect('nph.name', $params, 'hs4_nom');

        $sql = "
with s as (
		select sector_id, color, {$msnName}
	from (values 
		  (1, '#8ABF4F'), (2, '#FFDC50'), (3, '#DDC4DF'), (4, '#F6A961'), (5, '#E2AC7D'), (6, '#F5B2AB'), 
		  (7, '#EA8286'), (8, '#D1E5CA'), (9, '#E4CAB4'), (10, '#B8CFD1'), (11, '#CEEAFB'), (12, '#83C5A3'), 
		  (13, '#00A99D'), (14, '#A3A33A'), (15, '#FFA4D8'), (16, '#7DC8CF'), (17, '#42CFF4'), (18, '#F5B2AB'), 
		  (19, '#1F8DC1')
		 ) t(sector_id, color)
		inner join macro_secteur_naf msn on msn.id = t.sector_id
)
select distinct nph.sector_id secteur_id, s.color secteur_color, s.nom secteur_nom,
		chap.id chap_id, {$chapName},
		hs4, {$nphName}, 
		sum(importation) over (partition by nph.sector_id) secteur_size,
		sum(importation) over (partition by nph.sector_id, chap.id) chap_size,
		sum(importation) over (partition by nph.sector_id, chap.id, hs4) hs4_size,
		round(
            case when (sum(importation) over (partition by annee))>0 THEN
                (sum(importation) over (partition by nph.sector_id)) / 
                (sum(importation) over (partition by annee)) * 100 ELSE 0 END 
            , 2) secteur_pcent,
        round(
            CASE WHEN (sum(importation) over (partition by annee))>0 THEN
                (sum(importation) over (partition by nph.sector_id, chap.id)) / 
                (sum(importation) over (partition by annee)) * 100 ELSE 0 END 
            , 2) chap_pcent,
		round(
            CASE WHEN (sum(importation) over (partition by annee))>0 THEN
                (sum(importation) over (partition by nph.sector_id, chap.id, hs4)) / 
                (sum(importation) over (partition by annee)) * 100 ELSE 0 END 
            , 2) hs4_pcent,
		$name
from $view 
	inner join vw_nomenclature_product_harvard nph on nph.code_hs4 = hh.hs4 
	inner join util_nomenclature_nc2020_lvl1 lvl1 on lvl1.code = hh.hs4
	inner join util_nomenclature_nc2020_chapter chap ON chap.id = lvl1.util_nomenclature_nc2020_chapter_id
	inner join s on s.sector_id = nph.sector_id
where annee = 2019 and importation>0
$and
order by secteur_size desc, chap_size desc, hs4_size desc
            ";
        $statement = $this->databaseService->prepare($sql);
        if (array_key_exists("region", $params)) {
            if (strtoupper($params["region"]) !== "ALL") {
                $statement->bindParam(":region", $params["region"], PDO::PARAM_STR);
                $id = $params["region"];
            } else {
                $id = 'ALL';
            }
        } elseif (array_key_exists("industry_territory", $params)) {
            $statement->bindParam(":it", $params["industry_territory"], PDO::PARAM_STR);
            $id = $params["industry_territory"];
        }
        $statement->execute();
        if (false === $out = $statement->fetchAll()) {
            throw new NotFoundHttpException();
        }

        $result = array() ;
        $lastSector  = -1;
        $lastChapter = -1 ;
        $autreSector = array(
            'id' => '9999',
            'color' => '#050505',
            'nom' => 'Moins de 0.05%',
            'size' => 0,
            'level' => 1
        ) ;
        foreach ($out as $value) {
            if ((float)$value['hs4_pcent'] <= 0.05) {
                $autreSector["size"] += (float)$value['hs4_size'] ;
            } else {
                $hs4 = array(
                    'id' => $value['hs4'],
                    'nom' => $value['hs4_nom'],
                    'size' => (float)$value['hs4_size'],
                    'pcent' => (float)$value['hs4_pcent'],
                    'color' => $value['secteur_color'],
                    'level' => 3
                );
                if ($value['secteur_id'] !== $lastSector) {
                    $chapter = array(
                        'id' => $value['chap_id'],
                        'nom' => $value['chap_nom'],
                        'color' => $value['secteur_color'],
                        // 'size' => (float)$value['chap_size'],
                        'pcent' => (float)$value['chap_pcent'],
                        'children' => array($hs4),
                        'level' => 2
                    );
                    $sector = array(
                        'id' => $value['secteur_id'],
                        'color' => $value['secteur_color'],
                        'nom' => $value['secteur_nom'],
                        //'size' => (float)$value['secteur_size'],
                        'pcent' => (float)$value['secteur_pcent'],
                        'children' => array($chapter),
                        'level' => 1
                    );
                    $result[] = $sector;
                    $lastSector = $value['secteur_id'];
                    $lastChapter = $value['chap_id'];
                } elseif ($value['chap_id'] !== $lastChapter) {
                    $sector_pass = &$result[count($result) - 1]['children'];
                    $chapter = array(
                        'id' => $value['chap_id'],
                        'nom' => $value['chap_nom'],
                        'color' => $value['secteur_color'],
                        //'size' => (float)$value['chap_size'],
                        'pcent' => (float)$value['chap_pcent'],
                        'children' => array($hs4),
                        'level' => 2
                    );
                    $sector_pass[] = $chapter;
                    $lastChapter = $value['chap_id'];
                } else {
                    $sector_pass = &$result[count($result) - 1]['children'];
                    $chapter_pass = &$sector_pass[count($sector_pass) - 1]['children'];
                    $chapter_pass[] = $hs4;
                }
            }
        }
        /*
        if ($autreSector["size"] > 0) {
            array_push($result, $autreSector);
        }
        */
        $out = [
            'id' => $id,
            'nom' => $out[0]["nom"],
            'children' => $result,
            'color' => '#F0F0F0',
            'level' => 0
        ];
        return $out;
    }
}
