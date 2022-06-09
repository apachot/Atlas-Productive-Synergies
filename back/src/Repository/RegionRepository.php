<?php
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

namespace App\Repository;

use App\Utility\Json;
use PDO;

class RegionRepository extends EntityRepository
{
    /**
     * @param string|null $regionCode
     * @return array
     * @throws \JsonException
     */
    public function getAll(string $regionCode = null): array
    {
        if (strtoupper($regionCode)==="ALL") {
            $regionCode = null ;
        }
        $withCode = ($regionCode !== null) ;

        $sql = "
        with 
        minmax as (
            select min(eri.resilience_index) _min, max(eri.resilience_index)*0.9 _max
            from establishment_ri eri
        ),
        eri as (
        select (eri.resilience_index - _min) / (_max-_min) resilience_index, e.it_code, e.department_code, e.epci_code, e.workforce_count
        from establishment_ri eri
            inner join establishment e
            on e.id = eri.id
            cross join minmax
        where (e.enabled and e.administrative_status)
        ),
        rca as 
        (
            select region.code region,  sum(eri.resilience_index *  eri.workforce_count) / sum(eri.workforce_count) score
            from region
                INNER join department ON department.region_id = region.id
                inner join eri on eri.department_code = department.code
            group by region.code
        ) " ;
        if ($withCode) {
            $sql .= "
,pol_un as 
(
	select point.arrange, region_polylines.code, polyline_point.polyline_id, jsonb_build_array(point.lat, point.lng) pt
	from region_polylines
		inner join polylines_polyline
			inner join polyline_point
				inner join point
				on point.id = polyline_point.point_id
			on polyline_point.polyline_id = polylines_polyline.polyline_id
		on polylines_polyline.polylines_id = region_polylines.polylines_id
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
            " ;
        }
        $sql .= "        
                select 
                    region.code,
                    region.slug,
                    region.name::jsonb,
                    region.country_id,
                    vw.score coef_rca,
                    jsonb_build_object (
                        '20', json_build_object (
                            'code', '20',
                            'name', json_build_object(
                                'fr', 'TOTAL'
                            ),
                            'value', vw.score
                        )
                    ) score,
	    " ;
        if ($withCode) {
            $sql .= "
                pol.poly 
            " ;
        } else {
            $sql .= "
                '[]'::jsonb as poly 
            " ;
        }
        $sql .= "        
            from region
                inner join rca vw on vw.region = region.code
        ";
        if ($withCode) {
            $sql .= " 
                left join pol on pol.code = region.code
                where region.code = :regionCode 
            " ;
        }
        $statement = $this->databaseService->prepare($sql);
        if ($withCode) {
            $statement->bindParam(':regionCode', $regionCode);
        }
        $statement->execute();

        return array_map(
            static function (array $row): array {
                $row['name'] = Json::decode($row['name']);
                $row['score'] = Json::decode($row['score']);
                $row['poly'] = $row['poly'] ? Json::decode($row['poly']) : null;
                return $row;
            },
            $statement->fetchAll(PDO::FETCH_ASSOC)
        );
    }
}
