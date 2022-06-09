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

use App\Service\DatabaseService;
use PDO;
use Symfony\Component\Console\Helper\ProgressBar;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Command to create fake data for real product and partner
 */
class FakerEstablishmentCommand extends DatabaseCommand
{
    protected static $defaultName = "app:faker:establishment";

    protected function configure(): void
    {
        $this->addOption(
            "only-partner",
            null,
            InputOption::VALUE_NONE,
            'Only delete and recreate fake partners.'
        );
    }

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $onlyPartner = $input->getOption('only-partner');
        if (!$onlyPartner) {
            $this->processProductFaker($output);
        }
        $this->processPartnerFaker($output);

        return 0;
    }

    /**
     * Create fake product for all establishment in specific sector
     * @throws \App\Exception\DatabaseException
     */
    protected function processProductFaker(OutputInterface $output): void
    {
        $output->writeln("Removing fake products.");
        $this->databaseService->exec(
            "delete from product where fake = true;"
        );
        $output->writeln("Fake products have been removed.");

        $establishmentList = $this->databaseService
            ->query("
SELECT establishment.id,
       activity.code
FROM establishment
INNER JOIN nomenclature_activity activity ON establishment.main_activity_id = activity.id
INNER JOIN nomenclature_activity_product_proximity proximity ON activity.code = proximity.activity_naf2
WHERE activity.section_id IN (1, 2, 3, 4, 5)
AND proximity.proximity > 0.4
AND ( establishment.workforce_group IS NOT NULL OR establishment.workforce_group != 'NN' );")
            ->fetchAll(PDO::FETCH_ASSOC);

        $nomenclatureProductTMP = $this->databaseService
            ->query("
SELECT proximity.activity_naf2 naf,
       product.id,
       product.name
FROM nomenclature_product product
INNER JOIN nomenclature_activity_product_proximity proximity ON product.code_hs4 =  proximity.product_hs4
WHERE proximity.proximity > 0.4
AND length(product.code_nc) = 10;")
            ->fetchAll(PDO::FETCH_ASSOC);
        $nomenclatureProduct = [];
        foreach ($nomenclatureProductTMP as $data) {
            if (!array_key_exists($data["naf"], $nomenclatureProduct)) {
                $nomenclatureProduct[$data["naf"]] = [];
            }
            $name = DatabaseService::convertHstoreFromPg($data["name"]);
            $name = DatabaseService::convertHstoreToPg($name);
            $nomenclatureProduct[$data["naf"]][] = [
                "id" => $data["id"],
                "name" => $name,
            ];
        }
        unset($nomenclatureProductTMP);

        $productInsertValues = [];
        $count = 0;
        $insertSqlPattern = "
INSERT INTO product (establishment_id, nomenclature_product_id, name, fake, updated_by)
VALUES :productInsertPart;";

        $eCount = count($establishmentList);
        $progressBar = new ProgressBar($output, $eCount);
        $progressBar->start();

        foreach ($establishmentList as $establishment) {
            $productCount = count($nomenclatureProduct[$establishment["code"]]);
            $randProductNumber = random_int(1, $productCount);
            $randProductId = array_rand($nomenclatureProduct[$establishment["code"]], $randProductNumber);
            if (!is_array($randProductId)) {
                $randProductId = [$randProductId];
            }
            foreach ($randProductId as $index) {
                $establishmentId = $establishment["id"];
                $productId = $nomenclatureProduct[$establishment["code"]][$index]["id"];
                $name = $nomenclatureProduct[$establishment["code"]][$index]["name"];
                $productInsertValues[] = "($establishmentId, $productId, $name, true, 0)";
            }
            if (0 === (++$count % 10000)) {
                $productInsertPart = implode(",", $productInsertValues);
                $this->databaseService->exec(strtr($insertSqlPattern, [":productInsertPart" => $productInsertPart]));
                $productInsertValues = [];
                unset($productInsertPart);
            }
            $progressBar->advance();
        }
        $progressBar->finish();
        unset($establishmentList);

        if (!empty($productInsertValues)) {
            $productInsertPart = implode(",", $productInsertValues);
            $this->databaseService->exec(strtr($insertSqlPattern, [":productInsertPart" => $productInsertPart]));
            unset($productInsertValues, $productInsertPart);
        }
    }

    /**
     * Create fake partner
     *
     * @throws \App\Exception\DatabaseException
     *@throws \Exception
     */
    protected function processPartnerFaker(OutputInterface $output): void
    {
        $output->writeln("Removing fake relations.");
        $this->databaseService->exec(
            "delete from relation where fake = true;"
        );
        $output->writeln("Fake relations have been removed.");

        // récupérer la liste des parenté produit
        $relationship = $this->databaseService
            ->query("
SELECT main_product_code_hs4,
       array_agg(secondary_product_code_hs4)
FROM nomenclature_product_relationship relationship
WHERE strength >= 0.5
GROUP BY main_product_code_hs4;")
            ->fetchAll(PDO::FETCH_KEY_PAIR);
        foreach ($relationship as $main => &$secondary) {
            $secondary = explode(",", trim($secondary, "{}"));
        }
        unset($secondary);
        $output->writeln("relationship loaded.");

        // récupérer la liste des entreprises
        // récupérer la liste des entreprises trié par produit fabriqués

        $output->writeln("product loading.");
        $sql = "
SELECT np.code_hs4,
        json_agg( json_build_object ('establishmentId', p.establishment_id) ) as arr
FROM nomenclature_product np
    INNER JOIN product p on np.id = p.nomenclature_product_id
GROUP BY np.code_hs4 
;
        ";
        $establishmentByProductTMP = $this->databaseService
            ->query($sql)
            ->fetchAll(PDO::FETCH_ASSOC);
        $output->writeln("product loaded.");
        $establishmentByProduct = [];
        foreach ($establishmentByProductTMP as $value) {
            $establishmentByProduct[$value["code_hs4"]] = json_decode($value["arr"], $assoc = true) ;
        }
        unset($establishmentByProductTMP);
        $output->writeln("establishmentByProduct create.");
        $relationValues = [];
        $relations = [];
        $count = 0;
        $hs4Count = count($establishmentByProduct);
        $progressBar = new ProgressBar($output, $hs4Count);
        $progressBar->start();
        foreach ($establishmentByProduct as $hs4 => $data) {
            if (!array_key_exists($hs4, $relationship)) {
                continue;
            }
            $parentHs4List = $relationship[$hs4];
            foreach ($data as $product) {
                $eid = "'{$product["establishmentId"]}'";
                $randParentHs4 = $parentHs4List[array_rand($parentHs4List)];
                if (!array_key_exists($randParentHs4, $establishmentByProduct)) {
                    continue;
                }
                $clientList = $establishmentByProduct[$randParentHs4];
                $randNumber = random_int(1, min([5, count($clientList)]));
                $randClient = array_rand($clientList, $randNumber);
                if (is_int($randClient)) {
                    $randClient = [$randClient];
                }
                foreach ($randClient as $index) {
                    $client = $clientList[$index];
                    $supplierId = "'{$client["establishmentId"]}'";
                    if (!array_key_exists("${supplierId}_${eid}", $relations)) {
                        $relations["${supplierId}_${eid}"] = 1;
                        $relationValues[] = "('PARTNER', $supplierId, $eid, true, 0)";
                        $relationValues[] = "('PARTNER', $eid, $supplierId, true, 0)";
                    }
                    if (0 === (++$count % 5000)) {
                        $productRelationPart = implode(",", $relationValues);
                        $this->databaseService->exec("
INSERT INTO relation (type, establishment_id, secondary_establishment_id, fake, updated_by)
VALUES $productRelationPart;                
                ");
                        unset($productRelationPart);
                        $relationValues = [];
                    }
                }
            }
            $progressBar->advance();
        }
        $progressBar->finish();
        if (!empty($relationValues)) {
            $productRelationPart = implode(",", $relationValues);
            $this->databaseService->exec("
INSERT INTO relation (type, establishment_id, secondary_establishment_id, fake, updated_by)
VALUES $productRelationPart;                
            ");
            unset($productRelationPart, $relationValues);
        }
    }
}
