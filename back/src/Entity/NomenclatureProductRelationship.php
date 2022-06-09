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
