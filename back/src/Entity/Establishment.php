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

use DateTime;
use Symfony\Component\Serializer\Annotation\Groups;

/**
 * Class for establishment entity
 */
class Establishment extends AbstractEntity
{
    public const ENTITY_NAME = "establishment";

    private ?Address $address;
    /**
     * @Groups({"api"})
     */
    private ?int $addressId;
    /**
     * @Groups({"api"})
     */
    private ?bool $administrativeStatus;
    private ?Company $company;
    /**
     * @Groups({"api"})
     */
    private ?int $companyId;
    /**
     * @Groups({"api"})
     */
    private ?DateTime $creationDate;
    /**
     * @Groups({"api"})
     */
    private ?array $description;
    /**
     * @Groups({"api"})
     */
    private ?bool $diffusionStatus;
    /**
     * @Groups({"api"})
     */
    private ?bool $employerNature;
    /**
     * @Groups({"api"})
     */
    private ?int $historyStatusNumber;
    /**
     * @Groups({"api"})
     */
    private ?DateTime $historyStartDate;
    /**
     * @Groups({"api"})
     */
    private ?array $label1;
    /**
     * @Groups({"api"})
     */
    private ?array $label2;
    /**
     * @Groups({"api"})
     */
    private ?array $label3;
    private ?NomenclatureActivity $mainActivity;
    /**
     * @Groups({"api"})
     */
    private ?int $mainActivityId;
    /**
     * @Groups({"api"})
     */
    private ?string $nic;
    /**
     * @Groups({"api"})
     */
    private ?string $phoneFix;
    /**
     * @Groups({"api"})
     */
    private ?string $phoneMobile;
    /**
     * @Groups({"api"})
     */
    private ?int $secondaryAddressId;
    /**
     * @Groups({"api"})
     */
    private ?bool $siege;
    /**
     * @Groups({"api"})
     */
    private ?DateTime $sireneUpdatedDate;
    /**
     * @Groups({"api"})
     */
    private ?string $siret;
    /**
     * @Groups({"api"})
     */
    private ?string $usualName;
    /**
     * @Groups({"api"})
     */
    private ?string $webSite;
    /**
     * @Groups({"api"})
     */
    private ?string $workforceGroup;
    /**
     * @Groups({"api"})
     */
    private ?string $workforceYear;
    private ?string $zVal;

    public static function getEntityDefinition(): array
    {
        return [
            "address" => [
                "isClass" => true,
                "name" => "address",
                "type" => Address::class,
            ],
            "address_id" => [
                "isClass" => false,
                "name" => "addressId",
                "type" => "int",
            ],
            "administrative_status" => [
                "isClass" => false,
                "name" => "administrativeStatus",
                "type" => "bool",
            ],
            "company" => [
                "isClass" => true,
                "name" => "company",
                "type" => Company::class,
            ],
            "company_id" => [
                "isClass" => false,
                "name" => "companyId",
                "type" => "int",
            ],
            "creation_date" => [
                "isClass" => false,
                "name" => "creationDate",
                "type" => DateTime::class,
            ],
            "description" => [
                "isClass" => false,
                "name" => "description",
                "type" => "hstore",
            ],
            "diffusion_status" => [
                "isClass" => false,
                "name" => "diffusionStatus",
                "type" => "bool",
            ],
            "employer_nature" => [
                "isClass" => false,
                "name" => "employerNature",
                "type" => "bool",
            ],
            "history_status_number" => [
                "isClass" => false,
                "name" => "historystatusNumber",
                "type" => "int",
            ],
            "history_start_date" => [
                "isClass" => false,
                "name" => "historyStartDate",
                "type" => DateTime::class,
            ],
            "label_1" => [
                "isClass" => false,
                "name" => "label1",
                "type" => "hstore",
            ],
            "label_2" => [
                "isClass" => false,
                "name" => "label2",
                "type" => "hstore",
            ],
            "label_3" => [
                "isClass" => false,
                "name" => "label3",
                "type" => "hstore",
            ],
            "main_activity" => [
                "isClass" => true,
                "name" => "mainActivity",
                "type" => NomenclatureActivity::class,
            ],
            "main_activity_id" => [
                "isClass" => false,
                "name" => "mainActivityId",
                "type" => "int",
            ],
            "nic" => [
                "isClass" => false,
                "name" => "nic",
                "type" => "string",
            ],
            "phone_fix" => [
                "isClass" => false,
                "name" => "phoneFix",
                "type" => "string",
            ],
            "phone_mobile" => [
                "isClass" => false,
                "name" => "phoneMobile",
                "type" => "string",
            ],
            "secondary_address" => [
                "isClass" => true,
                "name" => "secondaryAddress",
                "type" => Address::class,
            ],
            "secondary_address_id" => [
                "isClass" => false,
                "name" => "secondaryAddressId",
                "type" => "int",
            ],
            "siege" => [
                "isClass" => false,
                "name" => "siege",
                "type" => "bool",
            ],
            "sirene_updated_date" => [
                "isClass" => false,
                "name" => "sireneUpdatedDate",
                "type" => DateTime::class,
            ],
            "siret" => [
                "isClass" => false,
                "name" => "siret",
                "type" => "string",
            ],
            "usual_name" => [
                "isClass" => false,
                "name" => "usualName",
                "type" => "string",
            ],
            "workforce_group" => [
                "isClass" => false,
                "name" => "workforceGroup",
                "type" => "string",
            ],
            "web_site" => [
                "isClass" => false,
                "name" => "webSite",
                "type" => "string",
            ],
            "workforce_year" => [
                "isClass" => false,
                "name" => "workforceYear",
                "type" => "string",
            ],
            "z_val" => [
                "isClass" => false,
                "name" => "zVal",
                "type" => "string",
            ],
        ];
    }

    // Accessors
    // ---------

    /**
     * @return \App\Entity\Address
     */
    public function getAddress(): ?Address
    {
        return $this->address;
    }

    /**
     * @param \App\Entity\Address $address
     * @return $this
     */
    public function setAddress(?Address $address): ?self
    {
        $this->address = $address;
        return $this;
    }

    /**
     * @return int
     */
    public function getAddressId(): ?int
    {
        return $this->addressId;
    }

    /**
     * @param int $addressId
     * @return $this
     */
    public function setAddressId(?int $addressId): ?self
    {
        $this->addressId = $addressId;
        return $this;
    }

    /**
     * @return bool
     */
    public function isAdministrativeStatus(): ?bool
    {
        return $this->administrativeStatus;
    }

    /**
     * @param bool $administrativeStatus
     * @return $this
     */
    public function setAdministrativeStatus(?bool $administrativeStatus): ?self
    {
        $this->administrativeStatus = $administrativeStatus;
        return $this;
    }

    /**
     * @return \App\Entity\Company
     */
    public function getCompany(): ?Company
    {
        return $this->company;
    }

    /**
     * @param \App\Entity\Company $company
     * @return $this
     */
    public function setCompany(?Company $company): ?self
    {
        $this->company = $company;
        return $this;
    }

    /**
     * @return int
     */
    public function getCompanyId(): ?int
    {
        return $this->companyId;
    }

    /**
     * @param int $companyId
     * @return $this
     */
    public function setCompanyId(?int $companyId): ?self
    {
        $this->companyId = $companyId;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getCompanyPartitionCode(): ?string
    {
        return $this->companyPartitionCode;
    }

    /**
     * @param string|null $companyPartitionCode
     * @return $this
     */
    public function setCompanyPartitionCode(?string $companyPartitionCode): self
    {
        $this->companyPartitionCode = $companyPartitionCode;
        return $this;
    }

    /**
     * @return \DateTime
     */
    public function getCreationDate(): ?\DateTime
    {
        return $this->creationDate;
    }

    /**
     * @param \DateTime $creationDate
     * @return $this
     */
    public function setCreationDate(?\DateTime $creationDate): ?self
    {
        $this->creationDate = $creationDate;
        return $this;
    }

    /**
     * @return array|null
     */
    public function getDescription(): ?array
    {
        return $this->description;
    }

    /**
     * @param array|null $description
     * @return $this
     */
    public function setDescription(?array $description): self
    {
        $this->description = $description;
        return $this;
    }

    /**
     * @return bool
     */
    public function isDiffusionStatus(): ?bool
    {
        return $this->diffusionStatus;
    }

    /**
     * @param bool $diffusionStatus
     * @return $this
     */
    public function setDiffusionStatus(?bool $diffusionStatus): ?self
    {
        $this->diffusionStatus = $diffusionStatus;
        return $this;
    }

    /**
     * @return bool
     */
    public function isEmployerNature(): ?bool
    {
        return $this->employerNature;
    }

    /**
     * @param bool $employerNature
     * @return $this
     */
    public function setEmployerNature(?bool $employerNature): ?self
    {
        $this->employerNature = $employerNature;
        return $this;
    }

    /**
     * @return int
     */
    public function getHistoryStatusNumber(): ?int
    {
        return $this->historyStatusNumber;
    }

    /**
     * @param int $historyStatusNumber
     * @return $this
     */
    public function setHistoryStatusNumber(?int $historyStatusNumber): ?self
    {
        $this->historyStatusNumber = $historyStatusNumber;
        return $this;
    }

    /**
     * @return \DateTime
     */
    public function getHistoryStartDate(): ?\DateTime
    {
        return $this->historyStartDate;
    }

    /**
     * @param \DateTime $historyStartDate
     * @return $this
     */
    public function setHistoryStartDate(?\DateTime $historyStartDate): ?self
    {
        $this->historyStartDate = $historyStartDate;
        return $this;
    }

    /**
     * @return array
     */
    public function getLabel1(): ?array
    {
        return $this->label1;
    }

    /**
     * @param array $label1
     * @return $this
     */
    public function setLabel1(?array $label1): ?self
    {
        $this->label1 = $label1;
        return $this;
    }

    /**
     * @return array
     */
    public function getLabel2(): ?array
    {
        return $this->label2;
    }

    /**
     * @param array $label2
     * @return $this
     */
    public function setLabel2(?array $label2): ?self
    {
        $this->label2 = $label2;
        return $this;
    }

    /**
     * @return array
     */
    public function getLabel3(): ?array
    {
        return $this->label3;
    }

    /**
     * @param array $label3
     * @return $this
     */
    public function setLabel3(?array $label3): ?self
    {
        $this->label3 = $label3;
        return $this;
    }

    /**
     * @return \App\Entity\NomenclatureActivity
     */
    public function getMainActivity(): ?NomenclatureActivity
    {
        return $this->mainActivity;
    }

    /**
     * @param \App\Entity\NomenclatureActivity $mainActivity
     * @return $this
     */
    public function setMainActivity(?NomenclatureActivity $mainActivity): ?self
    {
        $this->mainActivity = $mainActivity;
        return $this;
    }

    /**
     * @return int
     */
    public function getMainActivityId(): ?int
    {
        return $this->mainActivityId;
    }

    /**
     * @param int $mainActivityId
     * @return $this
     */
    public function setMainActivityId(?int $mainActivityId): ?self
    {
        $this->mainActivityId = $mainActivityId;
        return $this;
    }

    /**
     * @return string
     */
    public function getNic(): ?string
    {
        return $this->nic;
    }

    /**
     * @param string $nic
     * @return $this
     */
    public function setNic(?string $nic): ?self
    {
        $this->nic = $nic;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getPhoneFix(): ?string
    {
        return $this->phoneFix;
    }

    /**
     * @param string|null $phoneFix
     * @return $this
     */
    public function setPhoneFix(?string$phoneFix): self
    {
        $this->phoneFix = $phoneFix;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getPhoneMobile(): ?string
    {
        return $this->phoneMobile;
    }

    /**
     * @param string|null $phoneMobile
     * @return $this
     */
    public function setPhoneMobile(?string$phoneMobile): self
    {
        $this->phoneMobile = $phoneMobile;
        return $this;
    }

    /**
     * @return \App\Entity\Address
     */
    public function getSecondaryAddress(): ?Address
    {
        return $this->secondaryAddress;
    }

    /**
     * @param \App\Entity\Address $secondaryAddress
     * @return $this
     */
    public function setSecondaryAddress(?Address $secondaryAddress): ?self
    {
        $this->secondaryAddress = $secondaryAddress;
        return $this;
    }

    /**
     * @return int
     */
    public function getSecondaryAddressId(): ?int
    {
        return $this->secondaryAddressId;
    }

    /**
     * @param int $secondaryAddressId
     * @return $this
     */
    public function setSecondaryAddressId(?int $secondaryAddressId): ?self
    {
        $this->secondaryAddressId = $secondaryAddressId;
        return $this;
    }

    /**
     * @return bool|null
     */
    public function getSiege(): ?bool
    {
        return $this->siege;
    }

    /**
     * @param bool|null $siege
     *
     * @return Establishment
     */
    public function setSiege(?bool $siege): Establishment
    {
        $this->siege = $siege;

        return $this;
    }

    /**
     * @return \DateTime
     */
    public function getSireneUpdatedDate(): ?\DateTime
    {
        return $this->sireneUpdatedDate;
    }

    /**
     * @param \DateTime $sireneUpdatedDate
     * @return $this
     */
    public function setSireneUpdatedDate(?\DateTime $sireneUpdatedDate): ?self
    {
        $this->sireneUpdatedDate = $sireneUpdatedDate;
        return $this;
    }

    /**
     * @return string
     */
    public function getSiret(): ?string
    {
        return $this->siret;
    }

    /**
     * @param string $siret
     * @return $this
     */
    public function setSiret(?string $siret): ?self
    {
        $this->siret = $siret;
        return $this;
    }

    /**
     * @return string
     */
    public function getUsualName(): ?string
    {
        return $this->usualName;
    }

    /**
     * @param string $usualName
     * @return $this
     */
    public function setUsualName(?string $usualName): ?self
    {
        $this->usualName = $usualName;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getWebSite(): ?string
    {
        return $this->webSite;
    }

    /**
     * @param string|null $webSite
     * @return $this
     */
    public function setWebSite($webSite): self
    {
        $this->webSite = $webSite;
        return $this;
    }

    /**
     * @return string
     */
    public function getWorkforceGroup(): ?string
    {
        return $this->workforceGroup;
    }

    /**
     * @param string $workforceGroup
     * @return $this
     */
    public function setWorkforceGroup(?string $workforceGroup): ?self
    {
        $this->workforceGroup = $workforceGroup;
        return $this;
    }

    /**
     * @return string
     */
    public function getWorkforceYear(): ?string
    {
        return $this->workforceYear;
    }

    /**
     * @param string $workforceYear
     * @return $this
     */
    public function setWorkforceYear(?string $workforceYear): ?self
    {
        $this->workforceYear = $workforceYear;
        return $this;
    }

    /**
     * @return string|null
     */
    public function getZVal(): ?string
    {
        return $this->zVal;
    }

    /**
     * @param string|null $zVal
     * @return $this
     */
    public function setZVal($zVal): self
    {
        $this->zVal = $zVal;
        return $this;
    }
}
