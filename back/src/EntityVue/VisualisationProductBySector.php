<?php


namespace App\EntityVue;

use App\Entity\MacroSector;

/**
 * Vue for product indexed by sector
 */
class VisualisationProductBySector extends AbstractVue
{
    /**
     * @return array
     */
    final public function getDefinition(): array
    {
        return [
            "type" => "array",
            "className" => MacroSector::class,
            "specificProperty" => [
                "product_number" => [
                    "type" => "integer",
                ],
            ],
        ];
    }
}
