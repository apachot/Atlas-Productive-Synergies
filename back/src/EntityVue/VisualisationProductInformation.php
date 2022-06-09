<?php


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
