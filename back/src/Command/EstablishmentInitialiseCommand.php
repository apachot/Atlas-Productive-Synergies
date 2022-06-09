<?php


namespace App\Command;

use Exception;
use PDO;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Filesystem\Filesystem;
use Symfony\Component\String\Slugger\AsciiSlugger;
use Symfony\Component\String\Slugger\SluggerInterface;
use Symfony\Contracts\HttpClient\HttpClientInterface;

/**
 * Command to initialise establishment, download from http://data.cquest.org/geo_sirene/v2019/last/dep/
 * department by department, these files contains geo location
 */
class EstablishmentInitialiseCommand extends DatabaseCommand
{
    protected static $defaultName = "app:establishment:initialise";

    private static array $filesNumber =
        ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15",
        "16","17","18","19","21","22","23","24","25","26","27","28","29","2A","2B","30","31","32","33","34","35","36",
        "37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58",
        "59","60","61","62", "63", "64","65","66","67","68","69","70","71","72","73","74","75101","75102","75103",
        "75104","75105","75106","75107","75108","75109","75110","75111","75112","75113","75114","75115","75116","75117",
        "75118","75119","75120","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92",
        "93","94","95","971","972","973","974","975","976","977","978","98"];

    private Filesystem $fileSystem;
    private HttpClientInterface $httpClient;
    private OutputInterface $output;
    private SluggerInterface $slugger;

    private array $cityIds;
    private array $activityIds;
    private array $activityIdsKept;

    protected function configure(): void
    {
        $this->addArgument("department", InputArgument::OPTIONAL|InputArgument::IS_ARRAY);
    }

    /**
     * @inheritDoc
     * @param \Symfony\Component\Console\Input\InputInterface   $input
     * @param \Symfony\Component\Console\Output\OutputInterface $output
     * @throws \App\Exception\DatabaseException
     */
    protected function initialize(InputInterface $input, OutputInterface $output): void
    {
        $this->slugger = new AsciiSlugger('fr');

        $this->cityIds = $this->databaseService
            ->query("SELECT insee_code, id FROM city;")
            ->fetchAll(PDO::FETCH_KEY_PAIR);

        $this->activityIds = $this->databaseService
            ->query("SELECT code, id FROM nomenclature_activity;")
            ->fetchAll(PDO::FETCH_KEY_PAIR);

        $this->activityIdsKept = $this->databaseService
            ->query("select distinct activity_naf2, 1 as value
from nomenclature_activity_product_proximity")
            ->fetchAll(PDO::FETCH_KEY_PAIR);
    }

    /**
     * @inheritDoc
     * @param \Symfony\Component\Console\Input\InputInterface   $input
     * @param \Symfony\Component\Console\Output\OutputInterface $output
     * @return int
     * @throws \Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface
     * @throws \App\Exception\DatabaseException
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $output->writeln([
            "----------------------------",
            "Establishment initialisation"
        ]);
        $departmentInput = $input->getArgument("department");
        if (!empty($departmentInput)) {
            self::$filesNumber = $departmentInput;
        }

        $this->output = $output;

        foreach (self::$filesNumber as $fileNumber) {
            $output->writeln("Process department $fileNumber");
            $this->downloadFile($fileNumber);
            /** @noinspection DisconnectedForeachInstructionInspection */
            $output->writeln("File download");
            $this->processFile($fileNumber);
            /** @noinspection DisconnectedForeachInstructionInspection */
            $output->writeln("Terminate");
        }
        $this->output->writeln("Finalise empty company link");
        $this->databaseService->exec("
UPDATE establishment
SET company_id = company.id
FROM company
WHERE company_id IS NULL
AND company.siren = substring(siret from 1 for 9);");

        return 0;
    }

    /**
     * Read download file for department and create establishment.
     *
     * @param string $partitionCode
     * @throws \App\Exception\DatabaseException
     */
    protected function processFile(string $partitionCode): void
    {
        $establishmentFile = gzopen("{$this->sqlDirectory}/fixture/geo_siret.gz", 'rb');

        // read header
        fgetcsv($establishmentFile, 0, ",");

        $count = 0;
        $line = 0;
        $establishmentValues = [];
        $companyValues = [];
        $addressValues = [];
        $strBool = [
            "O" => "true",
            "F" => "false",
            "N" => "false",
        ];
        while (false !== ($data = fgetcsv($establishmentFile, 0, ","))) {
            $line++;
            try {
                if ($this->skipEstablishment($data)) {
                    $this->logger->debug("Skip establishment", ['code' => $partitionCode, 'line' => $line]);
                    continue;
                }

                $siret = "'$data[2]'";

                // address
                $uniqueKey = substr(uniqid($partitionCode, true), 0, 23);
                //echo($uniqueKey."\n");
                $zipCode = str_pad($data[16], 5, "0", STR_PAD_LEFT);
                $cityName = str_replace(["'", "\""], "''", trim($data[17]));
                $codeInsee = trim($data[20]);
                if (!isset($this->cityIds[$codeInsee])) {
                    $slug = $this->slugger->slug($data[17])->lower()->toString();
                    $city = $this->databaseService
                        ->query(
                            "INSERT INTO city (insee_code, name, slug, zip_code, updated_by)
        VALUES ('$codeInsee', 'fr => \"$cityName\"'::hstore, '$slug', '$zipCode', 0) RETURNING id;"
                        )->fetch(PDO::FETCH_UNIQUE);
                    $this->cityIds[$codeInsee] = $city['id'];

                }
                $cityId = $this->cityIds[$data[20]];
                $cedex = $data[21] ?? "null";
                $cedexLabel = !empty($data[22]) ? "'" . str_replace(["'", "\""], "''", trim($data[22])) . "'" : "null";
                $complement = !empty($data[11]) ? "'" . str_replace(["'", "\""], "''", trim($data[11])) . "'" : "null";
                $coordinates = !empty($data[49]) ? "'{$data[49]}, {$data[48]}'::point" : "null";
                $repetitionIndex = !empty($data[13]) ? "'" . str_replace(["'", "\""], "''", trim($data[13])) . "'" : "null";
                $specialDistribution = !empty($data[19]) ? "'" . str_replace(["'", "\""], "''", trim($data[19])) . "'" : "null";
                $wayLabel = !empty($data[15]) ? "'" . str_replace(["'", "\""], "''", trim($data[15])) . "'" : "null";
                $wayNumber = !empty($data[12]) ? "'" . str_replace(["'", "\""], "''", trim($data[12])) . "'" : "null";
                $wayType = !empty($data[14]) ? "'" . str_replace(["'", "\""], "''", substr(trim($data[14]),0, 20)) . "'" : "null";
                $yVal = "'1'";
                $zVal = "'$uniqueKey'";
                if (empty($cityId)) {
                    $this->logger->error("missing city", ["siret" => $data[2], "siren" => $data[0], "city" => $data[20]]);
                    continue;
                }
                $addressValues[] = "($cityId, '$cedex', $cedexLabel, $complement, $coordinates, $repetitionIndex, $specialDistribution, $wayLabel, $wayNumber, $wayType, $yVal, $zVal, 0)";

                // address 2
                $address2Id = "null";
                if (!empty($data[34]) && isset($this->cityIds[$data[34]])) {
                    $cityId = $this->cityIds[$data[34]];
                    $cedex = $data[35] ?? "null";
                    $cedexLabel = !empty($data[36]) ? "'" . str_replace(["'", "\""], "''", trim($data[36])) . "'" : "null";
                    $complement = !empty($data[25]) ? "'" . str_replace(["'", "\""], "''", trim($data[25])) . "'" : "null";
                    $coordinates = "null"; // @todo recup d'une api
                    $repetitionIndex = !empty($data[27]) ? "'{$data[27]}'" : "null";
                    $specialDistribution = !empty($data[33]) ? "'" . str_replace(["'", "\""], "''", trim($data[33])) . "'" : "null";
                    $wayLabel = !empty($data[29]) ? "'" . str_replace(["'", "\""], "''", trim($data[29])) . "'" : "null";
                    $wayNumber = !empty($data[26]) ? "'" . str_replace(["'", "\""], "''", trim($data[26])) . "'" : "null";
                    $wayType = !empty($data[28]) ? "'" . str_replace(["'", "\""], "''", substr(trim($data[28]),0, 20)) . "'" : "null";
                    $yVal = "'2'";
                    $zVal = "'$uniqueKey'";

                    $addressValues[] = "($cityId, '$cedex', $cedexLabel, $complement, $coordinates, $repetitionIndex, $specialDistribution, $wayLabel, $wayNumber, $wayType, $yVal, $zVal, 0)";
                }

                if ("NAFRev2" !== $data[46]) {
                    $mainActivityId = "null";
                    // logger
                } else {
                    $mainActivityId = $this->activityIds[$data[45]] ?? "null";
                }

                $administrativeStatus = "true";
                $creationDate = !empty($data[4]) ? "'$data[4]'" : "null";
                $employerNature = !empty($data[47]) ? $strBool[$data[47]] : "null";
                $diffusionStatus = !empty($data[3]) ? $strBool[$data[3]] : "null";
                $historyStatusNumber = !empty($data[10]) ? "'$data[10]'" : "null";
                $historyStartDate = !empty($data[39]) ? "'$data[39]'" : "null";
                $nic = !empty($data[1]) ? "'$data[1]'" : "null";
                $sirenUpdateDate = !empty($data[8]) ? "'$data[8]'" : "null";

                $workforceGroup = !empty($data[5]) ? "'$data[5]'" : "null";
                $workforceYear = !empty($data[6]) ? "'$data[6]'" : "null";
                $label1 = str_replace(["'", "\""], "''", trim($data[41]));
                $label1 = !empty($data[41]) ? "'fr => \"$label1\"'::hstore" : "null";
                $label2 = str_replace(["'", "\""], "''", trim($data[42]));
                $label2 = !empty($data[42]) ? "'fr => \"$label2\"'::hstore" : "null";
                $label3 = str_replace(["'", "\""], "''", trim($data[43]));
                $label3 = !empty($data[43]) ? "'fr => \"$label3\"'::hstore" : "null";
                $usualName = str_replace(["'", "\""], "''", trim($data[41]));
                $usualName = !empty($usualName) ? "'$usualName'" : "null";
                $siege = "true" === $data[9] ? "'true'" : "'false'";
                $companyName = $usualName;

                $establishmentValues[] = "($administrativeStatus, null, $creationDate, $employerNature, $diffusionStatus, $historyStatusNumber, $historyStartDate, $label1, $label2, $label3, $mainActivityId, $nic, $address2Id, $siege, $sirenUpdateDate, $siret, $usualName, $workforceGroup, $workforceYear, $zVal, 0)";

                if ("true" === $data[9]) {
                    $companyValues[] = "($companyName, '$data[0]', $zVal, 0)";
                }

                $count++;
                if (0 === $count % 1000) {
                    $this->output->writeln("execute request");
                    if (!empty($establishmentValues)) {
                        $establishmentValuesPart = implode(",", $establishmentValues);
                        $this->databaseService->exec("
INSERT INTO establishment (administrative_status, company_id, creation_date, employer_nature, diffusion_status, history_status_number, history_start_date, label_1, label_2, label_3, main_activity_id, nic, secondary_address_id, siege, sirene_updated_date, siret, usual_name, workforce_group, workforce_year, z_val, updated_by)
VALUES $establishmentValuesPart RETURNING siret, id;");
                        $establishmentValues = [];
                        $establishmentValuesPart = null;
                    }
                    if (!empty($companyValues)) {
                        $companyValuesPart = implode(",", $companyValues);
                        $this->databaseService->exec("
INSERT INTO company (name, siren, z_val, updated_by)
VALUES $companyValuesPart RETURNING siren, id;");
                        $companyValues = [];
                        $companyValuesPart = null;
                    }
                    if (!empty($addressValues)) {
                        $addressValuesPart = implode(",", $addressValues);
                        $this->databaseService->exec("
INSERT INTO address(city_id, cedex, cedex_label, complement, coordinates, repetition_index, special_distribution, way_label, way_number, way_type, y_val, z_val, updated_by)
VALUES $addressValuesPart RETURNING id, z_val;");
                        $addressValues = [];
                        $addressValuesPart = null;
                    }
                    $this->output->writeln("Process $count");
                }
            } catch (Exception $ex) {
                $this->output->writeln($ex->getTraceAsString());
                throw $ex;
            }
        }

        gzclose($establishmentFile);
        unset($establishmentFile);
        $this->fileSystem->remove("{$this->sqlDirectory}/fixture/geo_siret.gz");

        if (!empty($establishmentValues)) {
            $establishmentValuesPart = implode(",", $establishmentValues);
            $this->databaseService->exec(
                "INSERT INTO establishment (administrative_status, company_id, creation_date, employer_nature, diffusion_status, history_status_number, history_start_date, label_1, label_2, label_3, main_activity_id, nic, secondary_address_id, siege, sirene_updated_date, siret, usual_name, workforce_group, workforce_year, z_val, updated_by)
VALUES $establishmentValuesPart;"
            );
            unset($establishmentValues, $establishmentValuesPart);
        }
        if (!empty($companyValues)) {
            $companyValuesPart = implode(",", $companyValues);
            $this->databaseService->exec(
                "INSERT INTO company (name, siren, z_val, updated_by)
VALUES $companyValuesPart;"
            );
            unset($companyValuesPart, $companyValues);
        }
        if (!empty($addressValues)) {
            $addressValuesPart = implode(",", $addressValues);
            $this->databaseService->exec("
INSERT INTO address(city_id, cedex, cedex_label, complement, coordinates, repetition_index, special_distribution, way_label, way_number, way_type, y_val, z_val, updated_by)
VALUES $addressValuesPart;"
            );
            unset($addressValues, $request);
        }
        gc_collect_cycles();
        // complete address
        $this->output->writeln("Finalise address link");
        $this->databaseService->exec("
UPDATE establishment
SET address_id = address.id
FROM address
WHERE address_id is NULL 
AND y_val = '1'
AND establishment.z_val = address.z_val;"
        );
        gc_collect_cycles();
        $this->output->writeln("Finalise address 2 link");
        $this->databaseService->exec("
UPDATE establishment
SET secondary_address_id = address.id
FROM address
WHERE secondary_address_id is NULL 
AND address.y_val = '2'
AND establishment.z_val = address.z_val;"
        );
        gc_collect_cycles();

        $this->output->writeln("Finalise company address link");
        $this->databaseService->exec("
UPDATE company
SET address_id = address.id
FROM address
WHERE address_id is NULL 
AND address.y_val = '2'
AND company.z_val = address.z_val;"
        );
        gc_collect_cycles();

        // complete company id
        $this->output->writeln("Finalise company establishment link");
        $this->databaseService->exec("
UPDATE establishment
SET company_id = company.id
FROM company
WHERE company_id is null
AND company.siren = substring(siret from 1 for 9);"
        );
    }


    /**
     * @param $data
     *
     * @return bool
     */
    private function skipEstablishment($data): bool
    {
        // siret
        if (empty($data[2])) {
            return true;
        }

        // code insee
        if (empty($data[20])) {
            return true;
        }

        // coordinates
        if (empty($data[49])) {
            return true;
        }

        // No workforce Group
        if (empty($data[5])) {
            return true;
        }

        // bad APE
        if ("NAFRev2" !== $data[46]) {
            return true;
        }
        if (!isset($this->activityIdsKept[$data[45]])) {
            return true;
        }

        return false;
    }

    /**
     * Download file for specific number departmen
     * @param string $fileNumber
     * @throws \Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface
     */
    private function downloadFile(string $fileNumber): void
    {
        $url = "http://data.cquest.org/geo_sirene/v2019/last/dep/geo_siret_$fileNumber.csv.gz";
        $response = $this->httpClient->request("GET", $url);
        $fileHandler = fopen("{$this->sqlDirectory}/fixture/geo_siret.gz", 'wb');
        foreach ($this->httpClient->stream($response) as $chunk) {
            fwrite($fileHandler, $chunk->getContent());
        }
    }



    // System accessors
    // ----------------

    /**
     * @param \Symfony\Component\Filesystem\Filesystem $fileSystem
     * @return $this
     * @required
     */
    public function setFileSystem(Filesystem $fileSystem): self
    {
        $this->fileSystem = $fileSystem;
        return $this;
    }

    /**
     * @param \Symfony\Contracts\HttpClient\HttpClientInterface $httpClient
     * @return $this
     * @required
     */
    public function setHttpClient(HttpClientInterface $httpClient): self
    {
        $this->httpClient = $httpClient;
        return $this;
    }
}
