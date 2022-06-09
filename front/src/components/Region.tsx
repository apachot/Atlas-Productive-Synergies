/**
 * Affichage de la carte au niveau d'une région ou d'un TI
 */
import React, { useCallback, useEffect, useState } from "react";
import Navigation from "./Navigation";
import FiltresLink from "./FiltresLink";
import L from "leaflet";
import "leaflet-providers";
import "../lib/CanvasFlowmapLayer";
import { listeRegions } from "../maps/mapsConfig";
import { computeMarkerSize, shuffleArray } from "../Utils";
import {
  computeTooltipRectangle,
  collision,
  buildMarker,
  MapLegend,
} from "./mapUtils";
import * as _ from "lodash-es";
import { useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { isMobileOnly } from "react-device-detect";
import { drawRegionOnMap } from "../maps/france/france_regions";
import { drawEpciOnMap } from "../maps/france/france_epci";

const Region = (props: {
  // etablissements: EtablissementsType,
  changementEtablissement: (selected ?:string) => void,
  isLoading: boolean,
  navigation: any,
  initMap: any,
  setInitMap: any
}) => {
  const mapRef = React.useRef<L.Map>();
  const layerRef = React.useRef<L.LayerGroup<any>>();
  const {
    // etablissements,
    changementEtablissement,
    isLoading,
    navigation,
    initMap,
    setInitMap,
  } = props;
  const { regionId, secteurs, effectifs, epciId, regionData } = useSelector((state: RootState) => state.filter);
  const { partners, establishments } = useSelector((state: RootState) => state.establishment);

  const [labeledMarkers, setLabeledMarkers] = useState<any>();
  const [isLabelVisible, setIsLabelVisible] = useState(true);
  const [isLinkVisible, setIsLinkVisible] = useState(true);
  const [isEstablishmentVisible, setIsEstablishmentVisible] = useState(true);

  const buildLines = useCallback ( (partenaires: any) => {
    const geoJsonFeatureCollection = {
      type: "FeatureCollection",
      features: partenaires.map(function (partenaire: any) {
        const partenaireSrc = partenaire.src;
        const partenaireDest = partenaire.dest;
        return {
          type: "Feature",
          geometry: {
            type: "Point",
            coordinates: partenaireSrc.coordinates,
          },
          properties: {
            s_city_id: partenaireSrc.id,
            s_lat: partenaireSrc.coordinates[0],
            s_lon: partenaireSrc.coordinates[1],
            e_city_id: partenaireDest.id,
            e_lat: partenaireDest.coordinates[0],
            e_lon: partenaireDest.coordinates[1],
          },
        };
      }),
    };

    return (L as any).canvasFlowmapLayer(geoJsonFeatureCollection, {
      originAndDestinationFieldIds: {
        originUniqueIdField: "s_city_id",
        originGeometry: {
          x: "s_lon",
          y: "s_lat",
        },
        destinationUniqueIdField: "e_city_id",
        destinationGeometry: {
          x: "e_lon",
          y: "e_lat",
        },
        pathDisplayMode: "all",
        animationStarted: false,
      },
      canvasBezierStyle: {
        type: "simple",
        symbol: {
          strokeStyle: "#434960",
        },
      },
    });
  }, []);

  const doChangeSize = useCallback ( (map: L.Map) => {
    const currentZoom = map.getZoom();
    const mapBoundsLarge = map.getBounds().pad(0.5);
    const mapBounds = map.getBounds().pad(-0.001); //Centrage labels
    let nb = 0;
    const visibleLayersByWFG: any = {};
    map.eachLayer(function (l: any) {
      if (l.options.id !== "mapLayer" && l.options.isVisible) {
        //On agit sur les layers visibles (dans le filtre en cours et dans la zone géographique visible)
        //mais pas la carte ou les layers sans taille
        if (l.options.effectif !== undefined) {
          const tooltip = l.getTooltip();
          if (mapBoundsLarge.contains(l.getLatLng())) {
            l.setRadius(
              computeMarkerSize(currentZoom, l.options.effectif, effectifs)
            );
            //On filtre les layers visibles par groupe pour gérer ensuite leur tooltip
            if (visibleLayersByWFG[l.options.effectif] === undefined) {
              visibleLayersByWFG[l.options.effectif] = [l];
            } else {
              visibleLayersByWFG[l.options.effectif].push(l);
            }
          }
          l.unbindTooltip().bindTooltip(tooltip, {
            permanent: false,
            interactive: false,
          });
        }
      }
    });

    //Calcul des labels qui doivent être affichés
    //Un label ne peut être affiché s'il se croise ave un autre
    //On priorise les entreprises à plus fort effectif dabord
    const bush: any[] = [];
    const listLabel: any[] = [];
    ["6", "5", "4", "3", "2", "1", "0"].map((eff) => {
      if (visibleLayersByWFG[eff] !== undefined) {
        //TODO plutôt que de faire un système aléatoire on peut trier les entreprises selon d'autres critères
        const listeTmp = shuffleArray(visibleLayersByWFG[eff]);
        listeTmp.map((l) => {
          if (mapBounds.contains(l.getLatLng())) {
            const tooltip = l.getTooltip();
            if (tooltip) {
              const el = computeTooltipRectangle(l);
              if (!collision(el, bush)) {
                bush.push(el);
                listLabel.push(l);
                nb++;
              }
            }
          }
          return l;
        });
      }
      return nb;
    });
    setLabeledMarkers(listLabel);
  }, [effectifs]) ;

  useEffect(() => {
    if (!labeledMarkers) {
      return;
    }
    labeledMarkers.map(function (l: any) {
      const tooltip = l.getTooltip();
      if (tooltip && !isLabelVisible) {
        l.unbindTooltip().bindTooltip(tooltip, {
          permanent: false,
        });
      } else if (tooltip && isLabelVisible) {
        l.unbindTooltip().bindTooltip(tooltip, {
          permanent: true,
        });
      }
      return l;
    });
  }, [labeledMarkers, isLabelVisible]);

  useEffect(() => {
    mapRef.current = L.map("mapid", {
      preferCanvas: true,
      layers: [
        L.tileLayer.provider("CartoDB.VoyagerLabelsUnder", {
          maxZoom: 15,
          id: "mapLayer",
        }),
      ],
    });
    mapRef.current.zoomControl.setPosition("bottomright");
    layerRef.current = L.layerGroup().addTo(mapRef.current);
  }, []);

  React.useEffect(() => {
    if (!mapRef.current) {
      return
    }
    const zoom = (listeRegions[regionId]["zoom"] || 8) ;
    const position = listeRegions[regionId]["center"];
    mapRef.current.setView(position, zoom);
    regionData && drawRegionOnMap(mapRef.current, regionId, regionData.region) ;
  }, [regionId, regionData]);

  React.useEffect(() => {
    if (!mapRef.current || !epciId || !regionData) {
      return
    }
    drawEpciOnMap (mapRef.current, epciId, regionData.epci)
  }, [epciId, regionData]) ;

  React.useEffect(() => {
    if (!mapRef.current || !layerRef.current) return ;
    const map = mapRef.current ;
    layerRef.current.clearLayers();
    if (isLinkVisible) {
      const filtered = partners.filter((e) => {
        return (
          e.dest.sector_id &&
          e.dest.coordinates &&
          e.dest.coordinates[0] &&
          e.dest.coordinates[1] &&
          e.src.sector_id &&
          e.src.coordinates &&
          e.src.coordinates[0] &&
          e.src.coordinates[1] &&
          (isEstablishmentVisible ||
            (_.intersection(secteurs, [e.dest.sector_id]).length > 0 && _.intersection(secteurs, [e.src.sector_id]).length > 0)
          )
        );
      });
      if (filtered.length > 0) {
        const layer = buildLines(filtered);
        layer.addTo(layerRef.current);
      }
    }
    const markers:L.Circle[] = [];
    establishments?.forEach(entreprise => {
      const customMarker = buildMarker({
        etablissement: entreprise,
        mapRef: map,
        secteurs,
        effectifs,
        changementEtablissement,
        isEstablishmentVisible,
      });
      if (customMarker) {
        markers.push(customMarker);
        customMarker.addTo(layerRef.current!);
      }
    })
    
    //Si on n'a pas eu de zoom, on défini le zoom initial
    if (mapRef.current && !initMap && markers.length > 0) {
      const group = L.featureGroup(markers);
      const pad = isMobileOnly ? -0.3 : 0.11 ;
      mapRef.current.fitBounds(group.getBounds().pad(pad));
      setInitMap(true);
    } 

    if (mapRef.current) {
      doChangeSize(mapRef.current);
    };
  }, [establishments, partners, isLinkVisible, isEstablishmentVisible, changementEtablissement, effectifs, initMap, secteurs, setInitMap, buildLines, doChangeSize, regionId]);

  useEffect(() => {
    const changeSize = () => {
      if (!mapRef.current) {
        return
      }
      doChangeSize(mapRef.current)
    };
    //Attente du chargement de la carte
    if (!mapRef.current) {
      return
    }
    mapRef.current.on("moveend", changeSize);
    return () => {
      mapRef.current?.off("moveend", changeSize);
    };
  }, [secteurs, effectifs, doChangeSize]);

  useEffect(() => {
    if (!mapRef.current) {
      return
    }
    if (isLoading) {
      mapRef.current.getContainer().classList.add("cursorWait");
    } else {
      mapRef.current.getContainer().classList.remove("cursorWait");
    }
  }, [isLoading]);

  return (
    <React.Fragment>
      <Navigation navigation={navigation} />
      <FiltresLink navigation={navigation} />
      <div id={"mapid"} className={`h-full`}>
        <MapLegend
          isPartenaireLegend={false}
          isLabelVisible={isLabelVisible}
          setIsLabelVisible={setIsLabelVisible}
          isLinkVisible={isLinkVisible}
          setIsLinkVisible={setIsLinkVisible}
          isEstablishmentVisible={isEstablishmentVisible}
          setIsEstablishmentVisible={setIsEstablishmentVisible}
        />
      </div>
    </React.Fragment>
  );
};
export default Region;
