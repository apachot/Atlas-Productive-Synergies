<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

class MacroSector extends AbstractEntity
{
    public const ENTITY_NAME = "macro_sector";

    /**
     * @Groups({"api"})
     */
    private ?string $code;
    /**
     * @Groups({"api"})
     */
    private ?array $name;

    /**
     * @inheritDoc
     */
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
        ];
    }

    // Accessors
    // ---------

    /**
     * @return string|null
     */
    public function getCode(): ?string
    {
        return $this->code;
    }

    /**
     * @param string|null $code
     * @return $this
     */
    public function setCode(?string $code): self
    {
        $this->code = $code;
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
     * @return $this
     */
    public function setName(?array $name): self
    {
        $this->name = $name;
        return $this;
    }
}
