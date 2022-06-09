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
