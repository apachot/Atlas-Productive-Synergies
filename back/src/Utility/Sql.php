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

use RuntimeException;

/**
 * Fonctions utilitaires SQL.
 */
abstract class Sql
{
    /**
     * Lie des clauses avec AND pour utilisation dans un WHERE.
     *
     * @param string[] $expressions
     * @return string
     */
    public static function makeWhere(array $expressions): string
    {
        if (empty($expressions)) {
            $expressions = ['TRUE'];
        }

        return implode(' AND ', $expressions);
    }

    /**
     * créer une entrée pour un select sur un hstore i18n
     * @param string $field le nom de la colone : name ou table.name
     * @param array|string $params si `string` : code langue ou si `array` on utilise l'élément avec la clé `lang`
     * @param string|null $alias alias, si `null` on le détermine depuis le `$field`, si chaine vide pas d'alias
     * @return string
     */
    public static function makeI18nSelect(string $field, $params, string $alias = null): string
    {
        // get lang
        $i18n = 'en';
        if (is_string($params)) {
            $i18n = $params;
        }
        if (is_array($params) && array_key_exists('lang', $params)) {
            $i18n = $params['lang'];
        }
        if (!in_array($i18n, ['fr', 'en'])) {
            throw new RuntimeException('Invalid code lang');
        }

        // select
        $select = "{$field} -> 'fr'";
        if ($i18n !== 'fr') {
            $select = "COALESCE({$field} -> '{$i18n}', {$field} -> 'fr')";
        }

        // add alias
        if (null === $alias) {
            $array = explode('.', $field);
            $alias = array_pop($array);
        }

        return empty($alias) ? $select : "{$select} AS {$alias}";
    }


}
