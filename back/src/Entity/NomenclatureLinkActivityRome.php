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
