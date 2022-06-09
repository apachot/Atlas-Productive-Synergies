<?php


namespace App;

use App\DependencyInjection\Compiler\EntityDefinitionCompilerPass;
use App\DependencyInjection\Compiler\EstablishmentPartitionCompilerPass;
use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;
use Symfony\Component\HttpKernel\Kernel as BaseKernel;
use Symfony\Component\Routing\Loader\Configurator\RoutingConfigurator;

class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    /**
     * @inheritDoc
     */
    protected function build(ContainerBuilder $container): void
    {
        $container
            ->addCompilerPass(new EntityDefinitionCompilerPass())
            ->addCompilerPass(new EstablishmentPartitionCompilerPass());
    }

    protected function configureContainer(ContainerConfigurator $container): void
    {
        $container->import('../config/{packages}/*.yaml');
        $container->import('../config/{packages}/'.$this->environment.'/*.yaml');

        if (file_exists(\dirname(__DIR__).'/config/services.yaml')) {
            $container->import('../config/{services}.yaml');
            $container->import('../config/{services}_'.$this->environment.'.yaml');
        } else {
            $path = \dirname(__DIR__).'/config/services.php';
            (require $path)($container->withPath($path), $this);
        }
    }

    protected function configureRoutes(RoutingConfigurator $routes): void
    {
        $routes->import('../config/{routes}/'.$this->environment.'/*.yaml');
        $routes->import('../config/{routes}/*.yaml');

        if (file_exists(\dirname(__DIR__).'/config/routes.yaml')) {
            $routes->import('../config/{routes}.yaml');
        } else {
            $path = \dirname(__DIR__).'/config/routes.php';
            (require $path)($routes->withPath($path), $this);
        }
    }
}
