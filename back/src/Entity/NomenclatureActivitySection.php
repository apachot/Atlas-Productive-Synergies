<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for nomenclature_activity_section
 */
class NomenclatureActivitySection extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_activity_section";

    /**
     * @Groups({"api"})
     */
    private ?string $code;
    /**
     * @Groups({"api"})
     */
    private ?array $nameNaf2;

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
}
