<?php


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
