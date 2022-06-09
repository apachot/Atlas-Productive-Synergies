<?php


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
