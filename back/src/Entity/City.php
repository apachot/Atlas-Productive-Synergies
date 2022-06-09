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
 * Class for city entity
 */
class City extends AbstractEntity
{
    public const ENTITY_NAME = "city";

    /**
     * @Groups({"api"})
     */
    private ?array $coordinates;
    private ?Department $department;
    /**
     * @Groups({"api"})
     */
    private ?int $departmentId;
    private ?IndustryTerritory $industryTerritory;
    /**
     * @Groups({"api"})
     */
    private ?int $industryTerritoryId;
    /**
     * @Groups({"api"})
     */
    private ?string $inseeCode;
    /**
     * @Groups({"api"})
     */
    private ?array $name;
    /**
     * @Groups({"api"})
     */
    private ?array $perimeter;
    /**
     * @Groups({"api"})
     */
    private ?string $slug;
    /**
     * @Groups({"api"})
     */
    private ?string $zipCode;

    public static function getEntityDefinition(): array
    {
        return [
            "coordinates" => [
                "isClass" => false,
                "name" => "coordinates",
                "type" => "point",
            ],
            "department" => [
                "isClass" => true,
                "name" => "department",
                "type" => Department::class,
            ],
            "department_id" => [
                "isClass" => false,
                "name" => "departmentId",
                "type" => "int",
            ],
            "industry_territory" => [
                "isClass" => true,
                "name" => "industryTerritory",
                "type" => IndustryTerritory::class,
            ],
            "industry_territory_id" => [
                "isClass" => false,
                "name" => "industryTerritoryId",
                "type" => "int",
            ],
            "insee_code" => [
                "isClass" => false,
                "name" => "inseeCode",
                "type" => "string",
            ],
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
            ],
            "perimeter" => [
                "isClass" => false,
                "name" => "perimeter",
                "type" => "polygon",
            ],
            "slug" => [
                "isClass" => false,
                "name" => "slug",
                "type" => "string",
            ],
            "zip_code" => [
                "isClass" => false,
                "name" => "zipCode",
                "type" => "string",
            ],

        ];
    }

    // Accessors

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
     * @return \App\Entity\Department
     */
    public function getDepartment(): ?Department
    {
        return $this->department;
    }

    /**
     * @param \App\Entity\Department $department
     * @return $this
     */
    public function setDepartment(?Department $department): ?self
    {
        $this->department = $department;
        return $this;
    }

    /**
     * @return int
     */
    public function getDepartmentId(): ?int
    {
        return $this->departmentId;
    }

    /**
     * @param int $departmentId
     * @return $this
     */
    public function setDepartmentId(?int $departmentId): ?self
    {
        $this->departmentId = $departmentId;
        return $this;
    }

    /**
     * @return \App\Entity\IndustryTerritory|null
     */
    public function getIndustryTerritory(): ?\App\Entity\IndustryTerritory
    {
        return $this->industryTerritory;
    }

    /**
     * @param \App\Entity\IndustryTerritory|null $industryTerritory
     * @return $this
     */
    public function setIndustryTerritory(?IndustryTerritory $industryTerritory): self
    {
        $this->industryTerritory = $industryTerritory;
        return $this;
    }

    /**
     * @return int|null
     */
    public function getIndustryTerritoryId(): ?int
    {
        return $this->industryTerritoryId;
    }

    /**
     * @param int|null $industryTerritoryId
     * @return $this
     */
    public function setIndustryTerritoryId(?int $industryTerritoryId): self
    {
        $this->industryTerritoryId = $industryTerritoryId;
        return $this;
    }

    /**
     * @return string
     */
    public function getInseeCode(): ?string
    {
        return $this->inseeCode;
    }

    /**
     * @param string $inseeCode
     * @return $this
     */
    public function setInseeCode(?string $inseeCode): ?self
    {
        $this->inseeCode = $inseeCode;
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
     * @return array|null
     */
    public function getPerimeter(): ?array
    {
        return $this->perimeter;
    }

    /**
     * @param array|null $perimeter
     * @return $this
     */
    public function setPerimeter(?array $perimeter): self
    {
        $this->perimeter = $perimeter;
        return $this;
    }

    /**
     * @return string
     */
    public function getSlug(): ?string
    {
        return $this->slug;
    }

    /**
     * @param string $slug
     * @return $this
     */
    public function setSlug(?string $slug): ?self
    {
        $this->slug = $slug;
        return $this;
    }

    /**
     * @return string
     */
    public function getZipCode(): ?string
    {
        return $this->zipCode;
    }

    /**
     * @param string $zipCode
     * @return $this
     */
    public function setZipCode(?string $zipCode): ?self
    {
        $this->zipCode = $zipCode;
        return $this;
    }
}
