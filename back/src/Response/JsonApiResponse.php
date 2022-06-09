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

namespace App\Response;

use Symfony\Component\HttpFoundation\JsonResponse;

/**
 * Specific response for cross domain request.
 * Override @see JsonResponse
 */
class JsonApiResponse extends JsonResponse
{
    /**
     * @inheritDoc
     */
    public function __construct($data = null, int $status = 200, array $headers = [], bool $json = false)
    {
        $headers["Access-Control-Allow-Origin"] = "*";
        parent::__construct($data, $status, $headers, $json);
    }
}
