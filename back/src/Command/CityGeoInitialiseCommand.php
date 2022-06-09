<?php


namespace App\Command;

use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

/**
 * Command to initialise city perimeter
 */
class CityGeoInitialiseCommand extends DatabaseCommand
{
    protected static $defaultName = "app:city_geo:initialise";

    /**
     * @inheritDoc
     * @throws \App\Exception\DatabaseException
     * @throws \JsonException
     */
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $output->writeln([
            "----------------------",
            "City geo perimeter initialisation"
        ]);

        $data = file_get_contents("{$this->sqlDirectory}/fixture/communes-geo.json");
        $data = json_decode($data, true, 512, JSON_THROW_ON_ERROR);
        foreach ($data["features"] as $city) {
            $cityCodeInsee = $city["properties"]["insee"];
            $polygon = [];
            if ("Polygon" === $city["geometry"]["type"]) {
                foreach ($city["geometry"]["coordinates"][0] as $coordinate) {
                    $polygon[] = "({$coordinate[1]},{$coordinate[0]})";
                }
            } else {
                foreach ($city["geometry"]["coordinates"] as $multi) {
                    foreach ($multi[0] as $coordinate) {
                        $polygon[] = "({$coordinate[1]},{$coordinate[0]})";
                    }
                }
            }
            $polygonPart = implode(',', $polygon);

            $sql = "UPDATE city SET perimeter = '$polygonPart'::polygon WHERE insee_code = '$cityCodeInsee';";
            $this->databaseService->exec($sql);
        }
        return 0;
    }
}
