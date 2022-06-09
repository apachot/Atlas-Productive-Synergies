<?php


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
