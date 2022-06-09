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
 * Class for nomenclature_product_section
 */
class NomenclatureProductSection extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_product_section";

    /**
     * @Groups({"api"})
     */
    private ?array $name;
    /**
     * @Groups({"api"})
     */
    private ?string $shortName;

    public static function getEntityDefinition(): array
    {
        return [
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
            ],
            "short_name" => [
                "isClass" => false,
                "name" => "ShortName",
                "type" => "string",
            ],
        ];
    }

    // Accessors
    // ---------

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
     * @return string
     */
    public function getShortName(): ?string
    {
        return $this->shortName;
    }

    /**
     * @param string $shortName
     * @return $this
     */
    public function setShortName(?string $shortName): ?self
    {
        $this->shortName = $shortName;
        return $this;
    }
}
