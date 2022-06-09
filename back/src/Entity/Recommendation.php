<?php


namespace App\Entity;

use InvalidArgumentException;
use Symfony\Component\Serializer\Annotation\Groups;
use DateTime;

/**
 * Class for recommendation
 */
class Recommendation extends AbstractEntity
{
    public const ENTITY_NAME = "recommendation";

    public const TYPE_CUSTOMER = 'CUSTOMER';
    public const TYPE_SUPPLIER = 'SUPPLIER';
    public const TYPE_PRODUCT = 'PRODUCT';
    public const TYPE_PARTNERSHIP = 'PARTNERSHIP';
    public const TYPE_PRODUCTION_UNIT = 'PRODUCTION_UNIT';

    /**
     * @Groups({"api"})
     */
    private ?string $type;
    /**
     * @Groups({"api"})
     */
    private ?int $establishmentId;
    private ?string $establishmentPartitionCode;
    private ?Establishment $establishment;
    /**
     * @Groups({"api"})
     */
    private ?array $data;
    /**
     * @Groups({"api"})
     */
    private ?DateTime $expiredAt;
    /**
     * @Groups({"api"})
     */
    private ?bool $fake;

    public static function getEntityDefinition(): array
    {
        return [
            "type" => [
                "isClass" => false,
                "name" => "type",
                "type" => "string",
            ],
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
            "data" => [
                "isClass" => false,
                "name" => "data",
                "type" => "json",
            ],
            "expired_at" => [
                "isClass" => false,
                "name" => "expiredAt",
                "type" => DateTime::class,
            ],
            "fake" => [
                "isClass" => false,
                "name" => "fake",
                "type" => "bool",
            ],
        ];
    }


    // Accessors
    // ---------

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
     * @return Recommendation
     */
    public function setType(?string $type): Recommendation
    {
        $types = $this->getRecommendationTypes();
        if (!in_array($type, $types, true)) {
            throw new InvalidArgumentException(
                sprintf('Invalid recommendation type "%s". valid choices : %s', $type, implode(', ', $types))
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
     * @return Recommendation
     */
    public function setEstablishmentId(?int $establishmentId): Recommendation
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
     * @return Recommendation
     */
    public function setEstablishmentPartitionCode(?string $establishmentPartitionCode): Recommendation
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
     * @param Establishment $establishment
     *
     * @return Recommendation
     */
    public function setEstablishment(?Establishment $establishment): Recommendation
    {
        $this->establishment = $establishment;

        return $this;
    }

    /**
     * @return array|null
     */
    public function getData(): ?array
    {
        return $this->data;
    }

    /**
     * @param array|null $data
     *
     * @return Recommendation
     */
    public function setData(?array $data): Recommendation
    {
        $this->data = $data;

        return $this;
    }

    /**
     * @return DateTime
     */
    public function getExpiredAt(): ?DateTime
    {
        return $this->expiredAt;
    }

    /**
     * @param DateTime $expiredAt
     *
     * @return Recommendation
     */
    public function setExpiredAt(DateTime $expiredAt): Recommendation
    {
        $this->expiredAt = $expiredAt;

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
     * @return Recommendation
     */
    public function setFake(?bool $fake): Recommendation
    {
        $this->fake = $fake;

        return $this;
    }

    /**
     * @return string[]
     */
    public function getRecommendationTypes(): array
    {
        return [
            self::TYPE_CUSTOMER,
            self::TYPE_SUPPLIER,
            self::TYPE_PRODUCT,
            self::TYPE_PARTNERSHIP,
            self::TYPE_PRODUCTION_UNIT,
        ];
    }
}