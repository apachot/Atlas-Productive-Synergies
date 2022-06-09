<?php


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
