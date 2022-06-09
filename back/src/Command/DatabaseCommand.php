<?php

namespace App\Command;

use App\Service\DatabaseService;
use Psr\Log\LoggerInterface;
use Symfony\Component\Console\Command\Command;

/**
 * Base class for application commands.
 */
abstract class DatabaseCommand extends Command
{
    /**
     * Database service.
     */
    protected DatabaseService $databaseService;

    /**
     * @required
     */
    public function setDatabaseService(DatabaseService $databaseService): void
    {
        $this->databaseService = $databaseService;
    }

    /**
     * Logger service.
     */
    protected LoggerInterface $logger;

    /**
     * @required
     */
    public function setLogger(LoggerInterface $logger): void
    {
        $this->logger = $logger;
    }

    /**
     * SQL scripts directory.
     */
    protected string $sqlDirectory;

    public function setSqlDirectory(string $sqlDirectory): void
    {
        $this->sqlDirectory = $sqlDirectory;
    }
}
