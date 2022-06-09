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
 * Class for industry_territory entity
 */
class IndustryTerritory extends AbstractEntity
{
    public const ENTITY_NAME = "industry_territory";

    /**
     * @Groups({"api"})
     */
    private ?array $name;
    /**
     * @Groups({"api"})
     */
    private ?string $nationalIdentifying;

    /**
     * @inheritDoc
     */
    public static function getEntityDefinition(): array
    {
        return [
            "national_identifying" => [
                "isClass" => false,
                "name" => "nationalIdentifying",
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
     * @return string
     */
    public function getNationalIdentifying(): string
    {
        return $this->nationalIdentifying;
    }

    /**
     * @param string $nationalIdentifying
     * @return $this
     */
    public function setNationalIdentifying(?string $nationalIdentifying): self
    {
        $this->nationalIdentifying = $nationalIdentifying;
        return $this;
    }

    /**
     * @return array
     */
    public function getName(): array
    {
        return $this->name;
    }

    /**
     * @param array $name
     * @return $this
     */
    public function setName(?array $name): self
    {
        $this->name = $name;
        return $this;
    }
}
