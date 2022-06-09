<?php


namespace App\EntityVue;

use App\Entity\AbstractEntity;
use App\Service\DatabaseService;
use DateTime;

/**
 * Abstract class for all vue
 */
abstract class AbstractVue
{
    public array $container = [];

    /**
     * @param $value
     * @throws \Exception
     */
    public function __construct($value)
    {
        $definition = $this->getDefinition();
        $this->container = $this->convertAll($value, $definition);
    }

    /**
     * Convert all data
     * @param array $value
     * @param array $definition
     * @return array
     * @throws \Exception
     */
    protected function convertAll(array $value, array $definition): array
    {
        if ("array" === $definition["type"]) {
            return $this->convertAllArray($value, $definition);
        }
        if ("indexed" === $definition["type"]) {
            $result = [];
            foreach ($value as $index => $subValue) {
                $result[$index] = $this->convertAllArray($subValue, $definition[$index]);
            }
            return $result;
        }
        return $this->convertEntity($value, $definition);
    }

    /**
     * Convert all data in array format
     * @param array $value
     * @param array $definition
     * @return array
     * @throws \Exception
     */
    protected function convertAllArray(array $value, array $definition): array
    {
        $result = [];
        foreach ($value as $data) {
            $newValue = $this->convertEntity($data, $definition);
            if (array_key_exists("index", $definition)) {
                $result[$newValue[$definition["index"]]] = $newValue;
            } else {
                $result[] = $newValue;
            }
        }
        return $result;
    }

    /**
     * Convert one entity
     * @param array $value
     * @param array $vueDefinition
     * @return array
     * @throws \Exception
     */
    protected function convertEntity(array $value, array $vueDefinition): array
    {
        $result = [];
        $entityDef = $vueDefinition["className"]::getEntityDefinition();
        // convert AbstractEntity
        $abstractDefinition = AbstractEntity::abstractEntityDefinition();
        foreach ($abstractDefinition as $name => $definition) {
            if (!array_key_exists($name, $value)) {
                continue;
            }
            $result[$name] = $this->convertValue($value[$name], $definition);
            unset($value[$name]);
        }
        // convert entity
        foreach ($value as $name => $data) {
            if (!array_key_exists($name, $entityDef)) {
                if (
                    array_key_exists("specificProperty", $vueDefinition)
                    && array_key_exists($name, $vueDefinition["specificProperty"])
                ) {
                    $definition = $vueDefinition["specificProperty"][$name];
                    $result[$name] = $this->convertValue($data, $definition);
                    continue;
                }

                // case array_agg
                $subDefinition = $vueDefinition["subProperty"][$name];
                if ("array_agg" === $subDefinition["type"]) {
                    if (!is_array($data)) {
                        $data = explode("\",\"", trim($data, "{}"));
                    }
                    $subEntity = [];
                    foreach ($data as $datum) {
                        // simple array
                        if (array_key_exists("subType", $subDefinition)) {
                            $subEntity[] = $this->convertValue($datum, $subDefinition['subType']);
                        } else {
                            $value = $this->convertSubEntity($datum, $subDefinition);
                            if (array_key_exists("index", $subDefinition)) {
                                $subEntity[$value[$subDefinition["index"]]] = $value;
                            } else {
                                $subEntity[] = $value;
                            }
                        }
                    }
                    $result[$name] = $subEntity;
                    continue;
                }
                // cas array classic
                $subProperty = [];
                if (!is_array($data)) {
                    $data = explode("\",\"", trim($data, "{}"));
                }
                foreach ($data as $datum) {
                    $tmp = [];
                    $datum = is_array($datum) ? $datum : explode(";;", trim($datum, '\"'));
                    foreach ($datum as $subName => $subValue) {
                        // just keep data specified in definition
                        if (array_key_exists($subName, $subDefinition["specificProperty"])) {
                            $tmp[$subName] = $this->convertValue($subValue, $subDefinition["specificProperty"][$subName]);
                        }
                    }
                    $subProperty[] = $tmp;
                }
                $result[$name] = $subProperty;
            } else {
                $result[$name] = $this->convertValue($data, $entityDef[$name]);
            }
        }

        return $result;
    }

    /**
     * Convert on sub entity
     * @param array|string $value
     * @param array  $definition
     * @return array
     * @throws \Exception
     */
    protected function convertSubEntity($value, array $definition): array
    {
        $result = [];
        $entityDefinition = array_merge(
            $definition["className"]::getEntityDefinition(),
            AbstractEntity::abstractEntityDefinition()
        );
        $valueArray = is_array($value) ? $value : explode(";;", trim($value, '"'));
        foreach ($valueArray as $index => $val) {
            $propertyName = $definition["property"][$index];
            if (array_key_exists($propertyName, $entityDefinition)) {
                $result[$propertyName] = $this->convertValue($val, $entityDefinition[$propertyName]);
            } else {
                $result[$propertyName] = $this->convertValue($val, $definition["specificType"][$propertyName]);
            }
        }
        return $result;
    }

    /**
     * Convert value from database in correct type for class
     * @param $value
     * @param $property
     * @return mixed
     * @throws \Exception
     */
    protected function convertValue($value, $property)
    {
        if (null === $value) {
            return null;
        }
        $value = trim($value, '\"\\');
        switch ($property["type"]) {
            case DateTime::class:
                $value = new DateTime($value);
                break;
            case "hstore":
                $value = str_replace('\"', '"', $value);
                $value = DatabaseService::convertHstoreFromPg($value);
                break;
            case "point":
                $value = DatabaseService::convertArrayFromPg($value);
                break;
        }
        return $value;
    }
}
