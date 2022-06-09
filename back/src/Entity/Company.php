<?php


namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for company entity
 */
class Company extends AbstractEntity
{
    public const ENTITY_NAME = "company";

    private ?Address $address;
    /**
     * @Groups({"api"})
     */
    private ?int $addressId;
    /**
     * @Groups({"api"})
     */
    private ?string $name;
    /**
     * @Groups({"api"})
     */
    private ?string $siren;

    public static function getEntityDefinition(): array
    {
        return [
            "address" => [
                "isClass" => true,
                "name" => "address",
                "type" => Address::class,
            ],
            "address_id" => [
                "isClass" => false,
                "name" => "addressId",
                "type" => "string",
            ],
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "string",
            ],
            "siren" => [
                "isClass" => false,
                "name" => "siren",
                "type" => "string",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return \App\Entity\Address
     */
    public function getAddress(): ?Address
    {
        return $this->address;
    }

    /**
     * @param \App\Entity\Address $address
     * @return $this
     */
    public function setAddress(?Address $address): ?self
    {
        $this->address = $address;
        return $this;
    }

    /**
     * @return int
     */
    public function getAddressId(): ?int
    {
        return $this->addressId;
    }

    /**
     * @param int $addressId
     * @return $this
     */
    public function setAddressId(?int $addressId): ?self
    {
        $this->addressId = $addressId;
        return $this;
    }

    /**
     * @return string
     */
    public function getName(): ?string
    {
        return $this->name;
    }

    /**
     * @param string $name
     * @return $this
     */
    public function setName(?string $name): ?self
    {
        $this->name = $name;
        return $this;
    }

    /**
     * @return string
     */
    public function getSiren(): ?string
    {
        return $this->siren;
    }

    /**
     * @param string $siren
     * @return $this
     */
    public function setSiren(?string $siren): ?self
    {
        $this->siren = $siren;
        return $this;
    }
}
