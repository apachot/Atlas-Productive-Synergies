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
 * Class for nomenclature_product_chapter
 */
class NomenclatureProductChapter extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_product_chapter";

    /**
     * @Groups({"api"})
     */
    private ?array $name;
    private ?NomenclatureProductSection $productSection;
    /**
     * @Groups({"api"})
     */
    private ?int $productSectionId;
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
            "productSection" => [
                "isClass" => true,
                "name" => "productSection",
                "type" => NomenclatureProductSection::class,
            ],
            "product_section_id" => [
                "isClass" => false,
                "name" => "productSectionId",
                "type" => "int",
            ],
            "short_name" => [
                "isClass" => false,
                "name" => "shortName",
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
     * @return \App\Entity\NomenclatureProductSection
     */
    public function getProductSection(): ?NomenclatureProductSection
    {
        return $this->productSection;
    }

    /**
     * @param \App\Entity\NomenclatureProductSection $productSection
     * @return $this
     */
    public function setProductSection(?NomenclatureProductSection $productSection): ?self
    {
        $this->productSection = $productSection;
        return $this;
    }

    /**
     * @return int
     */
    public function getProductSectionId(): ?int
    {
        return $this->productSectionId;
    }

    /**
     * @param int $productSectionId
     * @return $this
     */
    public function setProductSectionId(?int $productSectionId): ?self
    {
        $this->productSectionId = $productSectionId;
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
