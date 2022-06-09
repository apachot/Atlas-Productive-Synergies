<?php


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
