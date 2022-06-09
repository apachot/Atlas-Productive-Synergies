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
