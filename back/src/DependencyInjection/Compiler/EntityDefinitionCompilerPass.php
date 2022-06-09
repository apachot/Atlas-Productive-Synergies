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

namespace App\DependencyInjection\Compiler;

use App\Repository\EntityRepository;
use Symfony\Component\DependencyInjection\Compiler\CompilerPassInterface;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\Serializer\NameConverter\CamelCaseToSnakeCaseNameConverter;

/**
 * Compiler pass to create entity definition list
 */
class EntityDefinitionCompilerPass implements CompilerPassInterface
{
    /**
     * @inheritDoc
     * @throws \ReflectionException
     */
    public function process(ContainerBuilder $container): void
    {
        $snakeCaser = new CamelCaseToSnakeCaseNameConverter();

        $dir = "{$container->getParameter("kernel.project_dir")}/src/Entity";
        $files = scandir($dir);
        $excludedFile = [".", ".."];
        $entityList = [];
        foreach ($files as $fileName) {
            if (!in_array($fileName, $excludedFile)) {
                $shortClassName = strstr($fileName, '.php', true);
                $snakeClassName = $snakeCaser->normalize($shortClassName);
                $className = "App\Entity\\$shortClassName";
                $repositoryClassName = "App\Repository\\{$shortClassName}Repository";
                if (!class_exists($repositoryClassName)) {
                    $repositoryClassName = EntityRepository::class;
                }
                $entityDef = [
                    "className" => $className,
                    "entityName" => $snakeClassName,
                    "repository" => $repositoryClassName,
                    "properties" => [],
                ];
                $entityList[$snakeClassName] = $entityDef;
            }
        }
        $container->setParameter("entity.definition", $entityList);
    }
}
