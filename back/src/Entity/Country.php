<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for country entity
 */
class Country extends AbstractEntity
{
    public const ENTITY_NAME = "country";

    /**
     * @Groups({"api"})
     */
    private ?string $iso31663;
    /**
     * @Groups({"api"})
     */
    private ?array $longName;
    /**
     * @Groups({"api"})
     */
    private ?array $name;

    public static function getEntityDefinition(): array
    {
        return [
            "iso31663" => [
                "isClass" => false,
                "name" => "iso31663",
                "type" => "string",
            ],
            "long_name" => [
                "isClass" => false,
                "name" => "longName",
                "type" => "hstore",
            ],
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return string
     */
    public function getIso31663(): ?string
    {
        return $this->iso31663;
    }

    /**
     * @param string $iso31663
     * @return $this
     */
    public function setIso31663(?string $iso31663): ?self
    {
        $this->iso31663 = $iso31663;
        return $this;
    }

    /**
     * @return array
     */
    public function getLongName(): ?array
    {
        return $this->longName;
    }

    /**
     * @param array $longName
     * @return $this
     */
    public function setLongName(?array $longName): ?self
    {
        $this->longName = $longName;
        return $this;
    }

    /**
     * @return array
     */
    public function getName(): ?array
    {
        return $this->name;
    }

    /**
     * @param array $name
     * @return $this
     */
    public function setName(?array $name): ?self
    {
        $this->name = $name;
        return $this;
    }
}
