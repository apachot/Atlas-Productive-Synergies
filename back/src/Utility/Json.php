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

namespace App\Utility;

use JsonException;

/**
 * Fonctions d'encodage JSON avec options usuelles pré-définies.
 */
abstract class Json
{
    private const DEFAULT_OPTIONS = JSON_THROW_ON_ERROR;

    /**
     * @param mixed $value
     * @param int $options
     * @return string
     * @throws JsonException
     */
    public static function encode($value, int $options = 0): string
    {
        return json_encode($value, self::DEFAULT_OPTIONS | $options);
    }

    /**
     * @param string $json
     * @param int $options
     * @return array
     * @throws JsonException
     */
    public static function decode(string $json, int $options = 0): array
    {
        return json_decode($json, true, 512, self::DEFAULT_OPTIONS | $options);
    }
}
