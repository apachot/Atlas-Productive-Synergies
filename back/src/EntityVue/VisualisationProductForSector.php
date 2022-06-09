<?php

namespace App\EntityVue;

use App\Entity\NomenclatureProduct;

/**
 * Vue for product for specify sector
 */
class VisualisationProductForSector extends AbstractVue
{
    /**
     * @return array
     */
    final public function getDefinition(): array
    {
        return [
            "type" => "array",
            "className" => NomenclatureProduct::class,
            "specificProperty" => [
                "establishment_count" => [
                    "type" => "integer",
                ],
                "id" => [
                    "type" => "integer",
                ],
            ],
        ];
    }
}
