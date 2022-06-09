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
 * Command to complete nomenclature product information
 */
class NomenclatureProductCompleteCommand extends DatabaseCommand
{
    protected static $defaultName = "app:product:complete";

    private const HS_TO_SECTOR = [
        '01' => 1,
        '02' => 1,
        '03' => 1,
        '04' => 1,
        '05' => 1,
        '06' => 2,
        '07' => 2,
        '08' => 2,
        '09' => 2,
        '10' => 2,
        '11' => 2,
        '12' => 2,
        '13' => 2,
        '14' => 2,
        '15' => 3,
        '16' => 4,
        '17' => 4,
        '18' => 4,
        '19' => 4,
        '20' => 4,
        '21' => 4,
        '22' => 4,
        '23' => 4,
        '24' => 4,
        '25' => 5,
        '26' => 5,
        '27' => 5,
        '28' => 6,
        '29' => 6,
        '30' => 6,
        '31' => 6,
        '32' => 6,
        '33' => 6,
        '34' => 6,
        '35' => 6,
        '36' => 6,
        '37' => 6,
        '38' => 6,
        '39' => 7,
        '40' => 7,
        '41' => 8,
        '42' => 8,
        '43' => 8,
        '44' => 9,
        '45' => 9,
        '46' => 9,
        '47' => 10,
        '48' => 10,
        '49' => 10,
        '50' => 11,
        '51' => 11,
        '52' => 11,
        '53' => 11,
        '54' => 11,
        '55' => 11,
        '56' => 11,
        '57' => 11,
        '58' => 11,
        '59' => 11,
        '60' => 11,
        '61' => 11,
        '62' => 11,
        '63' => 11,
        '64' => 12,
        '65' => 12,
        '66' => 12,
        '67' => 12,
        '68' => 13,
        '69' => 13,
        '70' => 13,
        '71' => 14,
        '72' => 15,
        '73' => 15,
        '74' => 15,
        '75' => 15,
        '76' => 15,
        '78' => 15,
        '79' => 15,
        '80' => 15,
        '81' => 15,
        '82' => 15,
        '83' => 15,
        '84' => 16,
        '85' => 16,
        '86' => 17,
        '87' => 17,
        '88' => 17,
        '89' => 17,
        '90' => 18,
        '91' => 18,
        '92' => 18,
        '93' => 19,
        '94' => 19,
        '95' => 19,
        '96' => 19,
        '97' => 19,
        ];

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln([
            "-------------------------------------",
            "Product correspondance initialisation"
        ]);
        $correspondenceFile = fopen("{$this->sqlDirectory}/fixture/product_correspondance.csv", 'rb');

        // process header
        fgetcsv($correspondenceFile, 0, ";");

        $sql = [];
        $count = 0;
        $updatePattern = "
UPDATE nomenclature_product
SET code_cpf4 = ':cpf4', code_cpf6 = ':cpf6', macro_sector_id = ':sectorId'
WHERE code_nc = ':nc';";
        while (false !== ($data = fgetcsv($correspondenceFile, 0, ";"))) {
            [$nc8, , $cpf4, $cpf6] = $data;
            $hs2 = substr($nc8, 0, 2);
            if (!array_key_exists($hs2, self::HS_TO_SECTOR)) {
                $this->logger->warning("hs inexistant", [$nc8, $cpf4, $cpf6]);
                continue;
            }
            $sql[] = strtr(
                $updatePattern,
                [":cpf4" => $cpf4, ":cpf6" => $cpf6, ":sectorId" => self::HS_TO_SECTOR[$hs2], ":nc" => $nc8]
            );
            if (1000 === ++$count) {
                $sqlExec = implode(" ", $sql);
                $this->databaseService->exec($sqlExec);
                unset($sqlExec);
                $sql = [];
                $count = 0;
            }
        }

        if (!empty($sql)) {
            $sqlExec = implode(" ", $sql);
            $this->databaseService->exec($sqlExec);
        }

        $output->writeln([
            "-------------------------------------",
            "Linking activity to macro sector"
        ]);

        // update macro sector on activity
        $stmt = $this->databaseService->query("
select code_cpf4, macro_sector_id
from nomenclature_product
group by code_cpf4, macro_sector_id;
        ");
        $links = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);
        foreach ($links as $cpf4 => $macroSectorId) {
            if (empty($cpf4)) {
                continue;
            }
            $naf = "%" . substr($cpf4, 0, 2) . "." . substr($cpf4, 2) . "%";
            $this->databaseService->exec(
                "UPDATE nomenclature_activity SET macro_sector_id = $macroSectorId WHERE code LIKE '$naf';"
            );
        }

        return 0;
    }
}
