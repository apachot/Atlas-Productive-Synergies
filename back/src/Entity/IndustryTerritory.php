<?php

namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for industry_territory entity
 */
class IndustryTerritory extends AbstractEntity
{
    public const ENTITY_NAME = "industry_territory";

    /**
     * @Groups({"api"})
     */
    private ?array $name;
    /**
     * @Groups({"api"})
     */
    private ?string $nationalIdentifying;

    /**
     * @inheritDoc
     */
    public static function getEntityDefinition(): array
    {
        return [
            "national_identifying" => [
                "isClass" => false,
                "name" => "nationalIdentifying",
                "type" => "string",
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
    public function getNationalIdentifying(): string
    {
        return $this->nationalIdentifying;
    }

    /**
     * @param string $nationalIdentifying
     * @return $this
     */
    public function setNationalIdentifying(?string $nationalIdentifying): self
    {
        $this->nationalIdentifying = $nationalIdentifying;
        return $this;
    }

    /**
     * @return array
     */
    public function getName(): array
    {
        return $this->name;
    }

    /**
     * @param array $name
     * @return $this
     */
    public function setName(?array $name): self
    {
        $this->name = $name;
        return $this;
    }
}
