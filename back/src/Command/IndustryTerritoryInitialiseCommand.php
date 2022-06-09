<?php


namespace App\Command;

use PDO;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Command to initialise industry territory
 */
class IndustryTerritoryInitialiseCommand extends DatabaseCommand
{
    protected static $defaultName = "app:industry_territory:initialise";

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln([
            "----------------------",
            "Industry territory initialisation"
        ]);
        $territoryFile = fopen("{$this->sqlDirectory}/fixture/com2019.csv", 'rb');

        $existingTerrytoryIds = $this->databaseService->query("
SELECT national_identifying, id FROM industry_territory")
            ->fetchAll(PDO::FETCH_KEY_PAIR);

        // read header
        fgetcsv($territoryFile, 0, ";");
        fgetcsv($territoryFile, 0, ";");
        fgetcsv($territoryFile, 0, ";");
        fgetcsv($territoryFile, 0, ";");
        fgetcsv($territoryFile, 0, ";");

        $territoryIds = [];
        $count = 0;
        $cityUpdate = [];
        while (false !== ($data = fgetcsv($territoryFile, 0, ";"))) {
            $cityCodeInsee = $data[0];
            $territoryCode = $data[2];
            $territoryName = str_replace(["'", "\""], "''", trim($data[3]));


            if ("" === $territoryCode) {
                continue;
            }

            if (!array_key_exists($territoryCode, $territoryIds)) {
                if (!array_key_exists($territoryCode, $existingTerrytoryIds)) {
                    $count++;
                    $sql = "INSERT INTO industry_territory (name, national_identifying, updated_by)
 VALUES ('fr => \"$territoryName\"'::hstore, '$territoryCode', 0) RETURNING id;";
                    $id = $this->databaseService->query($sql)->fetch(PDO::FETCH_COLUMN);
                    $territoryIds[$territoryCode] = $id;
                } else {
                    $territoryIds[$territoryCode] = $existingTerrytoryIds[$territoryCode];
                }
            }

            $cityUpdate[] = "UPDATE city
SET industry_territory_id = {$territoryIds[$territoryCode]}
WHERE insee_code = '$cityCodeInsee';";
        }
        $cityCount = count($cityUpdate);
        $sql = implode(" ", $cityUpdate);
        $this->databaseService->exec($sql);

        $output->writeln(["$count industry territory saved and $cityCount cities updated"]);

        return 0;
    }
}
