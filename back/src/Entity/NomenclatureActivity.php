<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for nomenclature_activity entity
 */
class NomenclatureActivity extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_activity";

    /**
     * @Groups({"api"})
     */
    private ?string $code;
    /**
     * @Groups({"api"})
     */
    private ?array $nameNaf2;
    private ?NomenclatureActivity $parentActivity;
    /**
     * @Groups({"api"})
     */
    private ?int $parentActivityId;
    private ?NomenclatureActivitySection $section;
    /**
     * @Groups({"api"})
     */
    private ?int $sectionId;

    public static function getEntityDefinition(): array
    {
        return [
            "code" => [
                "isClass" => false,
                "name" => "code",
                "type" => "string",
            ],
            "name_naf_2" => [
                "isClass" => false,
                "name" => "nameNaf2",
                "type" => "hstore",
            ],
            "parent_activity" => [
                "isClass" => true,
                "name" => "parentActivity",
                "type" => NomenclatureActivity::class,
            ],
            "parent_activity_id" => [
                "isClass" => false,
                "name" => "parentActivityId",
                "type" => "int",
            ],
            "section" => [
                "isClass" => true,
                "name" => "section",
                "type" => NomenclatureActivitySection::class,
            ],
            "section_id" => [
                "isClass" => false,
                "name" => "sectionId",
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
    public function getNameNaf2(): ?array
    {
        return $this->nameNaf2;
    }

    /**
     * @param array $nameNaf2
     * @return $this
     */
    public function setNameNaf2(?array $nameNaf2): ?self
    {
        $this->nameNaf2 = $nameNaf2;
        return $this;
    }

    /**
     * @return \App\Entity\NomenclatureActivity
     */
    public function getParentActivity(): ?NomenclatureActivity
    {
        return $this->parentActivity;
    }

    /**
     * @param \App\Entity\NomenclatureActivity $parentActivity
     * @return $this
     */
    public function setParentActivity(?NomenclatureActivity $parentActivity): ?self
    {
        $this->parentActivity = $parentActivity;
        return $this;
    }

    /**
     * @return int
     */
    public function getParentActivityId(): ?int
    {
        return $this->parentActivityId;
    }

    /**
     * @param int $parentActivityId
     * @return $this
     */
    public function setParentActivityId(?int $parentActivityId): ?self
    {
        $this->parentActivityId = $parentActivityId;
        return $this;
    }

    /**
     * @return \App\Entity\NomenclatureActivitySection
     */
    public function getSection(): ?NomenclatureActivitySection
    {
        return $this->section;
    }

    /**
     * @param \App\Entity\NomenclatureActivitySection $section
     * @return $this
     */
    public function setSection(?NomenclatureActivitySection $section): ?self
    {
        $this->section = $section;
        return $this;
    }

    /**
     * @return int
     */
    public function getSectionId(): ?int
    {
        return $this->sectionId;
    }

    /**
     * @param int $sectionId
     * @return $this
     */
    public function setSectionId(?int $sectionId): ?self
    {
        $this->sectionId = $sectionId;
        return $this;
    }
}
