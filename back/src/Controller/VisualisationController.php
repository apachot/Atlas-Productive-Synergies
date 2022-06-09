<?php


namespace App\Controller;

use App\Entity\Department;
use App\Entity\Establishment;
use App\Entity\IndustryTerritory;
use App\Entity\NomenclatureRome;
use App\Entity\Product;
use App\Entity\Region;
use App\ExternalApi\Service\IaApiService;
use App\ExternalApi\Service\PoleEmploiApiService;
use App\Repository\DepartmentRepository;
use App\Repository\IndustryTerritoryRepository;
use App\Repository\RegionRepository;
use App\Response\JsonApiResponse;
use App\Service\DatabaseService;
use InvalidArgumentException;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

/**
 * @Route("/visualisation")
 */
class VisualisationController extends AbstractController
{
    private DatabaseService $databaseService;

    /**
     * @var \App\ExternalApi\Service\IaApiService
     */
    private IaApiService $iaApiService;

    /**
     * @var \App\ExternalApi\Service\PoleEmploiApiService
     */
    private PoleEmploiApiService $poleEmploiApiService;

    // Establishment view
    /**
     * @Route("/establishment", methods={"GET"})
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewEstablishment(Request $request): JsonApiResponse
    {
        $params = $request->query->all();
        /** @var \App\Repository\EstablishmentRepository $repository */
        $repository = $this->databaseService->getRepository(Establishment::ENTITY_NAME);
        // visu des entreprises filtrées par zone
        $results = $repository->findByParams($params);

        return new JsonApiResponse($results);
    }

    /**
     * Display establishment that product a product
     *
     * @Route("/establishment/search", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function searchEstablishment(Request $request): JsonApiResponse
    {
        $params = $request->query->all();
        if (!array_key_exists('q', $params)) {
            throw new InvalidArgumentException('You should provide a text query : parameter query `q`');
        }
        /** @var \App\Repository\EstablishmentRepository $repository */
        $repository = $this->databaseService->getRepository(Establishment::ENTITY_NAME);
        $results = $repository->findByParamsWithoutPartners($params);

        return new JsonApiResponse($results);
    }

    /**
     * @Route("/establishment/information/{id}", methods={"GET"})
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @param int                                       $id
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewEstablishmentPartner(Request $request, int $id): JsonApiResponse
    {
        $params = $request->query->all();
        /** @var \App\Repository\EstablishmentRepository $repository */
        $repository = $this->databaseService->getRepository(Establishment::ENTITY_NAME);
        $results = $repository->visualisationPartner($params, $id);

        $results["potential"] = [
            'product' => [], //$this->iaApiService->getProduct($results['siret']),
            'it' => [], //$this->iaApiService->getIt($results['siret'])
        ];

        return new JsonApiResponse($results);
    }

    // Geographic view

    /**
     * @Route("/country", methods={"GET"})
     */
    public function viewCountry(Request $request): JsonApiResponse
    {
        $params = $request->query->all();
        /** @var RegionRepository $regionRepository */
        $regionRepository = $this->databaseService->getRepository(Region::ENTITY_NAME);
        /** @var IndustryTerritoryRepository $industryTerritoryRepository */
        $industryTerritoryRepository = $this->databaseService->getRepository(IndustryTerritory::ENTITY_NAME);
        if (array_key_exists("part", $params)) {
            if ($params["part"] === "region") {
                return new JsonApiResponse(
                    [
                        'region' => $regionRepository->getAll(),
                    ]
                );
            }
            if ($params["part"] === "it") {
                return new JsonApiResponse(
                    [
                        'industry_territory' => $industryTerritoryRepository->getAll(),
                    ]
                );
            }
            if ($params["part"] === "epci") {
                return new JsonApiResponse(
                    [
                        'epci' => $industryTerritoryRepository->getAllEpci(),
                    ]
                );
            }
        }
        return new JsonApiResponse([
            'region' => $regionRepository->getAll(),
            'industry_territory' => $industryTerritoryRepository->getAll(),
            'epci' => $industryTerritoryRepository->getAllEpci(),
        ]);
    }

    /**
     * @Route("/region/{code}", methods={"GET"})
     * @param string $code Code région.
     */
    public function viewRegion(Request $request, string $code): JsonApiResponse
    {
        $params = $request->query->all();
        /** @var RegionRepository $regionRepository */
        $regionRepository = $this->databaseService->getRepository(Region::ENTITY_NAME);
        /** @var DepartmentRepository $departmentRepository */
        $departmentRepository = $this->databaseService->getRepository(Department::ENTITY_NAME);
        /** @var IndustryTerritoryRepository $industryTerritoryRepository */
        $industryTerritoryRepository = $this->databaseService->getRepository(IndustryTerritory::ENTITY_NAME);
        $isIt = true ;
        $isEpci = true ;
        if (array_key_exists("part", $params)) {
            if ($params['part'] ==='it') {
                $isEpci = false ;
            }
            if ($params['part'] ==='epci') {
                $isIt = false ;
            }
        }
        return new JsonApiResponse([
            'region' => $regionRepository->getAll($code),
            'industry_territory' => $isIt ? $industryTerritoryRepository->getAll($code) : [],
            'epci' => $isEpci ?  $industryTerritoryRepository->getAllEpci($code) : [],
        ]);
    }

    // Product view

    /**
     * @Route("/product", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewProducts(Request $request): JsonApiResponse
    {
        $params = $request->query->all();
        /** @var \App\Repository\ProductRepository $repository */
        $repository = $this->databaseService->getRepository(Product::ENTITY_NAME);
        $result = $repository->findProductsBySectorWithValue($params);
        return new JsonApiResponse($result);
    }

    /**
     * @Route("/product/export", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewProductsExport(Request $request): JsonApiResponse
    {
        $params = $request->query->all();
        /** @var \App\Repository\ProductRepository $repository */
        $repository = $this->databaseService->getRepository(Product::ENTITY_NAME);
        $result = $repository->findProductsExportation($params);
        return new JsonApiResponse($result);
    }

    /**
     * @Route("/product/import", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewProductsImport(Request $request): JsonApiResponse
    {
        $params = $request->query->all();
        /** @var \App\Repository\ProductRepository $repository */
        $repository = $this->databaseService->getRepository(Product::ENTITY_NAME);
        $result = $repository->findProductsImportation($params);
        return new JsonApiResponse($result);
    }

    /**
     * Generic part for product display (proximity or kinship)
     *
     * @param Request $request
     * @param string $hs4
     * @return JsonApiResponse
     * @throws \Exception
     */
    protected function viewProductGeneric(Request $request, string $hs4, bool $byProximity): JsonApiResponse
    {
        $params = $request->query->all();
        /** @var \App\Repository\ProductRepository $repository */
        $repository = $this->databaseService->getRepository(Product::ENTITY_NAME);
        $out = $repository->findProductAndNearLvl($hs4, $byProximity, $params);

        // Search needs - api call
        $localisation = array_intersect_key($params, array_flip(['region', 'department', 'industry_territory']));
        $needs = [];
        $hs4s = $out['hs4s'];
        unset($out['hs4s']);
        $apiNeeds = $this->iaApiService->getProductsNeed($hs4s, $localisation);
        foreach ($apiNeeds as $hs4Key => $hs4Value) {
            $needs[$hs4Key] = $hs4Value['need'];
        }
        if (count($out['proximities']) > 0) {
            foreach ($out['proximities'] as &$loopProximity) {
                $loopProximity['need'] = $needs[$loopProximity['code_hs4']];
            }
            unset($loopProximity);
        }
        $out['product']['need'] = $needs[$hs4];
        unset($needs[$hs4]);
        $out['needs'] = $needs;

        return new JsonApiResponse($out);
    }

    /**
     * Display a single product with kinship
     *
     * @Route("/product/{hs4}", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewProduct(Request $request, string $hs4): JsonApiResponse
    {
        return $this->viewProductGeneric($request, $hs4, false);
    }

    /**
     * Display a single product with proximity
     *
     * @Route("/product/{hs4}/proximity", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewProductProximity(Request $request, string $hs4): JsonApiResponse
    {
        return $this->viewProductGeneric($request, $hs4, true);
    }
    /**
     * Display establishment that product a product
     *
     * @Route("/product/{hs4}/establishment", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewProductEstablishment(Request $request, string $hs4): JsonApiResponse
    {

        $params = $request->query->all();
        /** @var \App\Repository\ProductRepository $repository */
        $repository = $this->databaseService->getRepository(Product::ENTITY_NAME);

        $results = $repository->findByHs4($params, $hs4);

        return new JsonApiResponse($results);
    }

    // Job view

    /**
     * Display jobs rome
     *
     * @Route("/job", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewJob(Request $request): JsonApiResponse
    {
        $params = $request->query->all();

        /** @var \App\Repository\NomenclatureRomeRepository $repRome */
        $repRome = $this->databaseService->getRepository(NomenclatureRome::ENTITY_NAME);
        $jobs = $repRome->listJobsWithValue($params);
        return new JsonApiResponse($jobs);
    }

    /**
     * Display job detail
     *
     * @Route("/job/information/{rome}", methods="GET")
     * @param \Symfony\Component\HttpFoundation\Request $request
     * @param string $rome
     * @return \App\Response\JsonApiResponse
     * @throws \JsonException
     */
    public function viewJobInformation(Request $request, string $rome): JsonApiResponse
    {
        /** @var \App\Repository\NomenclatureRomeRepository $repRome */
        $repRome = $this->databaseService->getRepository(NomenclatureRome::ENTITY_NAME);
        $params = $request->query->all();
        $params['rome'] = $rome;
        $lang = $params['lang'] ?? 'en';
        return new JsonApiResponse([
            'link' => $repRome->jobLinkInformation($rome, $lang),
            'info' => $this->poleEmploiApiService->readFromRome($rome),
            'count' => $repRome->countEntity($params)
        ]);
    }

    // ROME view

    /**
     * @Route("/competence", methods="GET")
     * @return \App\Response\JsonApiResponse
     * @throws \Exception
     */
    public function viewCompetence(): JsonApiResponse
    {
        /** @var \App\Repository\NomenclatureRomeRepository $repository */
        $repository = $this->databaseService->getRepository(NomenclatureRome::ENTITY_NAME);
        $result = $repository->allByNomenclatureActivity();

        return new JsonApiResponse($result->container);
    }

    // System accessors
    // ----------------

    /**
     * @param \App\Service\DatabaseService $databaseService
     * @return $this
     * @required
     */
    public function setDatabaseService(DatabaseService $databaseService): self
    {
        $this->databaseService = $databaseService;
        return $this;
    }

    /**
     * @param \App\ExternalApi\Service\IaApiService $iaApiService
     * @return $this
     * @required
     */
    public function setIaApiService(IaApiService $iaApiService): self
    {
        $this->iaApiService = $iaApiService;
        return $this;
    }

    /**
     * @param \App\ExternalApi\Service\PoleEmploiApiService $poleEmploiApiService
     * @return $this
     * @required
     */
    public function setPoleEmploiApiService(PoleEmploiApiService $poleEmploiApiService): self
    {
        $this->poleEmploiApiService = $poleEmploiApiService;
        return $this;
    }

}
