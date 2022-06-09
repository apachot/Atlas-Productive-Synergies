<?php


namespace App\Repository;

use App\Utility\Json;
use PDO;

class IndustryTerritoryRepository extends EntityRepository
{
    /**
     * @param string|null $regionCode
     * @return array
     * @throws \JsonException
     */
    public function getAll(string $regionCode = null): array
    {
        $sql = "
           with minmax as (
                select min(eri.resilience_index) _min, max(eri.resilience_index) _max
                from establishment_ri eri
            ),
            eri as (
            select (eri.resilience_index - _min) / (_max-_min) resilience_index, e.it_code, e.department_code, e.epci_code, e.workforce_count
            from establishment_ri eri
                inner join establishment e
                on e.id = eri.id
                cross join minmax
            where (e.enabled and e.administrative_status)
            ) 
           , 
           rca as (
                select industry_territory.national_identifying it, (sum(eri.resilience_index *  eri.workforce_count) / sum(eri.workforce_count)) score
                from industry_territory 
                    inner join eri on eri.it_code = industry_territory.national_identifying
                group by industry_territory.national_identifying           
		   )
            select 
                industry_territory.national_identifying,
                industry_territory.name::jsonb,
                vw.score coef_rca
                ,jsonb_build_object (
                    '20', json_build_object (
                        'code', '20',
                        'name', json_build_object(
                            'fr', 'TOTAL'
                        ),
                        'value', vw.score
                    )
                ) score
            from industry_territory
                inner join rca vw
                on vw.it = industry_territory.national_identifying
            where exists (
                select 1
                from city
                   inner join department ON city.department_id = department.id
                   INNER JOIN region ON department.region_id = region.id
                where region.code = coalesce(:regionCode, region.code)
                and city.industry_territory_id = industry_territory.id
            )
        ";

        $statement = $this->databaseService->prepare($sql);
        $statement->bindParam(':regionCode', $regionCode);
        $statement->execute();

        return array_map(
            static function (array $row): array {
                $row['name'] = Json::decode($row['name']);
                $row['score'] = Json::decode($row['score']);

                return $row;
            },
            $statement->fetchAll(PDO::FETCH_ASSOC)
        );
    }

    public function getAllEpci(string $regionCode = null): array
    {
        $withCode = ($regionCode !== null) ;

        $sql = "
            with minmax as (
                select min(eri.resilience_index) _min, max(eri.resilience_index) _max
                from establishment_ri eri
            ),
            eri as (
            select (eri.resilience_index - _min) / (_max-_min) resilience_index, e.it_code, e.department_code, e.epci_code, e.workforce_count
            from establishment_ri eri
                inner join establishment e
                on e.id = eri.id
                cross join minmax
            where (e.enabled and e.administrative_status)
            )
            , rca as (
                select epci.siren_epci, (sum(eri.resilience_index *  eri.workforce_count) / sum(eri.workforce_count)) score
                from epci 
                    inner join eri on eri.epci_code = epci.siren_epci
                group by epci.siren_epci            
            )
            ";
        if ($withCode) {
            $sql .= "
                ,pol_un as 
                (
                    select point.arrange, epci_polylines.code, polyline_point.polyline_id, jsonb_build_array(point.lat, point.lng) pt
                    from epci_polylines
                        inner join polylines_polyline
                            inner join polyline_point
                                inner join point
                                on point.id = polyline_point.point_id
                            on polyline_point.polyline_id = polylines_polyline.polyline_id
                        on polylines_polyline.polylines_id = epci_polylines.polylines_id
                ),
                pol_deux as 
                (
                    select code, polyline_id, jsonb_agg(pt order by arrange) pol
                    from pol_un
                    group by code, polyline_id
                ),
                pol as
                (
                    select code, jsonb_agg(pol) poly
                    from pol_deux
                    group by code
                )	
            ";
        }
        $sql .= "
            select jsonb_build_object
            (
                'name', jsonb_build_object
                (
                    'fr', epci.nom_complet
                ),
                'coef_rca', rca.score,
                'score', jsonb_build_object
                (
                    '20', jsonb_build_object
                    (
                        'code', 20,
                        'name', jsonb_build_object
                        (
                            'fr', 'TOTAL'
                        ),
                        'value', rca.score
                    )
                ),
                'siren', epci.siren_epci,
                'region', r.code" ;
        if ($withCode) {
            $sql .= " ,'poly', pol.poly " ;
        } else {
            $sql .= " ,'poly', '[]'::jsonb " ;
        }
        $sql .= "
            ) result
            from epci
                inner join department d on d.code = epci.dep_epci
                INNER JOIN region r ON d.region_id = r.id
                inner join rca on rca.siren_epci = epci.siren_epci
	    " ;
        if ($withCode) {
            $sql .= "
                    left join pol on pol.code = epci.siren_epci
                where r.code = coalesce(:regionCode, r.code)
            ";
        }

        $statement = $this->databaseService->prepare($sql);
        if ($withCode) {
            $statement->bindParam(':regionCode', $regionCode);
        }
        $statement->execute();

        return array_map(
            static function (array $row): array {
                return Json::decode($row['result']);
            },
            $statement->fetchAll(PDO::FETCH_ASSOC)
        );
    }

}
