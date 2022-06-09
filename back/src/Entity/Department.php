<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for department entity
 */
class Department extends AbstractEntity
{
    public const ENTITY_NAME = "department";

    /**
     * @Groups({"api"})
     */
    private ?string $code;
    /**
     * @Groups({"api"})
     */
    private ?array $name;
    private ?Region $region;
    /**
     * @Groups({"api"})
     */
    private ?int $regionId;
    /**
     * @Groups({"api"})
     */
    private ?string $slug;

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
            "region" => [
                "isClass" => true,
                "name" => "region",
                "type" => Region::class,
            ],
            "region_id" => [
                "isClass" => false,
                "name" => "regionId",
                "type" => "int",
            ],
            "slug" => [
                "isClass" => false,
                "name" => "slug",
                "type" => "string",
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
     * @return \App\Entity\Region
     */
    public function getRegion(): ?Region
    {
        return $this->region;
    }

    /**
     * @param \App\Entity\Region $region
     * @return $this
     */
    public function setRegion(?Region $region): ?self
    {
        $this->region = $region;
        return $this;
    }

    /**
     * @return int
     */
    public function getRegionId(): ?int
    {
        return $this->regionId;
    }

    /**
     * @param int $regionId
     * @return $this
     */
    public function setRegionId(?int $regionId): ?self
    {
        $this->regionId = $regionId;
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
}
