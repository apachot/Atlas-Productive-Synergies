<?php


namespace App\ExternalApi\Service;

use Symfony\Contracts\HttpClient\HttpClientInterface;

class InseeApiService
{
    private string $consumerKey;
    private string $consumerSecret;
    private string $token;
    private int $tokenExpiration;
    private string $apiURL;
    private \DateTime $startCall;
    private int $callNumber = 0;

    private HttpClientInterface $httpClient;

    public function readFromSiren(string $siren): ?array
    {
        $this->connexion();
        $this->checkRateLimit();

        $response = $this->httpClient->request(
            "GET",
            "{$this->apiURL}/entreprises/sirene/V3/siren/$siren",
            [
                "auth_bearer" => $this->token,
                "headers" => [
                    "Accept" => "application/json",
                ]
            ]
        );

        return json_decode($response->getContent(), true, 512, JSON_THROW_ON_ERROR);
    }

    public function readFromSiret(string $siret): ?array
    {
        $this->connexion();
        $this->checkRateLimit();

        $response = $this->httpClient->request(
            "GET",
            "{$this->apiURL}/entreprises/sirene/V3/siret/$siret",
            [
                "auth_bearer" => $this->token,
                "headers" => [
                    "Accept" => "application/json",
                ]
            ]
        );

        return json_decode($response->getContent(), true, 512, JSON_THROW_ON_ERROR);
    }

    /**
     * Get access token from insee api
     * @throws \JsonException
     * @throws \Symfony\Contracts\HttpClient\Exception\ClientExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\RedirectionExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\ServerExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface
     */
    private function connexion(): void
    {
        $response = $this->httpClient->request(
            "POST",
            "{$this->apiURL}/token",
            [
                "auth_basic" => [$this->consumerKey, $this->consumerSecret],
                "body" => "grant_type=client_credentials",
            ]
        );
        $content = $response->getContent();
        $content = json_decode($content, true, 512, JSON_THROW_ON_ERROR);
        $this->token = $content["access_token"];
        $this->tokenExpiration = $content["expires_in"];
    }

    private function checkRateLimit(): void
    {
        if (!isset($this->startCall)) {
            $this->startCall = new \DateTime();
            $this->callNumber = 0;
            return;
        }

        if (30 === $this->callNumber) {
            $endCall = $this->startCall;
            $endCall->add(new \DateInterval("PT1M"));
            $wait = $endCall->diff(new \DateTime());
            sleep(10 + $wait->s);
            $this->callNumber = 0;
            $this->startCall = new \DateTime();
        }
        $this->callNumber++;
    }

    // System accessors
    //-----------------

    /**
     * @param string $consumerKey
     * @return $this
     */
    public function setConsumerKey(string $consumerKey): self
    {
        $this->consumerKey = $consumerKey;
        return $this;
    }

    /**
     * @param string $consumerSecret
     * @return $this
     */
    public function setConsumerSecret(string $consumerSecret): self
    {
        $this->consumerSecret = $consumerSecret;
        return $this;
    }

    /**
     * @param \Symfony\Contracts\HttpClient\HttpClientInterface $httpClient
     * @return $this
     * @required
     */
    public function setHttpClient(\Symfony\Contracts\HttpClient\HttpClientInterface $httpClient): self
    {
        $this->httpClient = $httpClient;
        return $this;
    }

    /**
     * @param string $apiURL
     * @return $this
     */
    public function setApiURL(string $apiURL): self
    {
        $this->apiURL = $apiURL;
        return $this;
    }
}
