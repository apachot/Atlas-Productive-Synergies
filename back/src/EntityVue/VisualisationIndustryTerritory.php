<?php



namespace App\EntityVue;

use App\Entity\Establishment;

/**
 * Vue for industry territory
 */
class VisualisationIndustryTerritory extends AbstractVue
{
    /**
     * @return array
     */
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
                    "type" => "string",
                ],
                "sector_id" => [
                    "type" => "string",
                ],
                "sector_name" => [
                    "type" => "string",
                ],
            ],
        ];
    }
}
