<?php


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
