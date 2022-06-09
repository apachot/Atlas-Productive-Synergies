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

namespace App\Service;

use App\Entity\AbstractEntity;
use App\Exception\DatabaseException;
use App\Repository\EntityRepository;
use JsonException;
use PDO;
use RuntimeException;

/**
 * Database service, override @see PDO
 */
class DatabaseService extends PDO
{
    private array $entityDefinition;
    private array $establishmentPartition;
    private array $repositoryList;

    /**
     * @inheritDoc
     */
    public function __construct($dsn, $username = null, $passwd = null, $options = null)
    {
        parent::__construct($dsn, $username, $passwd, $options);
        $this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $this->repositoryList = [];
    }

    /**
     * Convert string from Postgresql database in hstore format to php array
     * @param string $value
     * @return array
     */
    public static function convertHstoreFromPg(string $value): array
    {
        $arrayValue = explode('", "', trim($value, "\""));
        $return = [];
        foreach ($arrayValue as $data) {
            $tmp = explode('"=>"', trim($data, "\""));
            $return[trim($tmp[0])] = trim($tmp[1], "\"");
        }
        return $return;
    }

    /**
     * Convert string from Postgresql database in json format to php array
     * @param string $value
     * @return array
     */
    public static function convertJsonFromPg(string $value): array
    {
        if (empty($value)) {
            return [];
        }

        try {
            $arrayValue = json_decode($value, true, 512, JSON_THROW_ON_ERROR);
        } catch (JsonException $ex) {
            throw new RuntimeException(
                sprintf('error converting json to array from pg : %s', $ex->getMessage()),
                0,
                $ex
            );
        }

        return $arrayValue;
    }

    /**
     * Convert string from Postgresql database in array format to php array
     * @param string $value
     * @return array
     */
    public static function convertArrayFromPg(string $value): array
    {
        return explode(",", trim($value, "(){}"));
    }

    /**
     * Convert php array in string for hstore Postgresql database
     * @param array $value
     * @return string
     */
    public static function convertHstoreToPg(array $value): string
    {
        $result = [];
        foreach ($value as $lang => $val) {
            $val = str_replace(["'", "\""], "''", trim($val));
            $result[] = "$lang => \"$val\"";
        }
        $result = implode(",", $result);
        return "'$result'::hstore";
    }

    /**
     * escape string
     *
     * @param string $val
     * @return string
     */
    public static function escape(string $val): string
    {
        return str_replace("'", "''", $val);
    }

    /**
     * @param     $value
     * @param int $format
     *
     * @return string
     */
    public static  function sqlIn($value, $format = \PDO::PARAM_STR): string
    {
        if (is_string($value)) {
            $value = explode(',', $value);
        }

        if ($format === \PDO::PARAM_STR) {
            $value = array_map(
                static function($val) { return DatabaseService::escape($val); },
                $value
            );
            return "'" . implode("','", $value) . "'";
        }

        return implode(",", $value);
    }

    /**
     * @param $value
     *
     * @return string|null
     */
    public static  function sqlLike($value): ?string
    {
        if (! is_string($value)) {
            return null;
        }

        $clean = DatabaseService::escape($value);

        return '%' . $clean . '%';
    }

    /**
     * Create new entity by entity name
     * @param string $entityName
     * @param array  $value
     * @return \App\Entity\AbstractEntity
     */
    public function createEntity(string $entityName, array $value): AbstractEntity
    {
        $definition = $this->entityDefinition[$entityName];
        $className = $definition["className"];

        return new $className($value);
    }

    /**
     * Return repository for specify entity
     * @param string $entityName
     * @return \App\Repository\EntityRepository
     */
    public function getRepository(string $entityName): EntityRepository
    {
        $repositoryClassName = $this->entityDefinition[$entityName]["repository"];

        if (!isset($this->repositoryList[$repositoryClassName])) {
            $this->repositoryList[$repositoryClassName] = (new $repositoryClassName())
                ->setDatabaseService($this)
                ->setEntityName($entityName);

        }

        return $this->repositoryList[$repositoryClassName];
    }

    // PDO methods
    // -----------

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     */
    public function query($statement, $mode = PDO::ATTR_DEFAULT_FETCH_MODE, $arg3 = null, array $ctorargs = array())
    {
        if (false !== ($result = parent::query($statement))) {
            return $result;
        }

        throw new DatabaseException($this->errorInfo()[2]);
    }

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     */
    public function exec($statement)
    {
        if (false !== ($result = parent::exec($statement))) {
            return $result;
        }

        throw new DatabaseException($this->errorInfo()[2]);
    }

    // Utility methods
    // -----------

    /**
     * get a list of department for a region
     *
     * @param array|string[]|string $regions list of region code
     *
     * @return array|string[] list of department codes
     */
    public function getDepartmentsForRegion($regions): array
    {
        $departments = [];
        if (is_string($regions)) {
            $regions = [$regions];
        }

        foreach ($regions as $region) {
            if (array_key_exists($region, $this->establishmentPartition['region'])) {
                $departments = array_merge(
                    $departments,
                    $this->establishmentPartition['region'][$region]
                );
            }
        }

        return array_values($departments);

    }

    /**
     * get a list of department for industry territories
     *
     * @param array|string[]|string $tis list of industry territories code
     *
     * @return array|string[] list of department codes
     */
    public function getDepartmentsForTi($tis): array
    {
        $departments = [];
        if (is_string($tis)) {
            $tis = [$tis];
        }

        foreach ($tis as $ti) {
            if (array_key_exists($ti, $this->establishmentPartition['industryTerritory'])) {
                $departments =
                    $departments +
                    array_flip($this->establishmentPartition['industryTerritory'][$ti])
                ;
            }
        }

        return array_keys($departments);

    }

    // System accessors
    // ----------------

    /**
     * @return array
     */
    public function getEstablishmentPartition(): array
    {
        return $this->establishmentPartition;
    }

    /**
     * @param array $establishmentPartition
     * @return $this
     */
    public function setEstablishmentPartition(array $establishmentPartition): self
    {
        $this->establishmentPartition = $establishmentPartition;
        return $this;
    }

    /**
     * @param array $entityDefinition
     * @return $this
     */
    public function setEntityDefinition(array $entityDefinition): self
    {
        $this->entityDefinition = $entityDefinition;
        return $this;
    }
}
