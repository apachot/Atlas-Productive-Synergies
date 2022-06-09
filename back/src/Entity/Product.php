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
 * Class for product
 */
class Product extends AbstractEntity
{
    public const ENTITY_NAME = "product";

    /**
     * @Groups({"api"})
     */
    private ?int $establishmentId;
    private ?string $establishmentPartitionCode;
    private ?Establishment $establishment;
    /**
     * @Groups({"api"})
     */
    private ?int $nomenclatureProductId;
    private ?NomenclatureProduct $nomenclatureProduct;
    /**
     * @Groups({"api"})
     */
    private ?string $gtin;
    /**
     * @Groups({"api"})
     */
    private ?array $name;
    /**
     * @Groups({"api"})
     */
    private ?array $description;
    /**
     * @Groups({"api"})
     */
    private ?int $ratio;
    /**
     * @Groups({"api"})
     */
    private ?bool $fake;

    public static function getEntityDefinition(): array
    {
        return [
            "establishment_id" => [
                "isClass" => false,
                "name" => "establishmentId",
                "type" => "int",
            ],
            "establishment" => [
                "isClass" => true,
                "name" => 'establishment',
                "type" => Establishment::class,
            ],
            "nomenclature_product_id" => [
                "isClass" => false,
                "name" => "nomenclatureProductId",
                "type" => "int",
            ],
            "nomenclature_product" => [
                "isClass" => true,
                "name" => "nomenclatureProduct",
                "type" => NomenclatureProduct::class,
            ],
            "gtin" => [
                "isClass" => false,
                "name" => "gtin",
                "type" => "string",
            ],
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
            ],
            "description" => [
                "isClass" => false,
                "name" => "description",
                "type" => "hstore",
            ],
            "ratio" => [
                "isClass" => false,
                "name" => "ratio",
                "type" => "int",
            ],
            "fake" => [
                "isClass" => false,
                "name" => "fake",
                "type" => "bool",
            ],
        ];
    }


    // Accessors
    // ---------

    /**
     * @return int|null
     */
    public function getEstablishmentId(): ?int
    {
        return $this->establishmentId;
    }

    /**
     * @param int|null $establishmentId
     *
     * @return Product
     */
    public function setEstablishmentId(?int $establishmentId): Product
    {
        $this->establishmentId = $establishmentId;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getEstablishmentPartitionCode(): ?string
    {
        return $this->establishmentPartitionCode;
    }

    /**
     * @param string|null $establishmentPartitionCode
     *
     * @return Product
     */
    public function setEstablishmentPartitionCode(?string $establishmentPartitionCode): Product
    {
        $this->establishmentPartitionCode = $establishmentPartitionCode;

        return $this;
    }

    /**
     * @return Establishment|null
     */
    public function getEstablishment(): ?Establishment
    {
        return $this->establishment;
    }

    /**
     * @param Establishment $establishment
     *
     * @return Product
     */
    public function setEstablishment(?Establishment $establishment): Product
    {
        $this->establishment = $establishment;

        return $this;
    }

    /**
     * @return int|null
     */
    public function getNomenclatureProductId(): ?int
    {
        return $this->nomenclatureProductId;
    }

    /**
     * @param int|null $nomenclatureProductId
     *
     * @return Product
     */
    public function setNomenclatureProductId(?int $nomenclatureProductId): Product
    {
        $this->nomenclatureProductId = $nomenclatureProductId;

        return $this;
    }

    /**
     * @return NomenclatureProduct|null
     */
    public function getNomenclatureProduct(): ?NomenclatureProduct
    {
        return $this->nomenclatureProduct;
    }

    /**
     * @param NomenclatureProduct|null $nomenclatureProduct
     *
     * @return Product
     */
    public function setNomenclatureProduct(?NomenclatureProduct $nomenclatureProduct): Product
    {
        $this->nomenclatureProduct = $nomenclatureProduct;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getGtin(): ?string
    {
        return $this->gtin;
    }

    /**
     * @param string|null $gtin
     *
     * @return Product
     */
    public function setGtin(?string $gtin): Product
    {
        $this->gtin = $gtin;

        return $this;
    }

    /**
     * @return array|null
     */
    public function getName(): ?array
    {
        return $this->name;
    }

    /**
     * @param array|null $name
     *
     * @return Product
     */
    public function setName(?array $name): Product
    {
        $this->name = $name;

        return $this;
    }

    /**
     * @return array|null
     */
    public function getDescription(): ?string
    {
        return $this->description;
    }

    /**
     * @param array|null $description
     *
     * @return Product
     */
    public function setDescription(?array $description): Product
    {
        $this->description = $description;

        return $this;
    }

    /**
     * @return int|null
     */
    public function getRatio(): ?int
    {
        return $this->ratio;
    }

    /**
     * @param int|null $ratio
     *
     * @return Product
     */
    public function setRatio(?int $ratio): Product
    {
        $this->ratio = $ratio;

        return $this;
    }

    /**
     * @return bool|null
     */
    public function getFake(): ?bool
    {
        return $this->fake;
    }

    /**
     * @param bool|null $fake
     *
     * @return Product
     */
    public function setFake(?bool $fake): Product
    {
        $this->fake = $fake;

        return $this;
    }
}