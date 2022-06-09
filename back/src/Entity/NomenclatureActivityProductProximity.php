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
 * Class for nomenclature_activity_proximity
 */
class NomenclatureActivityProductProximity extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_activity_product";

    /**
     * @Groups({"api"})
     */
    private ?string $activityNaf2;
    /**
     * @Groups({"api"})
     */
    private ?string $productHs4;
    /**
     * @Groups({"api"})
     */
    private ?float $proximity;

    public static function getEntityDefinition(): array
    {
        return [
            "activity_naf2" => [
                "isClass" => false,
                "name" => "activityNaf2",
                "type" => "string",
            ],
            "product_hs4" => [
                "isClass" => false,
                "name" => "product_hs4",
                "type" => "string",
            ],
            "proximity" => [
                "isClass" => false,
                "name" => "proximity",
                "type" => "float",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return string
     */
    public function getActivityNaf2(): ?string
    {
        return $this->activityNaf2;
    }

    /**
     * @param string|null $activityNaf2
     * @return $this
     */
    public function setActivityId(?string $activityNaf2): ?self
    {
        $this->activityNaf2 = $activityNaf2;
        return $this;
    }

    /**
     * @return string
     */
    public function getProductHs4(): ?string
    {
        return $this->productHs4;
    }

    /**
     * @param string|null $productHs4
     * @return $this
     */
    public function setProductHs4(?string $productHs4): ?self
    {
        $this->productHs4 = $productHs4;
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
}
