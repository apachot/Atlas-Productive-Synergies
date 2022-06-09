<?php


namespace App\Controller;

use App\Repository\EntityRepository;
use App\Response\JsonApiResponse;
use App\Response\NotFoundApiResponse;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\SerializerInterface;

/**
 * @Route("/base")
 */
class GenericCrudController extends AbstractController
{
    private EntityRepository $entityRepository;
    private SerializerInterface $serializer;

    /**
     * @Route("/{entityName}/{id}")
     * @param string $entityName
     * @param int    $id
     * @return \App\Response\JsonApiResponse
     */
    public function read(string $entityName, int $id): JsonApiResponse
    {
        $this->entityRepository->setEntityName($entityName);

        if (null === $entity = $this->entityRepository->findOneById($id)) {
            return new NotFoundApiResponse("Element $entityName with id $id does not exist.");
        }

        return new JsonApiResponse(
            $this->serializer->serialize($entity, "json", ["groups" => "api"]),
            200,
            [],
            true
        );
    }

    // System accessors
    // ----------------

    /**
     * @param \App\Repository\EntityRepository $entityRepository
     * @return $this
     * @required
     */
    public function setEntityRepository(\App\Repository\EntityRepository $entityRepository): self
    {
        $this->entityRepository = $entityRepository;
        return $this;
    }

    /**
     * @param \Symfony\Component\Serializer\SerializerInterface $serializer
     * @return $this
     * @required
     */
    public function setSerializer(\Symfony\Component\Serializer\SerializerInterface $serializer): self
    {
        $this->serializer = $serializer;
        return $this;
    }
}
