<?php


namespace App\Response;

use Symfony\Component\HttpFoundation\Response;

/**
 * Specific response Not found response.
 * Override @see JsonApiResponse
 */
class NotFoundApiResponse extends JsonApiResponse
{
    /**
     * @inheritDoc
     */
    public function __construct($message = "404 Not Found", array $headers = [], bool $json = false)
    {
        parent::__construct(['message' => $message], Response::HTTP_NOT_FOUND, $headers, $json);
    }
}
