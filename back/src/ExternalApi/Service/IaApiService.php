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

namespace App\ExternalApi\Service;

use Symfony\Contracts\HttpClient\HttpClientInterface;

/**
 * Ia Api service to get recommendation for an establishment
 */
class IaApiService
{
    private string $apiURL;

    private HttpClientInterface $httpClient;

    /**
     * @param string[] $siret
     *
     * @return array
     * @throws \JsonException
     */
    public function getPartner(array $sirets): array
    {
        return $this->call('partner', $sirets);
    }

    /**
     * @param string[] $siret
     *
     * @return array
     * @throws \JsonException
     */
    public function getProduct(array $sirets): array
    {
        return $this->call('produit', $sirets);
    }

    /**
     * @param string[] $siret
     *
     * @return array
     * @throws \JsonException
     */
    public function getIt(array $sirets): array
    {
        return $this->call('territoire', $sirets);
    }

    /**
     * Get needs for a product list
     *
     * @param array $hs4s
     * @param array $localisation
     *
     * @return mixed
     * @throws \JsonException
     * @throws \Symfony\Contracts\HttpClient\Exception\ClientExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\RedirectionExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\ServerExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface
     */
    public function getProductsNeed(array $hs4s, array $localisation = [])
    {
        $response = $this->httpClient->request(
            "POST",
            "{$this->apiURL}/besoin-produits",
            [
                'query' => $localisation,
                'body' => json_encode($hs4s, JSON_THROW_ON_ERROR),
            ]
        );

        return json_decode($response->getContent(), true, 512, JSON_THROW_ON_ERROR);
    }

    /**
     * @param string $type
     * @param string[] $sirets
     *
     * @return array
     * @throws \JsonException
     * @throws \Symfony\Contracts\HttpClient\Exception\ClientExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\RedirectionExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\ServerExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface
     */
    protected function call(string $type, array $sirets): array
    {
        $response = $this->httpClient->request(
            "POST",
            "{$this->apiURL}/$type",
            [
                'body' => json_encode($sirets, JSON_THROW_ON_ERROR),
            ]
        );

        return json_decode($response->getContent(), true, 512, JSON_THROW_ON_ERROR);
    }

    // System accessors
    //-----------------

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
