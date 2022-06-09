<?php


namespace App\Command;

use PDO;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Command to create fake data for recommendations
 */
class FakerRecommendationCommand extends DatabaseCommand
{
    protected static $defaultName = "app:faker:recommendation";

    private array $departmentCodes = [];

    protected function configure(): void
    {
        $this->addArgument("department", InputArgument::OPTIONAL|InputArgument::IS_ARRAY);
        $this->addOption("clean", null, InputOption::VALUE_NONE,
            'Clean all fake recommendations <info> in all departments.</info>' );
    }

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $optionClean = $input->getOption('clean');
        if (true === $optionClean) {
            $this->cleanFakeData($output);
            return 0;
        }

        $departmentInput = $input->getArgument("department");
        if (!empty($departmentInput)) {
            $this->departmentCodes = $departmentInput;
        } else {
            $this->departmentCodes = $this->databaseService
                ->query("SELECT code FROM nomenclature_activity;")
                ->fetchAll(PDO::FETCH_COLUMN, 0);
        }

        $this->processCustomerSupplierFaker($output);

        return 0;
    }

    /**
     * @param \Symfony\Component\Console\Output\OutputInterface $output
     *
     * @throws \App\Exception\DatabaseException
     */
    protected function cleanFakeData(OutputInterface $output): void
    {
        $this->databaseService->exec(
            "delete from recommendation where fake = true;"
        );
        $output->writeln("Fake recommendations have been removed.");
    }

    /**
     * Create fake client/supplier recommendation for all establishment in specific sector
     *
     * @throws \App\Exception\DatabaseException
     */
    protected function processCustomerSupplierFaker(OutputInterface $output): void
    {
        $insertSql = "
    INSERT INTO recommendation (type, establishment_id, data, fake, updated_by)
    VALUES (:type, :eId, :data, true, 0)";

        foreach ($this->departmentCodes as $departmentCode) {
            // retrieve list of establishment available
            $statement = $this->databaseService->prepare("
SELECT et.id,
       et.siret,
       array_agg(product.id) as products
FROM establishment et
       INNER JOIN nomenclature_activity activity ON et.main_activity_id = activity.id
       INNER JOIN address ON et.address_id = address.id
       INNER JOIN city ON address.city_id = city.id
       INNER JOIN department ON city.department_id = department.id
       INNER JOIN product ON product.establishment_id = et.id
WHERE activity.section_id IN (1, 2, 3, 4, 5)
  AND activity.macro_sector_id IS NOT NULL
  AND address.coordinates IS NOT NULL
  AND department.code = :departmentCode
  AND ( et.workforce_group IS NOT NULL )
GROUP BY et.id, et.siret;
");
            $statement->setFetchMode(PDO::FETCH_ASSOC);
            $statement->bindParam(":departmentCode", $departmentCode, PDO::PARAM_STR);
            $statement->execute();
            $establishmentList = $statement->fetchAll();

            $output->writeln(
                sprintf(
                    "Fake recommendations for department %s : %s establishments.",
                    $departmentCode,
                    count($establishmentList)
                )
            );

            foreach ($establishmentList as $establishment) {
                foreach (['CUSTOMER', 'SUPPLIER'] as $type) {
                    $productList = explode(',', trim($establishment['products'], '{}'));
                    $iaEstab = [];
                    foreach ($productList as $product) {
                        // ~ only 1 product by 4
                        if (random_int(0, 3) !== 0) {
                            continue;
                        }
                        $randCount = random_int(1, 3);
                        $randKeys = array_rand($establishmentList, $randCount);
                        if (!is_array($randKeys)) {
                            $randKeys = [$randKeys];
                        }
                        $iaProduct = [
                            'product' => $product,
                            'establishments' => []
                        ];
                        foreach ($randKeys as $randKey) {
                            if ($establishmentList[$randKey]['id'] === $establishment['id']) {
                                continue;
                            }
                            $iaProduct['establishments'][] = $establishmentList[$randKey]['siret'];
                        }
                        if (count($iaProduct['establishments']) > 0) {
                            $iaEstab[] = $iaProduct;
                        }
                    }

                    if (count($iaEstab) === 0) {
                        continue;
                    }

                    $statement = $this->databaseService->prepare($insertSql);
                    $statement->bindParam(":type", $type, PDO::PARAM_INT);
                    $statement->bindParam(":eId", $establishment['id'], PDO::PARAM_INT);
                    $jsonData = json_encode($iaEstab, JSON_THROW_ON_ERROR);
                    $statement->bindParam(":data", $jsonData, PDO::PARAM_STR);
                    if (false === $statement->execute()) {
                        $info = $statement->errorInfo();
                        throw new \Exception($statement->errorCode());
                    }
                }
            }

        }
    }
}
