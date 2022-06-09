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
