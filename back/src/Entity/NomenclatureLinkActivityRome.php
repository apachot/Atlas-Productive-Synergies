<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for nomenclature_link_activity_rome entity
 */
class NomenclatureLinkActivityRome extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_link_activity_rome";

    /**
     * @Groups({"api"})
     */
    private ?string $activityNafCode;
    /**
     * @Groups({"api"})
     */
    private ?string $romeCode;

    public static function getEntityDefinition(): array
    {
        return [
            "activity_naf_code" => [
                "isClass" => false,
                "name" => "activityNafCode",
                "type" => "string",
            ],
            "rome_code" => [
                "isClass" => false,
                "name" => "romeCode",
                "type" => "string",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return string|null
     */
    public function getActivityNafCode(): ?string
    {
        return $this->activityNafCode;
    }

    /**
     * @param string|null $activityNafCode
     * @return $this
     */
    public function setActivityNafCode($activityNafCode): self
    {
        $this->activityNafCode = $activityNafCode;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getRomeCode(): ?string
    {
        return $this->romeCode;
    }

    /**
     * @param string|null $romeCode
     * @return $this
     */
    public function setRomeCode($romeCode): self
    {
        $this->romeCode = $romeCode;
        return $this;
    }
}
