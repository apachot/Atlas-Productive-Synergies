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
