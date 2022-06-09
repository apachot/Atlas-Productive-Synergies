<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for nomenclature_product_relationship
 */
class NomenclatureProductRelationship extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_product_relationship";

    /**
     * @Groups({"api"})
     */
    private ?string $mainProductCodeHs4;
    /**
     * @Groups({"api"})
     */
    private ?string $secondaryProductCodeHs4;
    /**
     * @Groups({"api"})
     */
    private ?float $strength;

    /**
     * @inheritDoc
     */
    public static function getEntityDefinition(): array
    {
        return [
            "main_product_code_hs4" => [
                "isClass" => false,
                "name" => "mainProductCodeHs4",
                "type" => "string",
            ],
            "secondary_product_code_hs4" => [
                "isClass" => false,
                "name" => "secondaryProductCodeHs4",
                "type" => "string",
            ],
            "strength" => [
                "isClass" => false,
                "name" => "strength",
                "type" => "float",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return string|null
     */
    public function getMainProductCodeHs4(): ?string
    {
        return $this->mainProductCodeHs4;
    }

    /**
     * @param string|null $mainProductCodeHs4
     * @return $this
     */
    public function setMainProductCodeHs4(?string $mainProductCodeHs4): self
    {
        $this->mainProductCodeHs4 = $mainProductCodeHs4;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getSecondaryProductCodeHs4(): ?string
    {
        return $this->secondaryProductCodeHs4;
    }

    /**
     * @param string|null $secondaryProductCodeHs4
     * @return $this
     */
    public function setSecondaryProductCodeHs4(?string $secondaryProductCodeHs4): self
    {
        $this->secondaryProductCodeHs4 = $secondaryProductCodeHs4;
        return $this;
    }

    /**
     * @return float|null
     */
    public function getStrength(): ?float
    {
        return $this->strength;
    }

    /**
     * @param float|null $strength
     * @return $this
     */
    public function setStrength(?float $strength): self
    {
        $this->strength = $strength;
        return $this;
    }
}
