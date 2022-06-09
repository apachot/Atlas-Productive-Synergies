<?php


namespace App\Entity;

use InvalidArgumentException;
use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for relation
 */
class Relation extends AbstractEntity
{
    public const ENTITY_NAME = "relation";

    public const TYPE_PARTNER = 'PARTNER';

    /**
     * @Groups({"api"})
     */
    private ?string $type;
    /**
     * @Groups({"api"})
     */
    private ?int $establishmentId;
    private ?Establishment $establishment;
    /**
     * @Groups({"api"})
     */
    private ?int $secondaryEstablishmentId;
    private ?Establishment $secondaryEstablishment;
    /**
     * @Groups({"api"})
     */
    private ?float $strength;
    /**
     * @Groups({"api"})
     */
    private ?bool $public;
    /**
     * @Groups({"api"})
     */
    private ?bool $fake;
    /**
     * @Groups({"api"})
     */
    private ?bool $accepted;

    public static function getEntityDefinition(): array
    {
        return [
            "establishment_id" => [
                "isClass" => false,
                "name" => "establishmentId",
                "type" => "int",
            ],
            "establishment" => [
                "isClass" => true,
                "name" => 'establishment',
                "type" => Establishment::class,
            ],
            "secondary_establishment_id" => [
                "isClass" => false,
                "name" => "establishmentId",
                "type" => "int",
            ],
            "secondary_establishment" => [
                "isClass" => true,
                "name" => "secondaryEstablishment",
                "type" => Establishment::class,
            ],
            "strength" => [
                "isClass" => false,
                "name" => "strength",
                "type" => "float",
            ],
            "public" => [
                "isClass" => false,
                "name" => "public",
                "type" => "bool",
            ],
            "fake" => [
                "isClass" => false,
                "name" => "fake",
                "type" => "bool",
            ],
            "accepted" => [
                "isClass" => false,
                "name" => "accepted",
                "type" => "bool",
            ],
        ];
    }


    // Accessors
    // ---------

    /**
     * @return int|null
     */
    public function getProductId(): ?int
    {
        return $this->productId;
    }

    /**
     * @param int|null $productId
     *
     * @return Relation
     */
    public function setProductId(?int $productId): Relation
    {
        $this->productId = $productId;

        return $this;
    }

    /**
     * @return Product|null
     */
    public function getProduct(): ?Product
    {
        return $this->product;
    }

    /**
     * @param Product|null $product
     *
     * @return Relation
     */
    public function setProduct(?Product $product): Relation
    {
        $this->product = $product;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getType(): ?string
    {
        return $this->type;
    }

    /**
     * @param string|null $type
     *
     * @return Relation
     */
    public function setType(?string $type): Relation
    {
        $types = $this->getRelationTypes();
        if (!in_array($type, $types, true)) {
            throw new InvalidArgumentException(
                sprintf('Invalid relation type "%s". valid choices : %s', $type, implode(', ', $types))
            );
        }
        $this->type = $type;

        return $this;
    }

    /**
     * @return int|null
     */
    public function getEstablishmentId(): ?int
    {
        return $this->establishmentId;
    }

    /**
     * @param int|null $establishmentId
     *
     * @return Relation
     */
    public function setEstablishmentId(?int $establishmentId): Relation
    {
        $this->establishmentId = $establishmentId;

        return $this;
    }

    /**
     * @return string|null
     */
    public function getEstablishmentPartitionCode(): ?string
    {
        return $this->establishmentPartitionCode;
    }

    /**
     * @param string|null $establishmentPartitionCode
     *
     * @return Relation
     */
    public function setEstablishmentPartitionCode(?string $establishmentPartitionCode): Relation
    {
        $this->establishmentPartitionCode = $establishmentPartitionCode;

        return $this;
    }

    /**
     * @return Establishment|null
     */
    public function getEstablishment(): ?Establishment
    {
        return $this->establishment;
    }

    /**
     * @param Establishment|null $establishment
     *
     * @return Relation
     */
    public function setEstablishment(?Establishment $establishment): Relation
    {
        $this->establishment = $establishment;

        return $this;
    }

    /**
     * @return int|null
     */
    public function getSecondaryEstablishmentId(): ?int
    {
        return $this->secondaryEstablishmentId;
    }

    /**
     * @param int|null $secondaryEstablishmentId
     *
     * @return Relation
     */
    public function setSecondaryEstablishmentId(?int $secondaryEstablishmentId): Relation
    {
        $this->secondaryEstablishmentId = $secondaryEstablishmentId;

        return $this;
    }

    /**
     * @return Establishment|null
     */
    public function getSecondaryEstablishment(): ?Establishment
    {
        return $this->secondaryEstablishment;
    }

    /**
     * @param Establishment|null $secondaryEstablishment
     *
     * @return Relation
     */
    public function setSecondaryEstablishment(?Establishment $secondaryEstablishment): Relation
    {
        $this->secondaryEstablishment = $secondaryEstablishment;

        return $this;
    }

    /**
     * @return float|null
     */
    public function getStrength(): ?float
    {
        return $this->strength;
    }

    /**
     * @param float|null $strength
     *
     * @return Relation
     */
    public function setStrength(?float $strength): Relation
    {
        $this->strength = $strength;

        return $this;
    }

    /**
     * @return bool|null
     */
    public function getPublic(): ?bool
    {
        return $this->public;
    }

    /**
     * @param bool|null $public
     *
     * @return Relation
     */
    public function setPublic(?bool $public): Relation
    {
        $this->public = $public;

        return $this;
    }

    /**
     * @return bool|null
     */
    public function getFake(): ?bool
    {
        return $this->fake;
    }

    /**
     * @param bool|null $fake
     *
     * @return Relation
     */
    public function setFake(?bool $fake): Relation
    {
        $this->fake = $fake;

        return $this;
    }

    /**
     * @return bool|null
     */
    public function getAccepted(): ?bool
    {
        return $this->accepted;
    }

    /**
     * @param bool|null $accepted
     *
     * @return Relation
     */
    public function setAccepted(?bool $accepted): Relation
    {
        $this->accepted = $accepted;

        return $this;
    }

    /**
     * @return string[]
     */
    public function getRelationTypes(): array
    {
        return [
            self::TYPE_PARTNER,
        ];
    }
}