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

use App\Entity\NomenclatureProduct;

/**
 * Vue for product information, proximity and establishment
 */
class VisualisationProductInformation extends AbstractVue
{
    /**
     * @return array
     */
    final public function getDefinition(): array
    {
        return [
            "type" => "single",
            "className" => NomenclatureProduct::class,
            "specificProperty" => [
                "establishment_count" => [
                    "type" => "integer",
                ],
            ],
            "subProperty" => [
                "proximity" => [
                    "type" => "array",
                    "className" => NomenclatureProduct::class,
                    "property" => [
                        "name" => "name",
                        "code_nc" => "code_nc",
                        "proximity" => "proximity",
                    ],
                    "specificType" => [
                        "proximity" => [
                            "type" => "int",
                        ],
                    ],
                ],
            ],
        ];
    }
}
