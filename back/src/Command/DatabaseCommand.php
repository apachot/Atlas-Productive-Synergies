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
