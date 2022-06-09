<?php


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
