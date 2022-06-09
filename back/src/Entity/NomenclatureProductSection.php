<?php

namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for nomenclature_product_section
 */
class NomenclatureProductSection extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_product_section";

    /**
     * @Groups({"api"})
     */
    private ?array $name;
    /**
     * @Groups({"api"})
     */
    private ?string $shortName;

    public static function getEntityDefinition(): array
    {
        return [
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
            ],
            "short_name" => [
                "isClass" => false,
                "name" => "ShortName",
                "type" => "string",
            ],
        ];
    }

    // Accessors
    // ---------

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

    /**
     * @return string
     */
    public function getShortName(): ?string
    {
        return $this->shortName;
    }

    /**
     * @param string $shortName
     * @return $this
     */
    public function setShortName(?string $shortName): ?self
    {
        $this->shortName = $shortName;
        return $this;
    }
}
