<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * CLass for nomenclature_product_proximity
 */
class NomenclatureProductProximity extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_product_proximity";

    /**
     * @Groups({"api"})
     */
    private ?string $mainProductCodeHs4;
    /**
     * @Groups({"api"})
     */
    private ?float $proximity;
    /**
     * @Groups({"api"})
     */
    private ?string $secondaryProductCodeHs4;

    public static function getEntityDefinition(): array
    {
        return [
            "main_product_code_hs4" => [
                "isClass" => false,
                "name" => "mainProductCodeHs4",
                "type" => "string",
            ],
            "proximity" => [
                "isClass" => false,
                "name" => "proximity",
                "type" => "float",
            ],
            "secondary_product_code_hs4" => [
                "isClass" => false,
                "name" => "secondaryProductCodeHs4",
                "type" => "string",
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
     * @return float
     */
    public function getProximity(): ?float
    {
        return $this->proximity;
    }

    /**
     * @param float $proximity
     * @return $this
     */
    public function setProximity(?float $proximity): ?self
    {
        $this->proximity = $proximity;
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
}
