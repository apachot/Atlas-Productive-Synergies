<?php


namespace App\Command;

use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Command to optimize database
 */
class DatabaseOptimizationCommand extends DatabaseCommand
{
    protected static $defaultName = "app:database:optimize";

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln([
            "-------------------------------------",
            "Establishment : disable incomplete establishment"
        ]);

        $this->databaseService->exec("
UPDATE establishment e
SET enabled = true
where enabled = false
;
        ");

        $this->databaseService->exec("
UPDATE establishment e
SET enabled = false
FROM nomenclature_activity na, address a
WHERE
  -- join
  e.main_activity_id = na.id
  AND e.address_id = a.id
  -- where
  AND (
    e.deleted_at IS NOT NULL
    OR a.coordinates IS NULL
    OR na.macro_sector_id IS NULL
    OR na.section_id NOT IN (1, 2, 3, 4, 5)
    OR e.workforce_group IS NULL
  )
;        
        ");

        $output->writeln([
            "-------------------------------------",
            "Establishment : generate meta information "
        ]);

        // update macro sector on activity
        $this->databaseService->exec(
"
UPDATE
  establishment
SET
  department_code = eMeta.department,
  meta = CONCAT('lat =>', eMeta.lat, ',lng=>', eMeta.lng, ',activity=>', eMeta.activity, ',sector=>', eMeta.sector, ',department=>', eMeta.department, ',region=>', eMeta.region, ',ti=>', eMeta.ti)::hstore
FROM
  (
    SELECT
      e.id,
      a.coordinates[0] as lat,
      a.coordinates[1] as lng,
      na.code as activity,
      na.macro_sector_id as sector,
      d.code as department,
      r.code as region,
      array_agg(it.national_identifying) as ti
    FROM
      establishment e
        -- macro sector
        INNER JOIN nomenclature_activity na on e.main_activity_id = na.id
        INNER JOIN macro_sector ms on na.macro_sector_id = ms.id
        -- loc
        INNER JOIN address a on e.address_id = a.id
        INNER JOIN city c on a.city_id = c.id
        INNER JOIN department d on c.department_id = d.id
        INNER JOIN region r on d.region_id = r.id
        LEFT JOIN industry_territory it on c.industry_territory_id = it.id
    WHERE
        e.enabled = true
    GROUP BY e.id, lat, lng, activity, sector, department, region
    -- limit 100
  ) as eMeta
WHERE establishment.id = eMeta.id;
"
        );

        return 0;
    }
}
