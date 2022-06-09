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

use App\Exception\DatabaseException;
use Exception;
use JsonException;
use PDO;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Command to initialise database except establishment
 */
class DatabaseInitialiseCommand extends DatabaseCommand
{
    protected static $defaultName = "app:database:initialise";

    private OutputInterface $output;

    private array $productIds = [];
    private array $activityIds = [];

    /**
     * @param InputInterface $input
     * @param OutputInterface $output
     * @return int
     * @throws DatabaseException
     * @throws JsonException
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $this->output = $output;

        $countryIds = $this->initCountry();
        $this->initFrance($countryIds["FRA"]);
        $this->initNomenclatureProduct();
        $this->initNomenclatureProductProximity();
        $this->initNomenclatureProductRelationship();
        $this->initNomenclatureActivity();
        $this->initNomenclatureRome();
        $this->initLinkActivityRome();

        return 0;
    }

    /**
     * Read country from fixture/country file and return list of id indexed by iso 1366 3 code
     *
     * @return array
     * @throws DatabaseException
     */
    private function initCountry(): array
    {
        $this->output->writeln(
            [
                "----------------------",
                "Country initialisation"
            ]
        );
        $countryFile = fopen("{$this->sqlDirectory}/fixture/country.csv", 'rb');

        // read header
        fgetcsv($countryFile, 0, ";");

        $values = [];
        while (false !== ($data = fgetcsv($countryFile, 0, ";"))) {
            $iso = utf8_encode($data[2]);
            $name = str_replace(["'", "\""], "''", trim(utf8_encode($data[0])));
            $nameLong = str_replace(["'", "\""], "''", trim(utf8_encode($data[4])));
            $values[] = "('$iso', 'fr => \"$name\"'::hstore, 'fr => \"$nameLong\"'::hstore, 0)";
        }
        $values = implode(',', $values);

        $countryIds = $this->databaseService
            ->query(
                "INSERT INTO country (iso31663, long_name, name, updated_by) VALUES $values RETURNING iso31663, id"
            )->fetchAll(PDO::FETCH_KEY_PAIR);
        $this->output->writeln(
            [
                count($countryIds) . " countries saved",
            ]
        );
        return $countryIds;
    }

    /**
     * Read cities, departments and region in fixtures directory and complete $this->cityIds list of cities ids
     * indexed by insee code
     *
     * @param int $franceId
     * @throws JsonException
     * @throws DatabaseException
     */
    private function initFrance(int $franceId): void
    {
        $this->output->writeln(
            [
                "----------------------",
                "Region initialisation"
            ]
        );
        // regions management
        $regionsList = file_get_contents("{$this->sqlDirectory}/fixture/regions.json");
        $regionsList = json_decode($regionsList, true, 512, JSON_THROW_ON_ERROR);

        $values = [];
        foreach ($regionsList as $region) {
            $code = $region['code'];
            $name = str_replace(["'", "\""], "''", trim($region["name"]));
            $slug = str_replace(" ", "_", trim($region["slug"]));
            $values[] = "('$code', $franceId, 'fr => \"$name\"'::hstore, '$slug', 0)";
        }
        $valuesPart = implode(',', $values);

        $regionsIds = $this->databaseService->query(
            "INSERT INTO region (code, country_id, name, slug, updated_by)  VALUES $valuesPart RETURNING code, id"
        )->fetchAll(PDO::FETCH_KEY_PAIR);
        $this->output->writeln(
            [
                count($regionsIds) . " regions saved",
            ]
        );

        // departments management
        $this->output->writeln(
            [
                "----------------------",
                "Departments initialisation"
            ]
        );
        $departmentsList = json_decode(
            file_get_contents("{$this->sqlDirectory}/fixture/departments.json"),
            true,
            512,
            JSON_THROW_ON_ERROR
        );

        $values = [];
        foreach ($departmentsList as $department) {
            $code = $department['code'];
            $name = str_replace(["'", "\""], "''", trim($department["name"]));
            $slug = str_replace(" ", "_", trim($department["slug"]));
            $values[] = "('$code', {$regionsIds[$department["region_code"]]}, 'fr => \"$name\"'::hstore, '$slug', 0)";
        }
        $valuesPart = implode(',', $values);

        $departmentsIds = $this->databaseService->query(
            "INSERT INTO department (code, region_id, name, slug, updated_by)   VALUES $valuesPart RETURNING code, id"
        )->fetchAll(PDO::FETCH_KEY_PAIR);
        $this->output->writeln(
            [
                count($departmentsIds) . " departments saved",
            ]
        );

        // cities management
        $this->output->writeln(
            [
                "----------------------",
                "Cities initialisation"
            ]
        );
        $citiesList = json_decode(
            file_get_contents("{$this->sqlDirectory}/fixture/cities.json"),
            true,
            512,
            JSON_THROW_ON_ERROR
        );

        $values = [];
        foreach ($citiesList as $city) {
            if (empty($city["insee_code"])) {
                continue;
            }
            $coordinates = "{$city["gps_lat"]}, {$city["gps_lng"]}";
            $name = str_replace(["'", "\""], "''", trim($city["name"]));
            $slug = str_replace(" ", "_", trim($city["slug"]));
            $values[] = "('$coordinates'::point, {$departmentsIds[$city["department_code"]]}, '{$city["insee_code"]}'," .
                " 'fr => \"$name\"'::hstore, '$slug', '{$city["zip_code"]}', 0)";
        }
        $valuesPart = implode(',', $values);

        $this->databaseService->exec(
            "INSERT INTO city (coordinates, department_id, insee_code, name, slug, zip_code, updated_by)
VALUES $valuesPart"
        );
        $this->output->writeln([count($values) . " cities saved"]);
    }

    /**
     * Read nomenclature product from NC2020a-FR.csv file and complete $this->productIds with product ids indexed by nc code.
     *
     * @throws DatabaseException
     */
    private function initNomenclatureProduct(): void
    {
        $this->output->writeln(
            [
                "----------------------",
                "Product initialisation"
            ]
        );

        $sectionIds = $this->databaseService->query(
            "
SELECT short_name, id FROM nomenclature_product_section"
        )
            ->fetchAll(PDO::FETCH_KEY_PAIR);

        $productFile = fopen("{$this->sqlDirectory}/fixture/NC2020a-FR.csv", 'rb');

        // read header
        fgetcsv($productFile, 0, ";");

        $sectionId = null;
        $chapitreId = null;
        $productValues = [];
        $count = 0;
        $sectionId = 1;
        while (false !== ($data = fgetcsv($productFile, 0, ";"))) {
            $code = $data[0];
            if (0 === strpos($code, "SECTION")) {
                $sectionId = $sectionIds[$code];
                continue;
            }
            if (0 === strpos($code, "CHAPITRE")) {
                // create new chapitre
                $name = str_replace(["'", "\""], "''", trim($data[1]));
                $shortName = trim($data[0]);
                $chapitreId = $this->databaseService->query(
                    "INSERT INTO nomenclature_product_chapter (name, product_section_id, short_name, updated_by)
VALUES ('fr => \"$name\"'::hstore, $sectionId, '$shortName', 0) RETURNING id;"
                )->fetch(PDO::FETCH_COLUMN);
                continue;
            }
            $nc = str_pad($data[0], 4, "0", STR_PAD_LEFT);
            $hs4 = substr($nc, 0, 4);
            $name = str_replace(["'", "\""], "''", trim($data[1]));
            $productValues[] = "('$hs4', '$nc', 'fr => \"$name\"'::hstore, $chapitreId, 0)";
            $count++;
            if (0 === $count % 10000) {
                $productValuesPart = implode(',', $productValues);
                $this->productIds[] = $this->databaseService->query(
                    "INSERT INTO nomenclature_product (code_hs4, code_nc, name, product_chapter_id, updated_by)
        VALUES $productValuesPart RETURNING code_nc, id;"
                )->fetchAll(PDO::FETCH_KEY_PAIR);
                $productValues = [];
                $productValuesPart = null;
            }
        }
        if (!empty($productValues)) {
            $productValues = implode(',', $productValues);
            $this->productIds[] = $this->databaseService->query(
                "INSERT INTO nomenclature_product (code_hs4, code_nc, name, product_chapter_id, updated_by)
VALUES $productValues RETURNING code_nc, id;"
            )->fetchAll(PDO::FETCH_KEY_PAIR);
        }

        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 1 WHERE id = 1;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 2 WHERE id = 2;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 3 WHERE id = 3;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 4 WHERE id = 4;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 5 WHERE id = 5;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 6 WHERE id = 6;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 7 WHERE id = 7;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 8 WHERE id = 8;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 9 WHERE id = 9;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 10 WHERE id = 10;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 11 WHERE id = 11;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 12 WHERE id = 12;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 13 WHERE id = 13;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 14 WHERE id = 14;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 15 WHERE id = 15;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 16 WHERE id = 16;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 17 WHERE id = 17;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 18 WHERE id = 18;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 19 WHERE id = 19;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 19 WHERE id = 20;");
        $this->databaseService->exec("UPDATE nomenclature_product_section SET macro_sector_id = 19 WHERE id = 21;");

        $this->productIds = array_merge(...$this->productIds);

        /**
         * update for creating missing lines in nomenclature_product
         * when the product have a level 00 (or 00 00) the first line is not present
         * correction by adding a "false" line without the 00 indices
         */
        $sql = "
INSERT INTO nomenclature_product (code_cpf4, code_cpf6, code_hs4, code_nc, macro_sector_id, \"name\", product_chapter_id,
                                  created_at, updated_at, deleted_at, updated_by)
SELECT np.code_cpf4, np.code_cpf6, np.code_hs4, left(np.code_nc,7), np.macro_sector_id, np.\"name\", np.product_chapter_id
     , now(), now(), null , 0
FROM nomenclature_product np
    LEFT JOIN nomenclature_product np2
    ON np2.code_nc = left(np.code_nc,7)
WHERE np.code_nc LIKE '____ 00 00'
  AND np2.id is null;
        ";
        $this->databaseService->exec($sql);

        $sql = "
INSERT INTO nomenclature_product (code_cpf4, code_cpf6, code_hs4, code_nc, macro_sector_id, \"name\", product_chapter_id,
                                  created_at, updated_at, deleted_at, updated_by)
SELECT np.code_cpf4, np.code_cpf6, np.code_hs4, left(np.code_nc,4), np.macro_sector_id, np.\"name\", np.product_chapter_id
                   , now(), now(), null , 0
FROM nomenclature_product np
    LEFT JOIN nomenclature_product np2
    ON np2.code_nc = left(np.code_nc,4)
WHERE np.code_nc like '____ 00'
  AND np2.id is null;
          ";
        $this->databaseService->exec($sql);

        $this->output->writeln(["$count product saved"]);
    }

    /**
     * Read product proximity from hs92_proximities.csv.
     *
     * @throws DatabaseException
     */
    private function initNomenclatureProductProximity(): void
    {
        $this->output->writeln(
            [
                "--------------------------------",
                "Product proximity initialisation"
            ]
        );
        $proximityFile = fopen("{$this->sqlDirectory}/fixture/hs92_proximities.csv", 'rb');

        // read header
        fgetcsv($proximityFile, 0, ";");

        $values = [];
        $count = 0;
        while (false !== ($data = fgetcsv($proximityFile, 0, ","))) {
            if (!in_array($data[0], $this->productIds)) {
                $this->logger->warning("Product {$data[0]} doesn't exist");
                continue;
            }
            [$mainHs4, $secondaryHs4, $proximity] = $data;
            $values[] = "('$mainHs4', $proximity, '$secondaryHs4', 0)";
            $count++;
            if (0 === $count % 10000) {
                $valuesPart = implode(',', $values);
                $this->databaseService->exec(
                    "INSERT INTO nomenclature_product_proximity (main_product_code_hs4, proximity, secondary_product_code_hs4, updated_by)
        VALUES $valuesPart;"
                );
                $values = [];
                $valuesPart = null;
            }
        }
        if (!empty($values)) {
            $valuesPart = implode(',', $values);

            $this->databaseService->exec(
                "INSERT INTO nomenclature_product_proximity (main_product_code_hs4, proximity, secondary_product_code_hs4, updated_by)
VALUES $valuesPart;"
            );
        }
        $this->output->writeln("Proximities $count processed");
    }

    /**
     * Read product relationship from network_hs92_4digit.json
     * @throws DatabaseException
     * @throws JsonException
     */
    private function initNomenclatureProductRelationship(): void
    {
        $this->output->writeln(
            [
                "--------------------------------",
                "Product relationship initialisation"
            ]
        );
        $relationshipList = file_get_contents("{$this->sqlDirectory}/fixture/network_hs92_4digit.json");
        $relationshipList = json_decode($relationshipList, true, 512, JSON_THROW_ON_ERROR);

        $values = [];
        foreach ($relationshipList["edges"] as $relationship) {
            $strength = $relationship["strength"];
            $mainProductHs4 = str_pad($relationship["source"], 4, "0", STR_PAD_LEFT);
            $secondaryProductHs4 = str_pad($relationship["target"], 4, "0", STR_PAD_LEFT);
            $values[] = "('$mainProductHs4', '$secondaryProductHs4', $strength, 0)";
        }
        $valuesPart = implode(',', $values);
        $count = count($values);
        unset($values);

        $this->databaseService->exec(
            "INSERT INTO nomenclature_product_relationship (main_product_code_hs4, secondary_product_code_hs4, strength, updated_by) 
    VALUES $valuesPart;"
        );

        $this->output->writeln("Product $count relationship processed");
    }

    /**
     * Read nomenclature activity from naf_rev_2.csv file and complete $this->activityIds with ids indexed by naf code
     * @throws DatabaseException
     */
    private function initNomenclatureActivity(): void
    {
        $this->output->writeln(
            [
                "----------------------",
                "Activity initialisation"
            ]
        );
        $activityFile = fopen("{$this->sqlDirectory}/fixture/naf_rev_2.csv", 'rb');

        // read header
        fgetcsv($activityFile, 0, ";");

        $sectionId = 0;
        while (false !== ($data = fgetcsv($activityFile, 0, ";"))) {
            $code = $data[1];
            if (empty($code)) {
                continue;
            }
            if (0 === strpos($code, "SECTION")) {
                // create new section
                $code = trim($data[1]);
                $name = str_replace(["'", "\""], "''", trim($data[2]));
                $sectionId = $this->databaseService->query(
                    "INSERT INTO nomenclature_activity_section (code, name_naf2, updated_by)
VALUES ('$code', 'fr => \"$name\"'::hstore, 0) RETURNING id;"
                )->fetch(PDO::FETCH_COLUMN);
                continue;
            }
            $code = trim($data[1]);
            $parentCode = trim(substr($code, 0, -1), ".");
            $parentId = $this->activityIds[$parentCode] ?? "null";
            $name = str_replace(["'", "\""], "''", trim($data[2]));
            $id = $this->databaseService->query(
                "INSERT INTO nomenclature_activity (code, name_ref2, parent_activity_id, section_id, updated_by) 
VALUES ('$code', 'fr => \"$name\"'::hstore, $parentId, $sectionId, 0) RETURNING code, id;"
            )->fetch();
            $this->activityIds[$id["code"]] = $id["id"];
        }
        $this->output->writeln(
            [
                count($this->activityIds) . " activities saved",
            ]
        );
    }

    /**
     * Read rome from ROME_ArboPrincipale.csv file and complete $this->romeIds with rome ids indexed by code
     */
    private function initNomenclatureRome(): void
    {
        $this->output->writeln(
            [
                "-------------------",
                "ROME initialisation"
            ]
        );
        try {
            $linkFile = fopen("{$this->sqlDirectory}/fixture/ROME_ArboPrincipale.csv", 'rb');

            // read header
            fgetcsv($linkFile, 0, ";");

            $mainDomainId = null;
            $professionalId = null;
            $romeValues = [];
            $count = 0;
            while (false !== ($data = fgetcsv($linkFile, 0, ";"))) {
                if (empty($data[1]) || " " === $data[1]) {
                    // create new main domain
                    $code = $data[0];
                    $name = str_replace(["'", "\""], "''", trim($data[3]));
                    $mainDomainId = $this->databaseService->query(
                        "INSERT INTO nomenclature_rome_main_domain (code, name, updated_by)
    VALUES ('$code', 'fr => \"$name\"'::hstore, 0) RETURNING id;"
                    )->fetch(PDO::FETCH_COLUMN);
                    continue;
                }
                if (empty($data[2]) || " " === $data[2]) {
                    // create new professional domain
                    $code = "$data[0]$data[1]";
                    $name = str_replace(["'", "\""], "''", trim($data[3]));
                    $professionalId = $this->databaseService->query(
                        "INSERT INTO nomenclature_rome_professional_domain (code, main_domaine_id, name, updated_by)
    VALUES ('$code', $mainDomainId, 'fr => \"$name\"'::hstore, 0) RETURNING id;"
                    )->fetch(PDO::FETCH_COLUMN);
                    continue;
                }
                // create new ROME
                $count++;
                $code = "$data[0]$data[1]$data[2]";
                $ogr = (empty($data[4]) || " " === $data[4]) ? "null" : "'$data[4]'";
                $name = str_replace(["'", "\""], "''", trim($data[3]));
                $romeValues[] = "('$code', 'fr => \"$name\"'::hstore, $ogr, $professionalId, 0)";
            }
            $romeValues = implode(',', $romeValues);
            $this->databaseService->exec(
                "INSERT INTO nomenclature_rome (code, name, ogr, professional_domain_id , updated_by)
    VALUES $romeValues;"
            );
            $this->output->writeln(
                [
                    "$count ROME saved",
                ]
            );
        } catch (Exception $ex) {
            $this->logger->error($ex->getMessage());
        }
    }

    /**
     * Read link activity and rome from Naf2008_ROME_V.csv
     */
    private function initLinkActivityRome(): void
    {
        $this->output->writeln(
            [
                "-------------------",
                "ROME initialisation"
            ]
        );
        try {
            $linkFile = fopen("{$this->sqlDirectory}/fixture/rome_naf.csv", 'rb');

            // read header
            fgetcsv($linkFile, 0, ";");

            $linkValues = [];
            $inserts = [];
            while (false !== ($data = fgetcsv($linkFile, 0, ","))) {
                [$romeCode, , $activityCodeTMP, , $nbEmbauches] = $data;
                $activityCode = substr($activityCodeTMP, 0, 2) . '.' . substr($activityCodeTMP, 2);
                if (!array_key_exists($activityCode, $linkValues)) {
                    $linkValues[$activityCode] = [
                        'rome' => [],
                        'embauches' => 0
                    ];
                }
                $linkValues[$activityCode]['rome'][] = [$romeCode, $nbEmbauches];
                $linkValues[$activityCode]['embauches'] += $nbEmbauches;
            }

            foreach ($linkValues as $code => $values) {
                foreach ($values['rome'] as $romeValues) {
                    $romeCode = $romeValues[0];
                    $coeff = $romeValues[1] / $values['embauches'];
                    $inserts[] = "('$code', '$romeCode', $coeff,0)";
                }
            }

            $count = count($inserts);
            $insertsValues = implode(',', $inserts);
            $this->databaseService->exec(
                "INSERT INTO nomenclature_link_activity_rome (activity_naf_code, rome_code, factor, updated_by) 
    VALUES $insertsValues;"
            );
            $this->output->writeln(
                [
                    "$count link saved",
                ]
            );
        } catch (Exception $ex) {
            $this->logger->error($ex->getMessage());
        }
    }
}
