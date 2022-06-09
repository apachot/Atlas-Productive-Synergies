import {
  computeMarkerSize,
  determineTailleTooltip,
  getEffectifFromWF,
  shorten,
} from "../Utils";
import L from "leaflet";
import { listeSecteurs } from "../maps/mapsConfig";
import * as _ from "lodash-es";
import { Trans } from 'react-i18next';
import { EtablissementShortType } from "../api/Etablissements";

export type Rect = { left: number, top: number, right: number, bottom: number }
/**
 * Détermine la zone dans laquelle le tooltip doit s'afficher
 * Retourne les coordonnées du point haut gauche et bas droite
 * @param layer
 * @returns {{top: number, left: number, bottom: number, right: *}}
 */
export function computeTooltipRectangle(layer: any): Rect {
  //const characterLength = 10; //10.2 9.22222222222222 9.214285714285714 8.666666666666666 7.538461538461538 8.17283950617284
  let lineHeight;
  switch (layer.options.effectif) {
    case 6:
      lineHeight = 18;
      break;
    case 5:
      lineHeight = 18;
      break;
    case 4:
      lineHeight = 17;
      break;
    case 3:
      lineHeight = 16;
      break;
    case 2:
      lineHeight = 15;
      break;
    case 1:
      lineHeight = 14;
      break;
    case 0:
      lineHeight = 12;
      break;
    default:
      lineHeight = 6;
  }
  const canvas = document.createElement("canvas");
  const ctx = canvas.getContext("2d");
  if (!ctx) {
    return { left: 0, top: 0, right: 0, bottom: 0 }
  }
  ctx.font = "18px Helvetica Neue";
  const { width } = ctx.measureText(layer.getTooltip()._content);
  const markerPosition = layer._point;
  const markerRadius = 0; //layer._radius;
  const labelPixelLength = width; //labelLength * characterLength;
  let left, top, right, bottom;
  left = markerPosition.x - labelPixelLength / 2;
  top = markerPosition.y - lineHeight - markerRadius;
  right = markerPosition.x + labelPixelLength / 2;
  bottom = markerPosition.y + lineHeight - markerRadius;
  return { left, top, right, bottom };
}

/**
 * Détermine si deux rectangles ont une intersection
 * @param r1 {left:{float},top:{float},right:{float},bottom:{float}} coordonnées des bords du rectangle
 * @param r2 {left:{float},top:{float},right:{float},bottom:{float}} coordonnées des bords du rectangle
 * @returns {boolean} vrai s'ils se croisent, faux sinon
 */
export function intersectRect(r1: Rect, r2: Rect) {
  return !(
    r2.left > r1.right ||
    r2.right < r1.left ||
    r2.top > r1.bottom ||
    r2.bottom < r1.top
  );
}

/**
 * Détermine si un tooltip est en conflit avec ceux déjà ajoutés
 * @param htmlElement {left:{float},top:{float},right:{float},bottom:{float}} élément à comparer
 * @param listeCoord {{left:float,top:float,right:float,bottom:float}[]} liste des éléments déjà visibles
 * @returns {boolean} vrai si on a une collision avec un label déjà existant
 */
export function collision(htmlElement: Rect, listeCoord: Rect[]) {
  let isCollision = false;
  for (let i = 0; i < listeCoord.length && !isCollision; i++) {
    if (intersectRect(htmlElement, listeCoord[i])) {
      isCollision = true;
    }
  }
  return isCollision;
}

/**
 * etablissement, mapRef, effectif, effectifs, L, changementEtablissement
 * @param etablissement
 * @param mapRef
 * @param effectifs
 * @param changementEtablissement
 * @param secteurs
 * @returns {*}
 */
export function buildMarker({
  etablissement,
  mapRef,
  effectifs,
  secteurs,
  changementEtablissement,
  isEstablishmentVisible,
}: {
  etablissement: EtablissementShortType
  mapRef: L.Map
  effectifs: number[]
  secteurs: number[]
  changementEtablissement: (selected?:string)=>void
  isEstablishmentVisible: boolean
}) {
  const effectif = getEffectifFromWF(
    etablissement.workforce_group ? etablissement.workforce_group : "11"
  );
  const {
    id,
    coordinates,
    sector_id,
    workforce_group,
    naf_description,
    usual_name,
    siret,
    rome_chapter_exists,
  } = etablissement;
  const currentZoom = mapRef.getZoom();
  const size = computeMarkerSize(currentZoom, effectif, effectifs);
  //Sur la vue région l'intersection n'a pas d'impact car les données sont filtrés,
  //par contre sur le détail d'un établissement on veut jouer sur l'opacité
  const isVisible =
    _.intersection(secteurs, [sector_id]).length > 0 &&
    rome_chapter_exists &&
    _.intersection(effectifs, [effectif]).length > 0;

  if (!isVisible && !isEstablishmentVisible) {
    return undefined;
  }
  const marker: L.Circle = L.circle(
    coordinates,
    {
      radius: size,
      fillColor: sector_id ? listeSecteurs[sector_id].color : "#000",
      fillOpacity: isVisible ? 1 : 0,
      color: "#85869b", //listeSecteurs[parseInt(etablissement.sector_id)].color, //"#85869b",
      weight: 1,
      customId: id,
      workforceGroup: workforce_group,
      effectif: effectif,
      isVisible: isVisible
    });

 
  const classSuffix = determineTailleTooltip(effectif);
  const name = shorten(usual_name ? usual_name : siret, 20);

  marker.bindTooltip(name.toLowerCase(), {
    permanent: false,
    direction: "top",
    className: `establishmentTooltip ${classSuffix}`,
    opacity: 1,
    interactive: false,
  });

  const popup = L.popup({
    closeButton: false,
    maxWidth: 300,
    className: "markerPopup",
  });
  popup.setContent(`
    <div>
        <p class="titre">${usual_name ? usual_name : siret}</p>
        <p class="description">${naf_description ? naf_description : ""}</p>
    </div>`);
  marker.bindPopup(popup);
  marker.on("mouseover", function () {
    marker.openPopup();
    marker.getTooltip()?.setOpacity(0);
  });
  marker.on("mouseout", function () {
    marker.closePopup();
    marker.getTooltip()?.setOpacity(0.9);
  });

  marker.on("click", function (e: any) {
    changementEtablissement(e.target.options.customId);
  });

  return marker;
}

export const MapLegend = ({
  isLinkVisible,
  setIsLinkVisible,
  isLabelVisible,
  setIsLabelVisible,
  isPartenaireLegend,
  isEstablishmentVisible,
  setIsEstablishmentVisible
}: {
  isLinkVisible: any
  setIsLinkVisible: any
  isLabelVisible: any
  setIsLabelVisible: any
  isPartenaireLegend: any
  isEstablishmentVisible?: any
  setIsEstablishmentVisible?: any
}) => {
  return (
    <div className={"leaflet-control-container"}>
      <div className={"leaflet-bottom leaflet-left flex"}>
        {isPartenaireLegend ? (
          <div className={"legend leaflet-control flex flex-row"} style={{ width: "auto", top: "0" }}>
            <div style={{ marginRight:"0.25rem" }}>
              <i
                style={{ borderBottomStyle: "dotted",borderBottomColor: 'rgb(28, 133, 28)', }}
              ></i>
              <span><Trans>Clients</Trans></span>
            </div>
            <div style={{ margin: "auto" }}>
              <i
                style={{
                  borderBottomStyle: "dotted",
                  borderBottomColor: 'rgb(84, 50, 252)',
                }}
              />
              <span><Trans>Fournisseurs</Trans></span>
            </div>
            <div style={{ marginLeft: "0.25rem" }}>
              <i
                style={{
                  borderBottomStyle: "dotted",
                  borderBottomColor: 'rgb(255, 150, 0)',
                }}
              />
              <span><Trans>Alternatifs</Trans></span>
            </div>
          </div>
        ) : null}

        <div
          className={"legend leaflet-control flex flex-row"}
          style={{ width: "auto", top: "0" }}
        >
          <span className="custom-control custom-switch mr-2" style={{ position: "relative", zIndex: 800 }}>
            <input
              className="custom-control-input custom-control-input-success"
              id="partenaire"
              type="checkbox"
              checked={isLinkVisible}
              onChange={() => {
                setIsLinkVisible(!isLinkVisible);
              }}
            />
            <label className="custom-control-label" htmlFor="partenaire">
              <span className={"switchLibelle mr-4"}><Trans>Partenaire</Trans></span>
            </label>
          </span>

          <span className="custom-control custom-switch" style={{ position: "relative", zIndex: 800 }}>
            <input
              className="custom-control-input custom-control-input-success"
              id="nomEtablissement"
              type="checkbox"
              checked={isLabelVisible}
              onChange={() => {
                setIsLabelVisible(!isLabelVisible);
              }}
            />
            <label className="custom-control-label" htmlFor="nomEtablissement">
              <span className={"switchLibelle"}>
                <Trans>Nom&nbsp;établissement</Trans>
              </span>
            </label>
          </span>

          {!isPartenaireLegend ? (
            <span className="custom-control custom-switch ml-5" style={{ zIndex: "unset" }}>
              <input
                className="custom-control-input custom-control-input-success"
                id="hideEstablishment"
                type="checkbox"
                checked={isEstablishmentVisible}
                onChange={() => {
                  setIsEstablishmentVisible(!isEstablishmentVisible);
                }}
              />
              <label className="custom-control-label" htmlFor="hideEstablishment">
                <span className={"switchLibelle"}><Trans>Tous voir</Trans></span>
              </label>
            </span>
          ) : null}
        </div>
      </div>
    </div>
  );
};
