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
 * Class for nomenclature_product
 */
class NomenclatureProduct extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_product";

    /**
     * @Groups({"api"})
     */
    private ?string $codeHs4;
    /**
     * @Groups({"api"})
     */
    private ?string $codeNc;
    /**
     * @Groups({"api"})
     */
    private ?array $name;
    private ?NomenclatureProductChapter $productChapter;
    /**
     * @Groups({"api"})
     */
    private ?int $productChapterId;

    public static function getEntityDefinition(): array
    {
        return [
            "code_hs4" => [
                "isClass" => false,
                "name" => "codeHs4",
                "type" => "string",
            ],
            "code_nc" => [
                "isClass" => false,
                "name" => "codeNc",
                "type" => "string",
            ],
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
            ],
            "product_chapter" => [
                "isClass" => true,
                "name" => "productChapter",
                "type" => NomenclatureProductChapter::class,
            ],
            "product_chapter_id" => [
                "isClass" => false,
                "name" => "productChapterId",
                "type" => "int",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return string
     */
    public function getCodeHs4(): ?string
    {
        return $this->codeHs4;
    }

    /**
     * @param string $codeHs4
     * @return $this
     */
    public function setCodeHs4(?string $codeHs4): ?self
    {
        $this->codeHs4 = $codeHs4;
        return $this;
    }

    /**
     * @return string
     */
    public function getCodeNc(): ?string
    {
        return $this->codeNc;
    }

    /**
     * @param string $codeNc
     * @return $this
     */
    public function setCodeNc(?string $codeNc): ?self
    {
        $this->codeNc = $codeNc;
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

    /**
     * @return \App\Entity\NomenclatureProductChapter
     */
    public function getProductChapter(): ?NomenclatureProductChapter
    {
        return $this->productChapter;
    }

    /**
     * @param \App\Entity\NomenclatureProductChapter $productChapter
     * @return $this
     */
    public function setProductChapter(?NomenclatureProductChapter $productChapter): ?self
    {
        $this->productChapter = $productChapter;
        return $this;
    }

    /**
     * @return int
     */
    public function getProductChapterId(): ?int
    {
        return $this->productChapterId;
    }

    /**
     * @param int $productChapterId
     * @return $this
     */
    public function setProductChapterId(?int $productChapterId): ?self
    {
        $this->productChapterId = $productChapterId;
        return $this;
    }
}
