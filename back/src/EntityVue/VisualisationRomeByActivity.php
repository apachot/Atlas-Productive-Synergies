<?php


namespace App\EntityVue;

use App\Entity\NomenclatureRome;

/**
 * Vue for ling between rome code job and activity
 */
class VisualisationRomeByActivity extends AbstractVue
{
    final public function getDefinition(): array
    {
        return [
            "type" => "array",
            "className" => NomenclatureRome::class,
            "specificProperty" => [
                "activity_code" => [
                    "type" => "string",
                ],
            ],
        ];
    }
}
