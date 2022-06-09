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

use App\Entity\Establishment;

class VisualisationEstablishmentPartner extends AbstractVue
{
    final public function getDefinition(): array
    {
        $partnerDef = [
            "type" => "array",
            "specificProperty" => [
                "id" => [
                    "type" => "int",
                ],
                "siret" => [
                    "type" => "string",
                ],
                "usual_name" => [
                    "type" => "string",
                ],
                "coordinates" => [
                    "type" => "point",
                ],
                "sector_id" => [
                    "type" => "int",
                ],
                "workforce_group" => [
                    "type" => "string",
                ],
            ]
        ];

        return [
            "type" => "single",
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
                    "type" => "string",
                ],
                "sector_code" => [
                    "type" => "string",
                ],
                "sector_name" => [
                    "type" => "hstore",
                ],
                "way" => [
                    "type" => "string",
                ],
                "complement" => [
                    "type" => "string",
                ],
                "zip" => [
                    "type" => "string",
                ],
                "naf_description" => [
                    "type" => "string",
                ]
            ],
            "subProperty" => [
                "partner" => $partnerDef,
            ]
        ];
    }
}