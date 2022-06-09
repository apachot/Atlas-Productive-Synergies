<?php


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
