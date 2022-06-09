<?php


namespace App\Repository;

use App\EntityVue\VisualisationRomeByActivity;
use App\Utility\Json;
use App\Utility\Sql;
use PDO;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

/**
 * Specific repository fro nomenclature_rome entity
 */
class NomenclatureRomeRepository extends EntityRepository
{
    /**
     * Read all rome code by activity code
     * @return \App\EntityVue\VisualisationRomeByActivity
     * @throws \App\Exception\DatabaseException
     */
    public function allByNomenclatureActivity()
    {
        $sql = "
SELECT  DISTINCT activity.code activity_code,
                 rome.code,
                 rome.name 

FROM nomenclature_rome rome
    INNER JOIN nomenclature_link_activity_rome link ON rome.code = link.rome_code AND rome.ogr IS NULL
    INNER JOIN nomenclature_activity activity ON link.activity_naf_code = activity.code
WHERE activity.section_id IN (1, 2, 3, 4, 5)
;";

        $result = $this->databaseService->query($sql)->fetchAll(PDO::FETCH_ASSOC);

        return new VisualisationRomeByActivity($result);
    }


    /**
     * @return array
     * @throws \App\Exception\DatabaseException
     */
    public function listJobs()
    {
        $sql = "
SELECT j.code 
FROM jobs j
";
        $statement = $this->databaseService->query($sql);
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }

        return $results;
    }

    /**
     * @param string $params
     * @return array
     * @throws \App\Exception\DatabaseException
     * @throws \JsonException
     */
    public function listJobsWithValue(array $params): array
    {
        $paramsWithoutId = $params;
        if (array_key_exists('rome', $paramsWithoutId)) {
            unset($paramsWithoutId['rome']);
        }

        $sql = "
With esta as (
	select  nlar.rome_code as rome, sum(nlar.factor) as value
	FROM establishment e
		INNER JOIN nomenclature_link_activity_rome nlar 
		ON nlar.activity_naf_code = e.meta->'activity'
	WHERE
	  %where%
	  and %nlar%
	GROUP BY nlar.rome_code	
)
SELECT j.code as id, coalesce(esta.value,0) as value
FROM jobs j
	left join esta on j.code=esta.rome
	    ";

        $statement = $this->bindWhereGlobal($paramsWithoutId, false, false, $sql);
        $statement->execute();
        if (false === $results = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }

        $paramsMini = $params;
        unset(
            $paramsMini['domain'],
            $paramsMini['sector'],
            $paramsMini['workforce'],
            $paramsMini['rome'],
            $paramsMini['hs4'],
            $paramsMini['establishment']
        );

        $longlabel = Sql::makeI18nSelect('jobs.longlabel', $params);

        $sql = "
with cumul as (
	select  nlar.rome_code as rome, sum(nlar.factor) as value
	from establishment e
		INNER JOIN nomenclature_link_activity_rome nlar 
		ON nlar.activity_naf_code = e.meta->'activity'
	where
	    %where%
	group by nlar.rome_code
	order by value desc
	limit 10
	)
select jobs.code, {$longlabel}, cumul.value
from cumul
	left join jobs on jobs.code = cumul.rome
order by cumul.value desc        
        ";

        $statement = $this->bindWhereGlobal($paramsMini, false, false, $sql);
        $statement->execute();
        if (false === $representativeWork = $statement->fetchAll(PDO::FETCH_ASSOC)) {
            throw new NotFoundHttpException();
        }


        return [
            'data' => array_map(
                static function ($job) {
                    return ['id' => $job["id"], 'value' => (float) $job["value"]];
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
            'count' => $this->countEntity($params),
            'representativeWork' => $representativeWork
        ];
    }

    /**
     * @param string $rome
     * @return array|null
     * @throws \JsonException
     */
    public function jobLinkInformation(string $rome, $lang = 'en'): ?array
    {
        $shortLabel = Sql::makeI18nSelect('jl.shortlabel', $lang, '');
        $longLabel = Sql::makeI18nSelect('jl.longlabel', $lang, '');

        $sql = "
WITH jlk AS (
	SELECT LEAST(src_jobs_id, dest_jobs_id) as src, GREATEST(src_jobs_id, dest_jobs_id) as dest
    FROM jobs_link
	UNION
	SELECT GREATEST(src_jobs_id, dest_jobs_id) as src, LEAST(src_jobs_id, dest_jobs_id) as dest
	FROM jobs_link
)
SELECT jsonb_agg(json_build_object(
	'code', jl.code,
	'shortLabel', {$shortLabel},
	'longLabel', {$longLabel}
)) as link
FROM jobs j
	INNER JOIN jlk 
		INNER JOIN jobs jl
		ON jl.id = jlk.dest
	ON jlk.src = j.id
WHERE j.code = :rome
";

        $statement = $this->databaseService->prepare($sql);
        $statement->bindParam(":rome", $rome, PDO::PARAM_STR);
        $statement->execute();
        if (false === $results = $statement->fetch(PDO::FETCH_ASSOC | PDO::FETCH_UNIQUE)) {
            throw new NotFoundHttpException();
        }
        return (string)$results["link"] ?
            Json::decode((string)$results["link"]) :
            null ;
    }
}
