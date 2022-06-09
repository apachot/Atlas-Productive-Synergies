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
use App\Utility\Sql;
use PDO;

class DepartmentRepository extends EntityRepository
{
    public function getAll(string $regionCode = null): array
    {
        $wheres = [];
        if ($regionCode !== null) {
            $wheres[] = 'region.code = :regionCode';
        }
        $where = Sql::makeWhere($wheres);

        $sql = "
            SELECT
                department.code,
                department.slug,
                department.name::jsonb,
                department.region_id

            FROM department

            INNER JOIN region
                ON department.region_id = region.id
            WHERE $where

            GROUP BY department.id
        ";

        $statement = $this->databaseService->prepare($sql);
        if ($regionCode !== null) {
            $statement->bindParam(':regionCode', $regionCode);
        }
        $statement->execute();

        return array_map(
            static function (array $row): array {
                $row['name'] = Json::decode($row['name']);

                return $row;
            },
            $statement->fetchAll(PDO::FETCH_ASSOC)
        );
    }
}
