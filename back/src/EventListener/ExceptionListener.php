<?php


namespace App\EventListener;

use App\Response\JsonApiResponse;
use App\Response\NotFoundApiResponse;
use Symfony\Component\HttpKernel\Event\ExceptionEvent;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

/**
 * Listener on kernel exception
 */
class ExceptionListener
{
    private bool $debug;

    public function  __construct($debug)
    {
        $this->debug = (bool) $debug;
    }
    
    /**
     * Replace standard response or exception for JsonApiResponse.
     * @param \Symfony\Component\HttpKernel\Event\ExceptionEvent $event
     */
    public function onKernelException(ExceptionEvent  $event): void
    {
        $response = $event->getResponse();
        if (!$response) {
            $exception = $event->getThrowable();
            if ($exception instanceof NotFoundHttpException) {
                $response = new NotFoundApiResponse();
            } else {
                $message = [
                    'message' => $exception->getMessage()
                ];
                if ($this->debug) {
                    $message['code'] = $exception->getCode();
                    $message['file'] = $exception->getFile();
                    $message['line'] = $exception->getLine();
                    $message['trace'] = $exception->getTraceAsString();
                }
                $response = new JsonApiResponse($message, 500);
            }
        }
        $response->headers->set("Access-Control-Allow-Origin", "*");
        $event->setResponse($response);
    }
}
