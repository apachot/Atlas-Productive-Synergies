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

use Exception;
use phpDocumentor\Reflection\Types\This;
use Symfony\Contracts\HttpClient\HttpClientInterface;

class PoleEmploiApiService
{
    private string $apiId;
    private string $apiSecret;
    private string $apiScopeRome;
    private string $apiRealm;
    private string $apiGrantType;
    private string $apiConnexionUrl;
    private string $apiEntrepriseUrl;

    private string $apiAccessToken;
    private HttpClientInterface $httpClient;

    // Public method
    //-----------------


    /**
     * @param string $rome
     * @return array|null
     */
    public function readFromRome(string $rome): ?array
    {
        try {
            $rome = (!strpos($rome,"-")) ? $rome : substr($rome,0, strpos($rome,"-")) ;
            $this->connexionRome();
            $response = $this->httpClient->request(
                "GET",
                "{$this->apiEntrepriseUrl}rome/v1/metier/$rome",
                [
                    "headers" => [
                        "Authorization" => "Bearer {$this->apiAccessToken}",
                        "Accept" => "application/json",
                    ]
                ]
            );
            return json_decode($response->getContent(), true, 512, JSON_THROW_ON_ERROR);
        } catch (Exception $e) {
            return [];
        }
    }


    // Private method
    //-----------------

    /**
     * Get access token from api
     * @throws \JsonException
     * @throws \Symfony\Contracts\HttpClient\Exception\ClientExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\RedirectionExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\ServerExceptionInterface
     * @throws \Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface
     */
    private function connexionRome(): void
    {
        $response = $this->httpClient->request(
            "POST",
            $this->apiConnexionUrl,
            [
                "query" => [
                    "realm" => $this->apiRealm,
                ],
                "body" => "grant_type={$this->apiGrantType}" .
                    "&client_id={$this->apiId}" .
                    "&client_secret={$this->apiSecret}" .
                    "&scope=application_{$this->apiId} {$this->apiScopeRome}",
                "headers" => [
                    "Content-Type" => "application/x-www-form-urlencoded",
                ],
            ]
        );
        $content = $response->getContent();
        $content = json_decode($content, true, 512, JSON_THROW_ON_ERROR);
        $this->setApiAccessToken($content["access_token"]);
    }

    // System accessors
    //-----------------


    /**
     * @param string $apiId
     * @return PoleEmploiApiService
     */
    public function setApiId(string $apiId): PoleEmploiApiService
    {
        $this->apiId = $apiId;
        return $this;
    }

    /**
     * @param string $apiSecret
     * @return PoleEmploiApiService
     */
    public function setApiSecret(string $apiSecret): PoleEmploiApiService
    {
        $this->apiSecret = $apiSecret;
        return $this;
    }

    /**
     * @param string $apiScopeRome
     * @return PoleEmploiApiService
     */
    public function setApiScopeRome(string $apiScopeRome): PoleEmploiApiService
    {
        $this->apiScopeRome = $apiScopeRome;
        return $this;
    }

    /**
     * @param string $apiRealm
     * @return PoleEmploiApiService
     */
    public function setApiRealm(string $apiRealm): PoleEmploiApiService
    {
        $this->apiRealm = $apiRealm;
        return $this;
    }

    /**
     * @param string $apiGrantType
     * @return PoleEmploiApiService
     */
    public function setApiGrantType(string $apiGrantType): PoleEmploiApiService
    {
        $this->apiGrantType = $apiGrantType;
        return $this;
    }

    /**
     * @param string $apiConnexionUrl
     * @return PoleEmploiApiService
     */
    public function setApiConnexionUrl(string $apiConnexionUrl): PoleEmploiApiService
    {
        $this->apiConnexionUrl = $apiConnexionUrl;
        return $this;
    }

    /**
     * @param string $apiEntrepriseUrl
     * @return PoleEmploiApiService
     */
    public function setApiEntrepriseUrl(string $apiEntrepriseUrl): PoleEmploiApiService
    {
        $this->apiEntrepriseUrl = $apiEntrepriseUrl;
        return $this;
    }

    /**
     * @param string $apiAccessToken
     * @return PoleEmploiApiService
     */
    public function setApiAccessToken(string $apiAccessToken): PoleEmploiApiService
    {
        $this->apiAccessToken = $apiAccessToken;
        return $this;
    }

    /**
     * @param HttpClientInterface $httpClient
     * @return This
     * @required
     */
    public function setHttpClient(HttpClientInterface $httpClient): self
    {
        $this->httpClient = $httpClient;
        return $this;
    }

}