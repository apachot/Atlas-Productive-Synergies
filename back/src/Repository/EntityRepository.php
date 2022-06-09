<?php


namespace App\Repository;

use App\Entity\AbstractEntity;
use App\Service\DatabaseService;
use App\Utility\Json;
use PDO;
use RuntimeException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

/**
 * Generic repository.
 * Specific repository must be inherit from him
 */
class EntityRepository
{
    protected DatabaseService $databaseService;
    protected string $entityName;

    public function findOneById(int $id): ?AbstractEntity
    {
        if (null === $this->entityName) {
            throw new RuntimeException("Entity name must not be null");
        }

        $sql = "SELECT * FROM  {$this->entityName} WHERE id = :id";

        $statement = $this->databaseService->prepare($sql);
        $statement->setFetchMode(PDO::FETCH_ASSOC);
        $statement->bindParam(":id", $id);
        $statement->execute();
        if (false === $data = $statement->fetch()) {
            return null;
        }

        return $this->databaseService->createEntity($this->entityName, $data);
    }

    protected function createBindPartForIn(array $in, array &$bind, string $frag, int $pdoParam): string
    {
        $part = "";
        foreach ($in as $key => $value) {
            $part .= ":{$frag}_{$key}," ;
            if (!array_key_exists("{$frag}_{$key}", $bind)) {
                $bind["{$frag}_{$key}"] = ['v' => $value, 'p' => $pdoParam];
            }
        }
        if ($part === '') {
            return '';
        }
        return substr($part, 0, -1) ;
    }

    protected function bindWhereGlobal(array $params, bool $forCount, bool $withDest, string $sql, bool $debug = false)
    {
        $withDomain = strpos($sql, '%nlar%') !== false;
        $withHs4 = strpos($sql, '%hs4%') !== false;
        $withWhere = strpos($sql, '%where%') !== false;
        $where = [];
        $bind = [];
        // skip missing data
        $where[] = "e.enabled = true";
        // skip closed establishment
        $where[] = "e.administrative_status = true";

        if ($withDest) {
            // skip missing data
            $where[] = "e_dest.enabled = true";
            // skip closed establishment
            $where[] = "e_dest.administrative_status = true";
        }

        if ($withWhere && array_key_exists("region", $params)) {
            if (strtoupper($params["region"]) !== "ALL") {
                $departments = $this->databaseService->getDepartmentsForRegion($params["region"]);
                $part = $this->createBindPartForIn($departments, $bind, "region", PDO::PARAM_STR);
                $where[] = "e.department_code IN (" . $part . ")";
                if ($withDest) {
                    $where[] = "e_dest.department_code IN (" . $part . ")";
                }
            } else {
                $where[] = "e.department_code ~ '^[0-9]{2}$|^2[AB]$' ";
                if ($withDest) {
                    $where[] = "e_dest.department_code ~ '^[0-9]{2}$|^2[AB]$' ";
                }
            }
        } elseif ($withWhere && array_key_exists("department", $params)) {
            $part = $this->createBindPartForIn(
                preg_split('/,/', $params["department"], -1, PREG_SPLIT_NO_EMPTY),
                $bind,
                "department",
                PDO::PARAM_STR) ;
            $where[] = "e.department_code IN (" . $part . ")";
            if ($withDest) {
                $where[] = "e_dest.department_code IN (" . $part . ")";
            }
        } elseif ($withWhere && array_key_exists("industry_territory", $params)) {
            $bind['tis'] = ['v' => $params["industry_territory"], 'p' => PDO::PARAM_STR];
            $where[] = "e.it_code = :tis" ;
            if ($withDest) {
                $where[] = "e_dest.it_code = :tis" ;
            }
        } elseif ($withWhere && array_key_exists("epci", $params)) {
            $bind['epci'] = ['v' => $params["epci"], 'p' => PDO::PARAM_STR];
            $where[] = "e.epci_code = :epci" ;
            if ($withDest) {
                $where[] = "e_dest.epci_code = :epci" ;
            }
        } elseif ($withWhere && !array_key_exists("establishment", $params)) {
            $where[] = "e.department_code = '63'";
            if ($withDest) {
                $where[] = "e_dest.department_code = '63'";
            }
        }

        if ($withWhere && array_key_exists("workforce", $params)) {
            $part = $this->createBindPartForIn(
                preg_split('/,/', $params["workforce"], -1, PREG_SPLIT_NO_EMPTY),
                $bind, "workforce",
                PDO::PARAM_STR) ;
            if ($part === '') {
                $part = "'ZZZZ'";
            }
            $where[] = "e.workforce_group IN (" . $part . ")";
            if ($withDest) {
                $where[] = "e_dest.workforce_group IN (" . $part . ")";
            }
        }

        if ($withWhere && $forCount && array_key_exists("sector", $params)) {
            $sectors = is_string($params["sector"]) ?
                preg_split('/,/', $params["sector"], -1, PREG_SPLIT_NO_EMPTY) :
                $params["sector"]
            ;
            $count = count($sectors);
            if ($count < 19) {
                $part = $this->createBindPartForIn($sectors, $bind, "sector", PDO::PARAM_STR) ;
                if ($part === '') {
                    $part = "9999";
                }                $where[] = "e.sector_id IN (" . $part . ")";
                if ($withDest) {
                    $where[] = "e_dest.sector_id IN (" . $part . ")";
                }
            }
        }
        if ($withWhere && $forCount && array_key_exists("domain", $params)) {
            $domains = is_string($params["domain"]) ?
                preg_split('/,/', $params["domain"], -1, PREG_SPLIT_NO_EMPTY) :
                $params["domain"];
            $count = count($domains);
            if ($count < 14) {
                $part = $this->createBindPartForIn($domains, $bind, "domains", PDO::PARAM_STR) ;
                if ($part === '') {
                    $part = "'ZZZZ'";
                }
                $where[] = "exists(select 1 
				   from nomenclature_link_activity_rome _nlar 
				   where _nlar.activity_naf_code = e.meta->'activity'
				   and _nlar.rome_chapter IN (" . $part . "))";
                if ($withDest) {
                    $where[] = "exists(select 1 
				   from nomenclature_link_activity_rome _nlar 
				   where _nlar.activity_naf_code = e_dest.meta->'activity'
				   and _nlar.rome_chapter IN (" . $part . "))";
                }
            }
        }

        if ($withDomain && $forCount && array_key_exists("rome", $params)) {
            $sql = str_replace('%nlar%', "nlar.rome_code = :rome", $sql) ;
            $bind['rome'] = ['v' => $params["rome"], 'p' => PDO::PARAM_STR];
        } elseif ($withDomain && array_key_exists("domain", $params)) {
            $domains = is_string($params["domain"]) ?
                preg_split('/,/', $params["domain"], -1, PREG_SPLIT_NO_EMPTY) :
                $params["domain"];
            $count = count($domains);
            if ($count < 14) {
                $part = $this->createBindPartForIn($domains, $bind, "domains", PDO::PARAM_STR) ;
                if ($part === '') {
                    $part = "'ZZZZ'";
                }
                $sql = str_replace('%nlar%', "nlar.rome_chapter IN (" . $part . ")", $sql) ;
            } else {
                $sql = str_replace('%nlar%', "1 = 1", $sql) ;
            }
        } elseif ($withDomain) {
            $sql = str_replace('%nlar%', "1 = 1", $sql) ;
        }

        if ($withWhere && array_key_exists("establishment", $params)) {
            $where[] = "e.id = :est_id " ;
            $bind['est_id'] = ['v' => $params["establishment"], 'p' => PDO::PARAM_INT];
            if ($withDest) {
                $where[] = "e_dest.id = :est_id " ;
            }
        }

        if ($withWhere && array_key_exists("rome", $params)) {
            $where[] = "exists(select 1 
				   from nomenclature_link_activity_rome _nlar 
				   where _nlar.activity_naf_code = e.meta->'activity'
				   and _nlar.rome_code = :rome
				  ) " ;
            $bind['rome'] = ['v' => $params["rome"], 'p' => PDO::PARAM_STR];
            if ($withDest) {
                $where[] = "exists(select 1 
				   from nomenclature_link_activity_rome _nlar 
				   where _nlar.activity_naf_code = e_dest.meta->'activity'
				   and _nlar.rome_code = :rome
				  ) " ;
            }
        }

        if ($withWhere && array_key_exists("hs4", $params)) {
            $where[] = "exists (select 1 
					from product _prod 
						inner join nomenclature_product _nom_prod on _nom_prod.id = _prod.nomenclature_product_id 
					where _prod.establishment_id = e.id 
					and _nom_prod.code_hs4 = :prod_hs4) " ;
            $bind['prod_hs4'] = ['v' => $params["hs4"], 'p' => PDO::PARAM_STR];
            if ($withDest) {
                $where[] = "exists (select 1 
					from product _prod 
						inner join nomenclature_product _nom_prod on _nom_prod.id = _prod.nomenclature_product_id 
					where _prod.establishment_id = e_dest.id 
					and _nom_prod.code_hs4 = :prod_hs4) " ;
            }
        }
        if ($withHs4) {
            if (array_key_exists("hs4", $params)) {
                $sql = str_replace('%hs4%', 'np.code_hs4 = :prod_hs4', $sql) ;
                if (!array_key_exists("prod_hs4", $bind)) {
                    $bind['prod_hs4'] = ['v' => $params["hs4"], 'p' => PDO::PARAM_STR];
                }
            } else {
                $sql = str_replace('%hs4%', '1=1', $sql) ;
            }
        }


        if ($withWhere && array_key_exists("q", $params)) {
            $where[] = "(e.usual_name ILIKE :search OR e.siret ILIKE :search)" ;
            $bind['search'] = ['v' => '%' . $params['q'] . '%', 'p' => PDO::PARAM_STR];
        }


        if ($withWhere) {
            $w = implode(' AND ', $where);
            $sql = str_replace('%where%', $w, $sql);
        }

        if ($debug) {
            var_dump($sql);
        }

        $statement = $this->databaseService->prepare($sql);
        foreach ($bind as $key => $value) {
            $statement->bindParam(":{$key}", $value['v'], $value['p']);
        }

        return $statement;
    }

    /**
     * @param array $params
     * @return array
     * @throws \JsonException
     */
    public function countEntity(array $params): array
    {
        $sql = "
with esta as (
	select count (*) nb
	from establishment e
	where 
        %where%
),
prod as (
	select count(distinct np.code_hs4) nb
	from product p
	  INNER JOIN nomenclature_product np on p.nomenclature_product_id = np.id
	  INNER JOIN establishment e on p.establishment_id = e.id
	where 
        %where%
        and %hs4%
),
rome_esta as (
	select  nlar.rome_code as rome, sum(nlar.factor) as value
	FROM establishment e
		INNER JOIN nomenclature_link_activity_rome nlar 
		ON nlar.activity_naf_code = e.meta->'activity'
	WHERE
        %where%
        and %nlar%
	GROUP BY nlar.rome_code	
),
rome as (
	SELECT count(*) nb
	FROM jobs j
		inner join rome_esta on j.code=rome_esta.rome
)
select jsonb_build_object('establishment', esta.nb, 'product', prod.nb, 'job', rome.nb) as count
from esta cross join prod cross join rome      
        ";

        $statement = $this->bindWhereGlobal($params, true, false, $sql);
        $statement->execute();
        if (false === $result = $statement->fetch(PDO::FETCH_ASSOC | PDO::FETCH_UNIQUE)) {
            throw new NotFoundHttpException();
        }
        return Json::decode($result["count"]);
    }

    // System accessors
    // ----------------

    /**
     * @param \App\Service\DatabaseService $databaseService
     * @return $this
     * @required
     */
    public function setDatabaseService(DatabaseService $databaseService): self
    {
        $this->databaseService = $databaseService;
        return $this;
    }

    /**
     * @param string $entityName
     * @return $this
     */
    public function setEntityName(string $entityName): self
    {
        $this->entityName = $entityName;
        return $this;
    }
}
