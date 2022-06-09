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

namespace App\EntityVue;

use App\Entity\Address;
use App\Entity\Establishment;

/**
 * Vue for establishment
 */
class VisualisationEstablishment extends AbstractVue
{
    final public function getDefinition(): array
    {
        return [
            "type" => "array",
            "className" => Establishment::class,
            "specificProperty" => [
                "coordinates" => [
                    "type" => "point",
                ],
                "activity_code" => [
                    "type" => "string",
                ],
                "activity_name" => [
                    "type" => "hstore",
                ],
                "sector_id" => [
                    "type" => "int",
                ],
                "sector_code" => [
                    "type" => "string",
                ],
                "sector_name" => [
                    "type" => "hstore",
                ],
                "workforce_group" => [
                    "type" => "string"
                ],
            ],
            "subProperty" => [
                "supplier" => [
                    "type" => "array",
                    "specificProperty" => [
                        [
                            "type" => "string",
                        ],
                        [
                            "type" => "string",
                        ],
                    ],
                ],
                "client" => [
                    "type" => "array",
                    "specificProperty" => [
                        [
                            "type" => "string",
                        ],
                        [
                            "type" => "string",
                        ],
                    ],
                ],
            ],
        ];
    }
}
