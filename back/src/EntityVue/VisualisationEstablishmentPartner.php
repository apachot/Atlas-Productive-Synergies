<?php


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
