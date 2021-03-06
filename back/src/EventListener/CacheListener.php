<?php


namespace App\EventListener;

use Psr\Cache\CacheItemPoolInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpKernel\Event\KernelEvent;
use Symfony\Component\HttpKernel\Event\RequestEvent;
use Symfony\Component\HttpKernel\Event\ResponseEvent;

class CacheListener
{
    public const NO_CACHE_HEADER = 'X-API-NO-CACHE';
    public const CLEAR_CACHE_HEADER = 'X-API-CLEAR-CACHE';
    private const STAMP_HEADER = 'X-API-CACHE';

    private bool $enable;
    private bool $debug;
    private int $cacheTtls;

    private CacheItemPoolInterface $cache;


    public function  __construct(bool $enable, bool $debug, int $cacheTtl, CacheItemPoolInterface $cache)
    {
        $this->enable = $enable;
        $this->debug = $debug;
        $this->cacheTtls = $cacheTtl;
        $this->cache = $cache;
    }

    public function onKernelRequest(RequestEvent $event)
    {
        if (!$this->enable) {
            return;
        }

        $request = $event->getRequest();
        if ($this->debug && $request->headers->has(self::CLEAR_CACHE_HEADER)) {
            $this->cache->clear();
            return;
        }

        if (false === $cacheKey = $this->getCacheKey($event)) {
            return;
        }

        $cacheKey = sha1($request->getUri());
        $cachedResponse = $this->cache->getItem($cacheKey);
        if (!$cachedResponse->isHit()) {
            return;
        }

        $event->setResponse($cachedResponse->get());
    }

    public function onKernelResponse(ResponseEvent $event)
    {
        if (!$this->enable) {
            return;
        }

        if (false === $cacheKey = $this->getCacheKey($event)) {
            return;
        }

        $response = $event->getResponse();
        // if response come from cache or is not successful
        if ($response->headers->has(self::STAMP_HEADER) || !$response->isSuccessful()) {
            return;
        }

        $cachedResponse = $this->cache->getItem($cacheKey);
        if ($cachedResponse->isHit()) {
            // alreedy in cache
            return;
        }

        // add cache entry
        $response->headers->add(['X-API-CACHE' => (new \DateTime())->format('Y-m-d h:i:s')]);
        // cache publicly for 3600 seconds
        $response->setPublic();
        $response->setMaxAge($this->cacheTtls);

        $cachedResponse->set($event->getResponse());
        $cachedResponse->expiresAfter($this->cacheTtls);
        $this->cache->save($cachedResponse);
    }

    /**
     * Return the cache key if the request could be cached elseif false is returned
     *
     * @param \Symfony\Component\HttpKernel\Event\KernelEvent $event
     *
     * @return string|bool
     */
    private function getCacheKey(KernelEvent $event)
    {
        if (!$event->isMasterRequest()) {
            return false;
        }

        $request = $event->getRequest();
        if (!$request->isMethod(Request::METHOD_GET)) {
            return false;
        }

        if (!$request || !$request->isMethod(Request::METHOD_GET)) {
            return false;
        }

        if ($request->headers->has(self::NO_CACHE_HEADER)) {
            return false;
        }

        return sha1($request->getUri());
    }
}
