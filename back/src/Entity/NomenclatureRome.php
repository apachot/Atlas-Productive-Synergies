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
 * Class for nomenclature_rome entity
 */
class NomenclatureRome extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_rome";

    /**
     * @Groups({"api"})
     */
    private ?string $code;
    /**
     * @Groups({"api"})
     */
    private ?array $name;
    /**
     * @Groups({"api"})
     */
    private ?string $ogr;
    /**
     * @Groups({"api"})
     */
    private ?NomenclatureRomeProfessionalDomain $professionalDomain;
    /**
     * @Groups({"api"})
     */
    private ?int $professionalDomainId;

    public static function getEntityDefinition(): array
    {
        return [
            "code" => [
                "isClass" => false,
                "name" => "code",
                "type" => "string",
            ],
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
            ],
            "ogr" => [
                "isClass" => false,
                "name" => "ogr",
                "type" => "string",
            ],
            "professional_domain" => [
                "isClass" => true,
                "name" => "professionalDomain",
                "type" => NomenclatureRomeProfessionalDomain::class,
            ],
            "professional_domain_id" => [
                "isClass" => false,
                "name" => "professionalDomainId",
                "type" => "int",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return string
     */
    public function getCode(): ?string
    {
        return $this->code;
    }

    /**
     * @param string $code
     * @return $this
     */
    public function setCode(?string $code): ?self
    {
        $this->code = $code;
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
     * @return string
     */
    public function getOgr(): ?string
    {
        return $this->ogr;
    }

    /**
     * @param string $ogr
     * @return $this
     */
    public function setOgr(?string $ogr): ?self
    {
        $this->ogr = $ogr;
        return $this;
    }

    /**
     * @return \App\Entity\NomenclatureRomeProfessionalDomain
     */
    public function getProfessionalDomain(): ?NomenclatureRomeProfessionalDomain
    {
        return $this->professionalDomain;
    }

    /**
     * @param \App\Entity\NomenclatureRomeProfessionalDomain $professionalDomain
     * @return $this
     */
    public function setProfessionalDomain(?NomenclatureRomeProfessionalDomain $professionalDomain): ?self
    {
        $this->professionalDomain = $professionalDomain;
        return $this;
    }

    /**
     * @return int
     */
    public function getProfessionalDomainId(): ?int
    {
        return $this->professionalDomainId;
    }

    /**
     * @param int $professionalDomainId
     * @return $this
     */
    public function setProfessionalDomainId(?int $professionalDomainId): ?self
    {
        $this->professionalDomainId = $professionalDomainId;
        return $this;
    }
}
