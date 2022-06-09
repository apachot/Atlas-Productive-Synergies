<?php
/*************************************************************************
 *
 * OPEN STUDIO
 * __________________
 *
 *  [2020] - [2021] Open Studio All Rights Reserved.
 *
 * NOTICE: All information contained herein is, and remains the property of
 * Open Studio. The intellectual and technical concepts contained herein are
 * proprietary to Open Studio and may be covered by France and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is strictly
 * forbidden unless prior written permission is obtained from Open Studio.
 * Access to the source code contained herein is hereby forbidden to anyone except
 * current Open Studio employees, managers or contractors who have executed
 * Confidentiality and Non-disclosure agreements explicitly covering such access.
 * This program is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

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
