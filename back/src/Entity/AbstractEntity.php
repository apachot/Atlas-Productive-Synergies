<?php


namespace App\Entity;

use App\Service\DatabaseService;
use DateTime;
use RuntimeException;
use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Abstract base class for all entity
 */
abstract class AbstractEntity
{
    public const ENTITY_NAME = "";

    /**
     * @Groups({"api"})
     */
    private int $id;
    /**
     * @Groups({"api"})
     */
    private DateTime $createdAt;
    /**
     * @Groups({"api"})
     */
    private DateTime $updatedAt;
    /**
     * @Groups({"api"})
     */
    private int $updatedBy;
    private DateTime $deletedAt;

    /**
     * @param array $values
     * @throws \Exception
     */
    public function __construct(array $values)
    {
        $this->hydrate($values);
    }

    /**
     * Hydrate this object with values.
     * @param array $values
     * @throws \Exception
     */
    public function hydrate(array $values): void
    {
        foreach (self::abstractEntityDefinition() as $propertyName => $property) {
            if (!array_key_exists($propertyName, $values)) {
                continue;
            }
            $value = $values[$propertyName];
            if (DateTime::class === $property["type"]) {
                $value = new DateTime($value);
            }
            $setter = "set" . ucfirst($property["name"]);
            $this->$setter($value);
            unset($values[$propertyName]);
        }
        $definition = $this::getEntityDefinition();
        foreach ($values as $propertyName => $value) {
            if (!array_key_exists($propertyName, $definition)) {
                throw new RuntimeException(
                    sprintf("%s does not exists in definition of %s", $propertyName, static::ENTITY_NAME)
                );
            }
            $property = $definition[$propertyName];
            $value = $this->convertValue($value, $property);
            $setter = "set" . ucfirst($property["name"]);
            $this->$setter($value);
        }
    }

    /**
     * Convert value from database in correct type for class
     * @param $value
     * @param $property
     * @return array|\DateTime
     * @throws \Exception
     */
    protected function convertValue($value, $property)
    {
        if (null === $value) {
            return null;
        }
        switch ($property["type"]) {
            case DateTime::class:
                $value = new DateTime($value);
                break;
            case "hstore":
                $value = DatabaseService::convertHstoreFromPg($value);
                break;
            case "json":
                $value = DatabaseService::convertJsonFromPg($value);
                break;
            case "point":
                $value = DatabaseService::convertArrayFromPg($value);
                break;
        }
        return $value;
    }

    /**
     * Return properties definition of abstract entity
     * @return array|array[]
     */
    final public static function abstractEntityDefinition(): array
    {
        return [
            "id" => [
                "isClass" => false,
                "name" => "id",
                "type" => "int",
            ],
            "created_at" => [
                "isClass" => false,
                "name" => "createdAt",
                "type" => DateTime::class,
            ],
            "updated_at" => [
                "isClass" => false,
                "name" => "updatedAt",
                "type" => DateTime::class,
            ],
            "updated_by" => [
                "isClass" => false,
                "name" => "updatedBy",
                "type" => "int",
            ],
            "deleted_at" => [
                "isClass" => false,
                "name" => "deletedAt",
                "type" => DateTime::class,
            ],
        ];
    }

    /**
     * Return enities's properties definition
     * @return array
     */
    abstract public static function getEntityDefinition(): array;

    // Accessors
    // ---------

    /**
     * @return int
     */
    public function getId(): int
    {
        return $this->id;
    }

    /**
     * @param int $id
     * @return $this
     */
    public function setId($id): self
    {
        $this->id = $id;
        return $this;
    }

    /**
     * @return \DateTime
     */
    public function getCreatedAt(): DateTime
    {
        return $this->createdAt;
    }

    /**
     * @param \DateTime $createdAt
     * @return $this
     */
    public function setCreatedAt($createdAt): self
    {
        $this->createdAt = $createdAt;
        return $this;
    }

    /**
     * @return \DateTime
     */
    public function getUpdatedAt(): DateTime
    {
        return $this->updatedAt;
    }

    /**
     * @param \DateTime $updatedAt
     * @return $this
     */
    public function setUpdatedAt($updatedAt): self
    {
        $this->updatedAt = $updatedAt;
        return $this;
    }

    /**
     * @return int
     */
    public function getUpdatedBy(): int
    {
        return $this->updatedBy;
    }

    /**
     * @param int $updatedBy
     * @return $this
     */
    public function setUpdatedBy($updatedBy): self
    {
        $this->updatedBy = $updatedBy;
        return $this;
    }

    /**
     * @return \DateTime
     */
    public function getDeletedAt(): DateTime
    {
        return $this->deletedAt;
    }

    /**
     * @param \DateTime $deletedAt
     * @return $this
     */
    public function setDeletedAt($deletedAt): self
    {
        $this->deletedAt = $deletedAt;
        return $this;
    }
}
