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

namespace App\Entity;

use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for region entity
 */
class Region extends AbstractEntity
{
    public const ENTITY_NAME = "region";

    public const DEPARTMENT_CODE = [
        "01" => ["971"],
        "02" => ["972"],
        "03" => ["973"],
        "04" => ["974"],
        "06" => ["976"],
        "11" => ["75","77","78","91","92","93","94","95"],
//        "11" => ["75101","75102","75103","75104","75105","75106","75107","75108","75109","75110","75111","75112",
//            "75113","75114","75115","75116","75117","75118","75119","75120","77","78","91","92","93","94","95"],
        "24" => ["18","28","36","37","41","45"],
        "27" => ["21","25","39","58","70","71","89","90"],
        "28" => ["14","27","50","61","76"],
        "32" => ["02","59","60","62","80"],
        "44" => ["08","10","51","52","54","55","57","67","68","88"],
        "52" => ["44","49","53","72","85"],
        "53" => ["22","29","35","56"],
        "75" => ["16","17","19","23","24","33","40","47","64","79","86","87"],
        "76" => ["09","11","12","30","31","32","34","46","48","65","66","81","82"],
        "84" => ["01","03","07","15","26","38","42","43","63","69","73","74"],
        "93" => ["04","05","06","13","83","84"],
        "94" => ["2A","2B"],
        "COM" => ["975","977","978","984","986","987","988","989"],
    ];

    /**
     * @Groups({"api"})
     */
    private ?string $code;
    private ?Country $country;
    /**
     * @Groups({"api"})
     */
    private ?int $countryId;
    /**
     * @Groups({"api"})
     */
    private ?array $name;
    /**
     * @Groups({"api"})
     */
    private ?string $slug;

    public static function getEntityDefinition(): array
    {
        return [
            "code" => [
                "isClass" => false,
                "name" => "code",
                "type" => "string",
            ],
            "country" => [
                "isClass" => true,
                "name" => "country",
                "type" => Country::class,
            ],
            "country_id" => [
                "isClass" => false,
                "name" => "countryId",
                "type" => "int",
            ],
            "name" => [
                "isClass" => false,
                "name" => "name",
                "type" => "hstore",
            ],
            "slug" => [
                "isClass" => false,
                "name" => "slug",
                "type" => "string",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return string
     */
    public function getCode(): ?string
    {
        return $this->code;
    }

    /**
     * @param string $code
     * @return $this
     */
    public function setCode(?string $code): ?self
    {
        $this->code = $code;
        return $this;
    }

    /**
     * @return \App\Entity\Country
     */
    public function getCountry(): ?Country
    {
        return $this->country;
    }

    /**
     * @param \App\Entity\Country $country
     * @return $this
     */
    public function setCountry(?Country $country): ?self
    {
        $this->country = $country;
        return $this;
    }

    /**
     * @return int
     */
    public function getCountryId(): ?int
    {
        return $this->countryId;
    }

    /**
     * @param int $countryId
     * @return $this
     */
    public function setCountryId(?int $countryId): ?self
    {
        $this->countryId = $countryId;
        return $this;
    }

    /**
     * @return array
     */
    public function getName(): ?array
    {
        return $this->name;
    }

    /**
     * @param array $name
     * @return $this
     */
    public function setName(?array $name): ?self
    {
        $this->name = $name;
        return $this;
    }

    /**
     * @return string
     */
    public function getSlug(): ?string
    {
        return $this->slug;
    }

    /**
     * @param string $slug
     * @return $this
     */
    public function setSlug(?string $slug): ?self
    {
        $this->slug = $slug;
        return $this;
    }
}
