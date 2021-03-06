<?php


namespace App\Command;

use Exception;
use PDO;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Command to update database in good version, in accord with sql file in /sql/update
 */
class DatabaseManagementCommand extends DatabaseCommand
{
    protected static $defaultName = "app:database:update";

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $actualVersion = $this->readActualVersion();
        $updateFile = $this->readUpdateFile($actualVersion);

        if (empty($updateFile)) {
            $output->writeln("Database already up to date.");
            return 1;
        }
        try {
            foreach ($updateFile as $versionNumber) {
                $output->writeln("Execute file $versionNumber");
                $sql = file_get_contents("{$this->sqlDirectory}/update/$versionNumber");
                // for copy order
                $sql = str_replace('/srv/httpd/iat-api/sql', $this->sqlDirectory, $sql);
                $this->databaseService->exec($sql);
                $output->writeln("   Processed");
            }
            $this->updateDatabaseVersion($versionNumber);
        } catch (Exception $ex) {
            $this->logger->error($ex->getMessage());
            return -1;
        }

        return 0;
    }

    /**
     * Read actual database version
     * @return string
     * @throws \App\Exception\DatabaseException
     */
    private function readActualVersion(): string
    {
        return $this->databaseService
            ->query("SELECT app_value FROM app_config WHERE app_key = 'database_version';")
            ->fetch(PDO::FETCH_COLUMN);
    }

    /**
     * Return list of update file newer than actual version
     * @param string $actualVersion
     * @return array
     */
    private function readUpdateFile(string $actualVersion): array
    {
        $files = array_diff(scandir("{$this->sqlDirectory}/update"), [".", ".."]);
        usort($files, 'version_compare');
        $index = array_search("$actualVersion.sql", $files);
        return array_slice($files,  $index ? $index + 1 : 0);
    }

    /**
     * Update database version
     * @param string $version
     * @throws \App\Exception\DatabaseException
     */
    private function updateDatabaseVersion(string $version): void
    {
        $version = str_replace(".sql", "", $version);
        $this->databaseService->exec("UPDATE app_config SET app_value = '$version' WHERE app_key = 'database_version';");
    }
}
