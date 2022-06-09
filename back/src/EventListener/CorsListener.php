<?php

declare(strict_types=1);

namespace App\EventListener;

use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Event\ExceptionEvent;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\Event\ResponseEvent;
use Symfony\Component\HttpKernel\KernelEvents;


final class CorsListener implements EventSubscriberInterface
{
    public static function getSubscribedEvents(): array
    {
        return [
            KernelEvents::REQUEST => ['onKernelRequest', 9999],
            KernelEvents::RESPONSE => ['onKernelResponse', 9999],
            KernelEvents::EXCEPTION => ['onKernelException', 9999],
        ];
    }

    public function onKernelException(ExceptionEvent $event): void
    {
        $response = $event->getResponse();
        if ($response) {
            $response->headers->set('Access-Control-Allow-Origin', '*');
            $response->headers->set('Access-Control-Allow-Methods', 'GET,POST,PUT,PATCH');
            $response->headers->set('Access-Control-Allow-Headers', 'content-type');
        }
    }

    public function onKernelRequest(RequestEvent $event): void
    {
        // Don't do anything if it's not the master request.
        if (!$event->isMainRequest()) {
            return;
        }

        $request = $event->getRequest();
        $method = $request->getRealMethod();

        if (Request::METHOD_OPTIONS === $method) {
            $response = new Response();
            $event->setResponse($response);
        }
    }

    public function onKernelResponse(ResponseEvent $event): void
    {
        // Don't do anything if it's not the master request.
        if (!$event->isMainRequest()) {
            return;
        }

        $response = $event->getResponse();
        if ($response) {
            $response->headers->set('Access-Control-Allow-Origin', '*');
            $response->headers->set('Access-Control-Allow-Methods', 'GET,POST,PUT,PATCH');
            $response->headers->set('Access-Control-Allow-Headers', 'content-type');
        }
    }
}