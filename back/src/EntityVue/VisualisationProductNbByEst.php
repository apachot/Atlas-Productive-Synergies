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
use App\Entity\NomenclatureProduct;

class VisualisationProductNbByEst extends AbstractVue
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
                "sector_id" => [
                    "type" => "int",
                ],
                "product_count" => [
                    "type" => "int"
                ],
            ],
            "subProperty" => [
                "products" => [
                    "type" => "array_agg",
                    "className" => NomenclatureProduct::class,
                    "property" => [
                        "id",
                        "code_hs4",
                        "code_nc",
                        "name",
                        "chapter_id",
                        "chapter_name"
                    ],
                    "specificType" => [
                        "chapter_id" => [
                            "type" => "int",
                        ],
                        "chapter_name" => [
                            "type" => "hstore",
                        ],
                    ],
                ],
                "proximity" => [
                    "type" => "array",
                    "property" => [
                        "activity_code",
                        "activity_name",
                        "coordinate",
                        "sector_code",
                        "siret",
                    ],
                    "specificProperty" => [
                        "activity_code" => [
                            "type" => "string",
                        ],
                        "activity_name" => [
                            "type" => "hstore",
                        ],
                        "coordinate" => [
                            "type" => "point",
                            "specificProperty" => [
                                [
                                    "type" => "string",
                                ],
                                [
                                    "type" => "string",
                                ],
                            ],
                        ],
                        "sector_code" => [
                            "type" => "string",
                        ],
                        "siret" => [
                            "type" => "string",
                        ],
                    ],
                ],
            ],
        ];
    }
}
