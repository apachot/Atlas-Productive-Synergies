<?php


namespace App\Command;

use App\Exception\DatabaseException;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Command to create database scheme
 */
class DatabaseCreateCommand extends DatabaseCommand
{
    protected static $defaultName = "app:database:create";

    /**
     * @inheritDoc
     */
    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $sql = file_get_contents("{$this->sqlDirectory}/init/create_database.sql");

        try {
            $this->databaseService->exec($sql);
        } catch (DatabaseException $ex){
            $this->logger->error($ex->getMessage());
            $output->writeln(["Error in database creation", $ex->getMessage()]);
            return -1;
        }
        $output->writeln("Database create");
        return 0;
    }
}
