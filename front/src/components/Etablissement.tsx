/**
 * Affichage de la carte pour un établissement et ses partenaires potentiels
 */
import React, { useCallback, useEffect, useState } from "react";
import L, { Layer } from "leaflet";
import { listeRegions } from "../maps/mapsConfig";
import { computeMarkerSize, shuffleArray } from "../Utils";
import {
  computeTooltipRectangle,
  collision,
  buildMarker,
  MapLegend,
  Rect,
} from "./mapUtils";
import Navigation from "./Navigation";
import FiltresLink from "./FiltresLink";
import { EtablissementLongType, PartnerType } from "../api/Etablissements";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { Slider } from "@material-ui/core";
import { useTranslation } from "react-i18next";
import './Etablissement.scss';
import { setDistance, setNumber, setCustomer, setProvider, setWomenMen, setAlternateProvider } from "../redux/establishmentObjectifSlice";
import { drawRegionOnMap } from "../maps/france/france_regions";

type SlideType = {
  value: number,
  onChange?: (event: React.ChangeEvent<{}>, value: number | number[]) => void,
  step?: number,
  max?: number,
  min?: number,
  marks?: boolean
}

const Slide = ({ value, onChange, step = 5, min = 0, max = 100, marks = true }: SlideType) => {
  return <Slider
    defaultValue={30}
    value={value}
    onChange={onChange}
    valueLabelDisplay="auto"
    step={step}
    marks={marks}
    min={min}
    max={max} />
}

function Etablissement(props: {
  etablissement: EtablissementLongType,
  secteurs: number[],
  effectifs: number[],
  changementEtablissement: (selected?: string) => void,
  isLoading: boolean
}) {
  const {
    etablissement,
    secteurs,
    effectifs,
    changementEtablissement,
    isLoading,
  } = props;

  const mapRef = React.useRef<L.Map>();
  const layerRef = React.useRef<L.LayerGroup<any>>();
  const { t } = useTranslation();
  const dispatch = useDispatch();

  const { regionId } = useSelector((state: RootState) => state.filter);
  const { regions } = useSelector((state: RootState) => state.data);
  const { distance, number, customer, provider, womenMen, alternateProvider } = useSelector((state: RootState) => state.establishmentObjective);

  const [labeledMarkers, setLabeledMarkers] = useState<L.Layer[]>();
  const [isLabelVisible, setIsLabelVisible] = useState(true);
  const [isLinkVisible, setIsLinkVisible] = useState(true);
  const [initMap, setInitMap] = useState(false);
  const [partners, setPartners] = useState<PartnerType[]>([]);

  const zoom = 7;
  const maxZoom = 15;

  const buildLines = useCallback((partenaires: PartnerType[], linkColor: string) => {
    const partenaireSrc = etablissement;
    const geoJsonFeatureCollection = {
      type: "FeatureCollection",
      features: partenaires.map(function (partenaire) {
        const partenaireDest = partenaire;
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

    return L.canvasFlowmapLayer(geoJsonFeatureCollection, {
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
      },
      pathDisplayMode: "all",
      animationStarted: false,
      canvasBezierStyle: {
        type: "simple",
        symbol: {
          // use canvas styling options (compare to CircleMarker styling below)
          strokeStyle: linkColor,
          lineWidth: 3,
        },
      },
    });
  }, [etablissement]);


  interface EqualFilterType extends PartnerType {
    coef: number | null
  }

  const equalizer = useCallback(
    (
      number: number,
      customer: boolean,
      provider: boolean,
      alternateProvider: boolean,
      distance: number,
      womenMen: number,
      partner?: PartnerType[]
    ): PartnerType[] => {
      if (!partner || partner.length === 0) {
        return []
      }

      const equal_filter = (
        number: number,
        partnerFilter: EqualFilterType[],
      ): EqualFilterType[] => {

        if (partnerFilter.length === 0) {
          return []
        }
        const minDistance = partnerFilter.reduce((prev, curr) => prev.distance < curr.distance ? prev : curr).distance;
        const maxDistance = partnerFilter.reduce((prev, curr) => prev.distance > curr.distance ? prev : curr).distance;
        const diviserDistance = (maxDistance - minDistance) === 0 ? 1 : maxDistance - minDistance;
        const woman = (partnerFilter.map(p => p.score).filter(p => !!p) as number[]);
        const womenAvg = woman.length === 0 ? 100 : (woman.reduce((a, b) => a + b, 0) / woman.length) * 0.8;

        const p = partnerFilter
          .map(p => ({
            ...p,
            coefDistance: (1 - (((p.distance - minDistance) / diviserDistance * 0.8) + 0.1)) * (distance / 100),
            coefWomenMen: (p.score ? p.score / 100 : womenAvg / 100) * (womenMen / 100),
          }))
          .map(p => ({
            ...p,
            coef: (p.coef ?? 0) *
              (1 + p.coefDistance) *
              (1 + p.coefWomenMen),
          }))
          .sort((a, b) => b.coef - a.coef === 0 ? a.distance - b.distance : b.coef - a.coef)
          .slice(0, number)
        return p;
      }

      const pFiltCust = partner.filter(p => (customer && p.customer)).map(p => ({ ...p, coef: p.cust_coef }))
      const pFiltProv = partner.filter(p => (provider && p.provider)).map(p => ({ ...p, coef: p.prov_coef }))
      const pFiltAlt = partner.filter(p => (alternateProvider && p.alt_provider)).map(p => ({ ...p, coef: p.prov_coef }))
      if (pFiltCust.length === 0 && pFiltProv.length === 0 && pFiltAlt.length === 0) {
        return []
      }

      return [
        ...equal_filter(number, pFiltCust),
        ...equal_filter(number, pFiltProv),
        ...equal_filter(number, pFiltAlt)
      ];
    }, []);

  useEffect(() => {
    setTimeout(() => {
      setInitMap(false);
    }, 0);
    setPartners(equalizer(number, customer, provider, alternateProvider, distance, womenMen, etablissement.partner))
  }, [etablissement, number, distance, womenMen, provider, customer, alternateProvider, equalizer])



  const doChangeSize = useCallback((map: L.Map) => {
    const currentZoom = map.getZoom();
    const mapBoundsLarge = map.getBounds().pad(0.5);
    const mapBounds = map.getBounds().pad(-0.001); //Centrage labels
    const visibleLayersByWFG: { [key: number]: Layer[] } = {};
    map.eachLayer(function (layer: Layer) {
      if (layer.options.id !== "mapLayer") {
        //On agit sur les layers visibles (dans le filtre en cours et dans la zone géographique visible)
        //mais pas la carte ou les layers sans taille
        if (layer.options.effectif) {
          const tooltip = layer.getTooltip();
          if (mapBoundsLarge.contains(layer.getLatLng())) {
            layer.setRadius(
              computeMarkerSize(currentZoom, layer.options.effectif, effectifs)
            );
            if (layer.options.isVisible) {
              //On filtre les layers visibles par groupe pour gérer ensuite leur tooltip
              if (visibleLayersByWFG[layer.options.effectif] === undefined) {
                visibleLayersByWFG[layer.options.effectif] = [layer];
              } else {
                visibleLayersByWFG[layer.options.effectif].push(layer);
              }
            }
          }
          tooltip && layer.unbindTooltip().bindTooltip(tooltip, {
            permanent: false,
            interactive: false,
          });
        }
      }
    });

    //Calcul des labels qui doivent être affichés
    //Un label ne peut pas être affiché s'il se croise avec un autre
    //On priorise les entreprises à plus fort effectif d'abord
    const bush: Rect[] = [];
    const listLabel: Layer[] = [];
    [6, 5, 4, 3, 2, 1, 0].forEach((eff) => {
      if (visibleLayersByWFG[eff] !== undefined) {
        //TODO plutôt que de faire un système aléatoire on peut trier les entreprises selon d'autres critères
        const listeTmp = shuffleArray(visibleLayersByWFG[eff]);
        listeTmp.forEach((l) => {
          if (mapBounds.contains(l.getLatLng())) {
            const tooltip = l.getTooltip();
            if (tooltip) {
              const el = computeTooltipRectangle(l);
              if (!collision(el, bush)) {
                bush.push(el);
                listLabel.push(l);
              }
            }
          }
        });
      }
    });
    setLabeledMarkers(listLabel);
  }, [effectifs]);

  useEffect(() => {
    if (!labeledMarkers || !mapRef.current) {
      return;
    }
    labeledMarkers.forEach(function (l) {
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
    });
  }, [labeledMarkers, isLabelVisible]);

  useEffect(() => {
    mapRef.current = L.map("mapid", {
      preferCanvas: true,
      layers: [
        L.tileLayer.provider("CartoDB.VoyagerLabelsUnder", {
          maxZoom,
          id: "mapLayer",
        }),
      ],
    });

    mapRef.current.zoomControl.setPosition("bottomright");
    layerRef.current = L.layerGroup().addTo(mapRef.current);

    ;
    return () => {
      if (!mapRef.current) return;
      mapRef.current.clearAllEventListeners();
      mapRef.current.off();
      mapRef.current.remove();
    }
  }, []);

  React.useEffect(() => {
    if (!mapRef.current) return;
    const position = listeRegions[regionId]["center"];
    mapRef.current.setView(position, zoom);
    drawRegionOnMap(mapRef.current, regionId, regions);
  }, [regionId, regions]);

  React.useEffect(() => {
    if (!mapRef.current || !layerRef.current) return;
    const map = mapRef.current;
    layerRef.current.clearLayers();
    if (isLinkVisible) {
      if (partners.length > 0) {
        const cust = partners.filter(p => p.customer)
        if (cust.length > 0) {
          const layer = buildLines(cust, 'rgb(28, 133, 28)');
          layer.addTo(layerRef.current);
        }
        const prov = partners.filter(p => p.provider)
        if (prov.length > 0) {
          const layer = buildLines(prov, 'rgb(84, 50, 252)');
          layer.addTo(layerRef.current);
        }
        const alt_prov = partners.filter(p => p.alt_provider)
        if (alt_prov.length > 0) {
          const layer = buildLines(alt_prov, 'rgb(255, 150, 0)');
          layer.addTo(layerRef.current);
        }
      }
    }

    const markers = [];
    const customMarker = buildMarker({
      etablissement,
      mapRef: map,
      secteurs,
      effectifs,
      changementEtablissement,
      isEstablishmentVisible: true,
    });
    if (customMarker) {
      customMarker.addTo(layerRef.current);
      markers.push(customMarker);
    }

    partners.forEach(entreprise => {
      const customMarker = buildMarker({
        etablissement: entreprise,
        mapRef: map,
        secteurs,
        effectifs,
        changementEtablissement,
        isEstablishmentVisible: true,
      });
      if (customMarker && layerRef.current) {
        markers.push(customMarker);
        customMarker.addTo(layerRef.current);
      }
    })
    //Si on n'a pas eu de zoom, on défini le zoom initial
    if (!initMap && markers.length > 0) {
      // TODO test const group = new (L.featureGroup(markers));
      const group = L.featureGroup(markers);
      mapRef.current.fitBounds(group.getBounds().pad(0.1));
      setInitMap(true);
    }
    if (!mapRef.current) {
      return
    }
    doChangeSize(mapRef.current)
  }, [etablissement, secteurs, effectifs, isLinkVisible, changementEtablissement, doChangeSize, buildLines, initMap, partners]);


  useEffect(() => {
    if (!mapRef.current) return
    const changeSize = () => {
      if (!mapRef.current) {
        return
      }
      doChangeSize(mapRef.current)
    }

    //Attente du chargement de la carte
    mapRef.current.on("moveend", changeSize);
    return () => {
      mapRef.current?.off("moveend", changeSize);
    };
  }, [secteurs, effectifs, doChangeSize]);

  useEffect(() => {
    if (!mapRef.current) return
    if (isLoading) {
      // TODO: test mapRef.current?._container.classList.add("cursorWait");
      mapRef.current.getContainer().classList.add("cursorWait");
    } else {
      // TODO : test mapRef.current?._container.classList.remove("cursorWait");
      mapRef.current.getContainer().classList.remove("cursorWait");
    }
  }, [isLoading]);

  return (
    <>
      <Navigation navigation={"etablissements"} />
      <div className="EtablissementCustomSlide">
        <div className="CustomerProvider">
          <span className="custom-control custom-switch" >
            <input
              className="custom-control-input custom-control-input-success"
              id="PotentialCustomer"
              type="checkbox"
              checked={customer}
              onChange={() => dispatch(setCustomer(!customer))}
            />
            <label className="custom-control-label" htmlFor="PotentialCustomer">
              <span className={"switchLibelle"}>
                {t("Clients recommandés")}
              </span>
            </label>
          </span>
        </div>
        <div className='ProviderTitle'>
          {t("Fournisseurs recommendés")}
        </div>
        <div className="AltProvider">
          <span className="custom-control custom-switch" >
            <input
              className="custom-control-input custom-control-input-success"
              id="PotentialProvider"
              type="checkbox"
              checked={provider}
              onChange={() => dispatch(setProvider(!provider))}
            />
            <label className="custom-control-label" htmlFor="PotentialProvider">
              <span className={"switchLibelle"}>
                {t("Standards")}
              </span>
            </label>
          </span>
          <span className="custom-control custom-switch" >
            <input
              className="custom-control-input custom-control-input-success"
              id="AlternateProvider"
              type="checkbox"
              checked={alternateProvider}
              onChange={() => dispatch(setAlternateProvider(!alternateProvider))}
            />
            <label className="custom-control-label" htmlFor="AlternateProvider">
              <span className={"switchLibelle"}>
                {t("Alternatifs")}
              </span>
            </label>
          </span>

        </div>
        <div className="PropositionNote">
          {t("Les synergies proposées sont générées par nos algorithmes de manière théorique mais ne représentent pas les relations client-fournisseurs réelles des entreprises")}
        </div>
        {t("Distance")}
        <Slide value={distance} onChange={(event, value: any) => { dispatch(setDistance(value)) }} />
        {t("Egalité Femme/Homme")}
        <Slide value={womenMen} onChange={(event, value: any) => { dispatch(setWomenMen(value)) }} />
        {t("Nombre de propositions")}
        <Slide value={number} onChange={(event, value: any) => { dispatch(setNumber(value)) }} marks={false} max={100} min={5} step={1} />
      </div>
      <FiltresLink />
      <div id={"mapid"} className="EtablishmentMap">
        <MapLegend
          isLinkVisible={isLinkVisible}
          setIsLinkVisible={setIsLinkVisible}
          isLabelVisible={isLabelVisible}
          setIsLabelVisible={setIsLabelVisible}
          isPartenaireLegend={true}
        />
      </div>
    </>
  );
}

export default React.memo(Etablissement);
