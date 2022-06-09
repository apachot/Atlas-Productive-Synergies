<?php


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
