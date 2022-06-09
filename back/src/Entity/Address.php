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
 * Class form address entity
 */
class Address extends AbstractEntity
{
    public const ENTITY_NAME = "address";

    private ?City $city;
    /**
     * @Groups({"api"})
     */
    private ?int $cityId;
    /**
     * @Groups({"api"})
     */
    private ?string $cedex;
    /**
     * @Groups({"api"})
     */
    private ?string $cedexLabel;
    /**
     * @Groups({"api"})
     */
    private ?string $complement;
    /**
     * @Groups({"api"})
     */
    private ?array $coordinates;
    /**
     * @Groups({"api"})
     */
    private ?string $repetitionIndex;
    /**
     * @Groups({"api"})
     */
    private ?string $specialDistribution;
    /**
     * @Groups({"api"})
     */
    private ?string $wayLabel;
    /**
     * @Groups({"api"})
     */
    private ?string $wayNumber;
    /**
     * @Groups({"api"})
     */
    private ?string $wayType;

    public static function getEntityDefinition(): array
    {
        return [
            "city" => [
                "isClass" => true,
                "name" => "city",
                "type" => City::class,
            ],
            "city_id" => [
                "isClass" => false,
                "name" => "cityId",
                "type" => "int",
            ],
            "cedex" => [
                "isClass" => false,
                "name" => "cedex",
                "type" => "string",
            ],
            "cedex_label" => [
                "isClass" => false,
                "name" => "cedexLabel",
                "type" => "string",
            ],
            "complement" => [
                "isClass" => false,
                "name" => "complement",
                "type" => "string",
            ],
            "coordinates" => [
                "isClass" => false,
                "name" => "coordinates",
                "type" => "point",
            ],
            "repetition_index" => [
                "isClass" => false,
                "name" => "repetitionIndex",
                "type" => "string",
            ],
            "special_distribution" => [
                "isClass" => false,
                "name" => "specialDistribution",
                "type" => "string",
            ],
            "way_label" => [
                "isClass" => false,
                "name" => "wayLabel",
                "type" => "string",
            ],
            "way_number" => [
                "isClass" => false,
                "name" => "wayNumber",
                "type" => "string",
            ],
            "way_type" => [
                "isClass" => false,
                "name" => "wayType",
                "type" => "string",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return \App\Entity\City
     */
    public function getCity(): ?City
    {
        return $this->city;
    }

    /**
     * @param \App\Entity\City $city
     * @return $this
     */
    public function setCity(?City $city): ?self
    {
        $this->city = $city;
        return $this;
    }

    /**
     * @return int
     */
    public function getCityId(): ?int
    {
        return $this->cityId;
    }

    /**
     * @param int $cityId
     * @return $this
     */
    public function setCityId(?int $cityId): ?self
    {
        $this->cityId = $cityId;
        return $this;
    }

    /**
     * @return string
     */
    public function getCedex(): ?string
    {
        return $this->cedex;
    }

    /**
     * @param string $cedex
     * @return $this
     */
    public function setCedex(?string $cedex): ?self
    {
        $this->cedex = $cedex;
        return $this;
    }

    /**
     * @return string
     */
    public function getCedexLabel(): ?string
    {
        return $this->cedexLabel;
    }

    /**
     * @param string $cedexLabel
     * @return $this
     */
    public function setCedexLabel(?string $cedexLabel): ?self
    {
        $this->cedexLabel = $cedexLabel;
        return $this;
    }

    /**
     * @return string
     */
    public function getComplement(): ?string
    {
        return $this->complement;
    }

    /**
     * @param string $complement
     * @return $this
     */
    public function setComplement(?string $complement): ?self
    {
        $this->complement = $complement;
        return $this;
    }

    /**
     * @return array
     */
    public function getCoordinates(): ?array
    {
        return $this->coordinates;
    }

    /**
     * @param array $coordinates
     * @return $this
     */
    public function setCoordinates(?array $coordinates): ?self
    {
        $this->coordinates = $coordinates;
        return $this;
    }

    /**
     * @return string
     */
    public function getRepetitionIndex(): ?string
    {
        return $this->repetitionIndex;
    }

    /**
     * @param string $repetitionIndex
     * @return $this
     */
    public function setRepetitionIndex(?string $repetitionIndex): ?self
    {
        $this->repetitionIndex = $repetitionIndex;
        return $this;
    }

    /**
     * @return string
     */
    public function getSpecialDistribution(): ?string
    {
        return $this->specialDistribution;
    }

    /**
     * @param string $specialDistribution
     * @return $this
     */
    public function setSpecialDistribution(?string $specialDistribution): ?self
    {
        $this->specialDistribution = $specialDistribution;
        return $this;
    }

    /**
     * @return string
     */
    public function getWayLabel(): ?string
    {
        return $this->wayLabel;
    }

    /**
     * @param string $wayLabel
     * @return $this
     */
    public function setWayLabel(?string $wayLabel): ?self
    {
        $this->wayLabel = $wayLabel;
        return $this;
    }

    /**
     * @return string
     */
    public function getWayNumber(): ?string
    {
        return $this->wayNumber;
    }

    /**
     * @param string $wayNumber
     * @return $this
     */
    public function setWayNumber(?string $wayNumber): ?self
    {
        $this->wayNumber = $wayNumber;
        return $this;
    }

    /**
     * @return string
     */
    public function getWayType(): ?string
    {
        return $this->wayType;
    }

    /**
     * @param string $wayType
     * @return $this
     */
    public function setWayType(?string $wayType): ?self
    {
        $this->wayType = $wayType;
        return $this;
    }
}
