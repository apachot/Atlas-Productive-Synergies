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

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for country entity
 */
class Country extends AbstractEntity
{
    public const ENTITY_NAME = "country";

    /**
     * @Groups({"api"})
     */
    private ?string $iso31663;
    /**
     * @Groups({"api"})
     */
    private ?array $longName;
    /**
     * @Groups({"api"})
     */
    private ?array $name;

    public static function getEntityDefinition(): array
    {
        return [
            "iso31663" => [
                "isClass" => false,
                "name" => "iso31663",
                "type" => "string",
            ],
            "long_name" => [
                "isClass" => false,
                "name" => "longName",
                "type" => "hstore",
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
     * @return string
     */
    public function getIso31663(): ?string
    {
        return $this->iso31663;
    }

    /**
     * @param string $iso31663
     * @return $this
     */
    public function setIso31663(?string $iso31663): ?self
    {
        $this->iso31663 = $iso31663;
        return $this;
    }

    /**
     * @return array
     */
    public function getLongName(): ?array
    {
        return $this->longName;
    }

    /**
     * @param array $longName
     * @return $this
     */
    public function setLongName(?array $longName): ?self
    {
        $this->longName = $longName;
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
}
