<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for nomenclature_rome_professional_domain
 */
class NomenclatureRomeProfessionalDomain extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_rome_professional_domain";

    /**
     * @Groups({"api"})
     */
    private ?string $code;
    private ?NomenclatureRomeMainDomain $mainDomaine;
    /**
     * @Groups({"api"})
     */
    private ?int $mainDomainId;
    /**
     * @Groups({"api"})
     */
    private ?array $name;

    public static function getEntityDefinition(): array
    {
        return [
            "code" => [
                "isClass" => false,
                "name" => "code",
                "type" => "string",
            ],
            "main_domaine" => [
                "isClass" => true,
                "name" => "mainDomaine",
                "type" => NomenclatureRomeMainDomain::class,
            ],
            "main_domain_id" => [
                "isClass" => false,
                "name" => "mainDomainId",
                "type" => "int",
            ],
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
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
     * @return \App\Entity\NomenclatureRomeMainDomain
     */
    public function getMainDomaine(): ?NomenclatureRomeMainDomain
    {
        return $this->mainDomaine;
    }

    /**
     * @param \App\Entity\NomenclatureRomeMainDomain $mainDomaine
     * @return $this
     */
    public function setMainDomaine(?NomenclatureRomeMainDomain $mainDomaine): ?self
    {
        $this->mainDomaine = $mainDomaine;
        return $this;
    }

    /**
     * @return int
     */
    public function getMainDomainId(): ?int
    {
        return $this->mainDomainId;
    }

    /**
     * @param int $mainDomainId
     * @return $this
     */
    public function setMainDomainId(?int $mainDomainId): ?self
    {
        $this->mainDomainId = $mainDomainId;
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
}
