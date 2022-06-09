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
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Yaml\Yaml;

class ImportSpecificFakerCommand extends DatabaseCommand
{
    protected static $defaultName = "app:spec_faker:establishment";

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $this->importFile("laiterie.yaml");

        return 0;
    }

    protected function importFile(string $fileName): void
    {
        $city = $this->databaseService
            ->query("SELECT insee_code, id FROM city;")
            ->fetchAll(PDO::FETCH_KEY_PAIR);
        $activity = $this->databaseService
            ->query("SELECT code, id FROM nomenclature_activity;")
            ->fetchAll(PDO::FETCH_KEY_PAIR);
        $nproduct = $this->databaseService
            ->query("SELECT code_nc, id, name FROM nomenclature_product WHERE length(code_nc) = 10;")
            ->fetchAll(PDO::FETCH_UNIQUE);

        $establishmentList = Yaml::parseFile("{$this->sqlDirectory}/fixture/$fileName");

        $establishmentProduct = [];
        foreach ($establishmentList as &$establishment) {
            // address
            $cityData = $establishment["address"];
            $cityId = $city[$cityData["insee_code"]];
            $coordinates = "'{$cityData["coordinate"][0]},{$cityData["coordinate"][1]}'::point";
            $wayLabel = str_replace(["'", "\""], "''", trim($cityData["way_label"]));
            $wayLabel = "'$wayLabel'";
            $wayNumber = "'{$cityData["way_number"]}'";
            $wayType = "'{$cityData["way_type"]}'";
            $addressId = $this->databaseService
                ->query("
INSERT INTO address (city_id, coordinates, way_label, way_number, way_type, updated_by)
VALUES ($cityId, $coordinates, $wayLabel, $wayNumber, $wayType, 0)
RETURNING id;
                ")
                ->fetch(PDO::FETCH_COLUMN|PDO::FETCH_UNIQUE);

            // establishment
            $activityId = $activity[$establishment["activity_code"]];
            $description = $establishment["description"]
                ? "'fr => \""
                    . str_replace(["'", "\""], "''", trim($establishment["description"]))
                    . "\"'::hstore"
                : "null";
            $name = str_replace(["'", "\""], "''", trim($establishment["establishment_name"]));
            $name = "'$name'";
            $phoneFix = "'{$establishment["phone_fix"]}'";
            $phoneMobile = "'{$establishment["phone_mobile"]}'";
            $siret = "'{$establishment["siret"]}'";
            $web_site = "'{$establishment["web_site"]}'";
            $workforce = "'{$establishment["workforce_group"]}'";

            $establishmentId = $this->databaseService
                ->query("
INSERT INTO establishment (address_id, administrative_status, creation_date, description, main_activity_id, phone_fix, phone_mobile, siret, usual_name, web_site, workforce_group, updated_by)
VALUES ($addressId, true, '1900-01-01', $description, $activityId, $phoneFix, $phoneMobile, $siret, $name, $web_site, $workforce, 0)
RETURNING id;")
                ->fetch(PDO::FETCH_COLUMN|PDO::FETCH_UNIQUE);

            // product
            $productIds = [];
            foreach ($establishment["product"] as $productData) {
                $nomenclatureProduct = $nproduct[$productData["product_nc8"]];
                $npId = "'{$nomenclatureProduct["id"]}'";
                $npName = DatabaseService::convertHstoreToPg(
                    DatabaseService::convertHstoreFromPg(
                        $nomenclatureProduct["name"]
                    )
                );
                $productIds[$productData["product_nc8"]] = $this->databaseService
                    ->query("
INSERT INTO product (establishment_id, nomenclature_product_id, name, fake, updated_by) 
VALUES ($establishmentId, $npId, $npName, true, 0)
RETURNING id;")
                    ->fetch(PDO::FETCH_COLUMN|PDO::FETCH_UNIQUE);
            }
            $establishment["id"] = $establishmentId;
            $establishmentProduct[$establishment["siret"]] = [
                "product" => $productIds,
                "id" => $establishmentId,
            ];
        }
        unset($establishment);

        foreach ($establishmentList as $establishment) {
            if (array_key_exists("supplier", $establishment)) {
                foreach ($establishment["supplier"] as $supplier) {
                    $e = $establishmentProduct[$establishment["siret"]];
                    $s = $establishmentProduct[$supplier["siret"]];
                    $productId = $e["product"][$supplier["product_nc8"]];
                    $eId = $s["id"];
                    $secondaryProductId = 'NULL';
                    if (isset($supplier['secondary_product_nc8'])) {
                        $secondaryProductId = $s["product"][$supplier["secondary_product_nc8"]];
                    }
                    $this->databaseService->exec("
INSERT INTO relation (type, establishment_id, secondary_establishment_id, fake, updated_by)
VALUES ('PARTNER', ${establishment['id']}, $eId, true, 0);");
                }
            }
            if (array_key_exists("client", $establishment)) {
                $mainProduct = $establishmentProduct[$establishment["siret"]]["product"];
                foreach ($establishment["client"] as $clientProduct) {
                    $client = $establishmentProduct[$clientProduct["siret"]];
                    $productId = $mainProduct[$clientProduct["product_nc8"]];

                    $eId = $client["id"];

                    $secondaryProductId = 'NULL';
                    if (isset($clientProduct['secondary_product_nc8'])) {
                        $secondaryProductId = $client["product"][$clientProduct['secondary_product_nc8']];
                    }

                    $this->databaseService->exec("
INSERT INTO relation (type, establishment_id, secondary_establishment_id, fake, updated_by)
VALUES ('PARTNER', ${establishment['id']}, $eId, true, 0);");
                }
            }
        }
    }
}
