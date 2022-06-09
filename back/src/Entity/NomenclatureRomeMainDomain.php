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
 * Class for nomenclature_rome_main_domain entity
 */
class NomenclatureRomeMainDomain extends AbstractEntity
{
    public const ENTITY_NAME = "nomenclature_rome_main_domain";

    /**
     * @Groups({"api"})
     */
    private ?string $code;
    /**
     * @Groups({"api"})
     */
    private ?string $name;

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
}
