<?php


namespace App\Entity;

/**
 * Class for app_config entity
 */
class AppConfig extends AbstractEntity
{
    public const ENTITY_NAME = "app_config";

    private ?string $appKey;
    private ?string $appValue;
    private ?string $appValueTwo;

    /**
     * @inheritDoc
     */
    public static function getEntityDefinition(): array
    {
        return [
            "app_key" => [
                "isClass" => false,
                "name" => "appKey",
                "type" => "string",
            ],
            "app_value" => [
                "isClass" => false,
                "name" => "appValue",
                "type" => "string",
            ],
            "app_value_two" => [
                "isClass" => false,
                "name" => "appValueTwo",
                "type" => "string",
            ],
        ];
    }

    // ---------
    // Accessors

    /**
     * @return string|null
     */
    public function getAppKey(): ?string
    {
        return $this->appKey;
    }

    /**
     * @param string|null $appKey
     * @return $this
     */
    public function setAppKey(?string $appKey): self
    {
        $this->appKey = $appKey;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getAppValue(): ?string
    {
        return $this->appValue;
    }

    /**
     * @param string|null $appValue
     * @return $this
     */
    public function setAppValue(?string $appValue): self
    {
        $this->appValue = $appValue;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getAppValueTwo(): ?string
    {
        return $this->appValueTwo;
    }

    /**
     * @param string|null $appValueTwo
     * @return $this
     */
    public function setAppValueTwo(?string $appValueTwo): self
    {
        $this->appValueTwo = $appValueTwo;
        return $this;
    }
}
