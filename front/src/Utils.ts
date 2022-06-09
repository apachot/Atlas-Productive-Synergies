import { listeEffectifs } from "./maps/mapsConfig";
import styled from "styled-components";
import { EtablissementLongType, EtablissementShortType } from "./api/Etablissements";
import { StandardType } from "./api/Produits";
import { DataPosition } from "./components/space/spaceData";

export const defaultMaxNodeRadius = 20;
export const defaultMinNodeRadius = 8;

export function parseZoneId(zoneId: string): {
  regionId: string,
  territoireId?: string,
  epciId?: string,
} {
  if (zoneId.indexOf("TI") === 0) {
    return { regionId: zoneId.substr(2, 2), territoireId: zoneId, epciId: undefined };
  }
  if (zoneId.toUpperCase().indexOf("EPCI") === 0) {
    const s = zoneId.toUpperCase().replace('EPCI','').split('-') ;
    return { regionId: s[0], epciId: s[1], territoireId:undefined}
  }
  return { regionId: zoneId, territoireId: undefined, epciId: undefined };
}

/**
 * Génère la liste des metiers attendues par le module d'Harvard
 * @param data {object[]} liste des produis de la zone concernée
 * @returns {object[]} {name: Nom du metier, active: metier présent dans cet espace, values[int]: pondération du point dans cet espace}
 */
export type ProductSpaceFormat = {
  id: string;
  value: number;
  active: boolean;
  radius: number;
  position: { x: number, y: number };
  color: string;
  edge: { x: number, y: number, id:string }[];
  lib: { [key:string]: string };
  secteurs: string[] ;
}
export function newProductSpaceFormat(
  data: StandardType,
  dataPosition: DataPosition,
): ProductSpaceFormat[] {
  const { min: minDomain, max: maxDomain } = data.config;
  const minRange = defaultMinNodeRadius;
  const maxRange = defaultMaxNodeRadius;

  return data.data.map(elem => {
    const value = elem.value ?? Math.floor(Math.random() * 20) + 1;
    const radius = (maxDomain - minDomain > 0) ?
      (((value - minDomain) / (maxDomain - minDomain)) * (maxRange - minRange)) + minRange :
      (0.5 * (maxRange - minRange)) + minRange;
    const pos = dataPosition.nodes.find(e => e.id === elem.id);
    return {
      id: elem.id,
      value,
      active: elem.value > 0,
      radius,
      position: { x: pos?.x ?? -1, y: pos?.y ?? -1 },
      color: pos?.color ?? "#d7d7da",
      edge: pos ? pos.edge : [],
      lib: pos ? pos.lib : {en:"", fr:""},
      secteurs: pos ? pos.secteurs : [],
    }
  }).filter (e => !(e.lib.en ==="" && e.lib.fr === ""))
}
type DebounceFunction = {
  (): void
}
export function debounce(fn: DebounceFunction, ms: number) {
  let timer: any;
  return (_: any) => {
    clearTimeout(timer);
    timer = setTimeout((_) => {
      timer = null;
      fn()
      // fn.apply(this, arguments);
    }, ms);
  };
}
export function shorten(str: string, maxLength: number): string {
  if (str.length <= maxLength || maxLength <= 3) {
    return str;
  } else {
    return str.substr(0, maxLength - 3) + "...";
  }
}
export function getEffectifFromWF(workforce: string): number {
  for (const key in listeEffectifs) {
    if (listeEffectifs[key].workforceCodes.indexOf(workforce) !== -1) {
      return listeEffectifs[key].code;
    }
  }
  return -9999;
}

/**
 * Algo doigt mouillé savamment réfléchi pour déterminer la taille d'un point d'une entreprise
 */
export function computeMarkerSize(zoomLevel: number, effectif: number, effectifs: number[]): number {
  let taille = 200;
  let ratioNbEntreprise = 1;
  //Facteur multiplicatif associé à chaque effectif
  const factor = listeEffectifs[effectif] ? listeEffectifs[effectif].factor : 1;
  //   const tooltip = document.querySelectorAll(".establishmentTooltip");
  //Dans le cas où on affiche les petits effectifs on a énormément de point, donc on réduit tous les points
  /*if (effectifs) {
    if (effectifs.indexOf(0) !== -1) {
      ratioNbEntreprise = 0.2;
    } else if (effectifs.indexOf(1) !== -1) {
      ratioNbEntreprise = 0.3;
    } else if (effectifs.indexOf(2) !== -1) {
      ratioNbEntreprise = 0.4;
    } else if (effectifs.indexOf(3) !== -1) {
      ratioNbEntreprise = 0.5;
    }
  }*/
  ratioNbEntreprise = 0.4;
  //Détermination de la taille selon le zoom courant de la carte
  if (zoomLevel <= 6) {
    taille = 3200;
    // tooltip.style.fontSize("1px");
  } else if (zoomLevel === 7) {
    taille = 2800;
  } else if (zoomLevel === 8) {
    taille = 1700;
  } else if (zoomLevel === 9) {
    taille = 1200;
  } else if (zoomLevel === 10) {
    taille = 900;
  } else if (zoomLevel === 11) {
    taille = 600;
  } else if (zoomLevel === 12) {
    taille = 400;
  } else if (zoomLevel === 13) {
    taille = 100;
  } else if (zoomLevel === 14) {
    taille = 50;
  } else if (zoomLevel >= 15) {
    taille = 20;
  }
  return taille * factor * ratioNbEntreprise;
}

/**
 * Pour chaque élément d'un tableau on en récupère un autre au hasard et on les intervertie
 */
export function shuffleArray(array: any[]): any[] {
  const arrayCopie = array.slice(0);
  for (let i = arrayCopie.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arrayCopie[i], arrayCopie[j]] = [arrayCopie[j], arrayCopie[i]];
  }
  return arrayCopie;
}
/**
 * Permet de déterminer si un produit doit être mis en évidence,
 * Soit s'il est dans la liste, soit s'il n'y a pas de liste
 */
export function isHighlighted(code: string, liste: string[] | undefined): boolean {
  if (liste) {
    return liste.indexOf(code) !== -1;
  }
  return true;
}

/**
 * Vérifie la présence d'un couple secteur et workforce d'une entreprise/produit au sein d'un filtre
 * @param secteur {int} identifiant du macro secteur
 * @param workforces {string|string[]} le ou les workforce (un produit pouvant venir de plusieurs entreprises)
 * @param value {int} valeur de production du produit par les entreprises de la zone géographique
 * @param listeSecteur {int[]}
 * @param listeEffectif {int[]}
 * @returns {boolean}
 */
export function isInFilter(
  { secteur, workforces }: { secteur: number, workforces: string | string[] },
  listeSecteur: number[],
  listeEffectif: number[]
) {
  if (listeSecteur.indexOf(secteur) === -1) {
    return false;
  }
  if (Array.isArray(workforces)) {
    for (const wfGroup of workforces) {
      if (listeEffectif.includes(getEffectifFromWF(wfGroup))) {
        return true;
      }
    }
  } else {
    if (listeEffectif.includes(getEffectifFromWF(workforces))) {
      return true;
    }
  }
  return false;
}

/**
 * Détermine si le texte peut être affiché tel quel où si on doit passer par un tooltip
 * @param text {string}
 * @param maxLength {number}
 * @returns {{displayText: string, tooltipText: string, needAbbr: boolean}}
 */
export type needAbbrType = {
  needAbbr: boolean;
  displayText: string;
  tooltipText: string;
}
export function needAbbr(text: string, maxLength: number = 80) :needAbbrType {
  if (text.length > maxLength) {
    return {
      needAbbr: true,
      displayText: text.substr(0, maxLength) + "(...)",
      tooltipText: text,
    };
  } 
  return {
      needAbbr: false,
      displayText: text,
      tooltipText: "",
    };
}

/**
 * Parcours la liste des établissement pour trouver les filtres possibles
 * dataSet : liste des établissements
 * selected : établissement sélectionné et donc géré en dehors du jeu de donnée
 */
export function findActivesFilters(dataSet: EtablissementShortType[], selected: EtablissementLongType | undefined = undefined): { secteursActifs: number[], effectifsActifs: number[] } {
  const secteursActifs: number[] = [];
  const effectifsActifs: number[] = [];
  if (selected) {
    secteursActifs.push(selected.sector_id);
    effectifsActifs.push(getEffectifFromWF(selected.workforce_group));
  }
  dataSet.forEach((etablissement: EtablissementShortType) => {
    if (etablissement.sector_id) {
      if (!secteursActifs.includes(etablissement.sector_id)) {
        secteursActifs.push(etablissement.sector_id);
      }
      if (
        !effectifsActifs.includes(
          getEffectifFromWF(etablissement.workforce_group)
        )
      ) {
        effectifsActifs.push(getEffectifFromWF(etablissement.workforce_group));
      }
    }
  });

  return {
    secteursActifs,
    effectifsActifs,
  };
}

/**
 * Genere un nombre entre 1 et 100;
 * @returns {number}
 */
export function randomNumber() {
  return Math.floor(Math.random() * (100 - 1 + 1) + 1);
}

/**
 * Projection des coordonnées polaires d'un point dans un repère carthésien
 * @param r {int} distance au centre
 * @param theta {int}, angle
 * @returns {{x: number, y: number}}
 */
export function getCartesianCoordinates(r: number, theta: number) {
  const x = r * Math.cos((theta * Math.PI) / 180);
  const y = r * Math.sin((theta * Math.PI) / 180);
  return { x, y };
}

/**
 * Transform a number in a percent
 * @param number {float}
 * @param precision {int}
 * @returns {int}
 */
export function parsePourcentage(number?: number, precision = 0) {
  if (!number) return undefined
  const facteur = Math.pow(10, precision);
  return Math.round(number * 100 * facteur) / facteur;
}

export function determineTailleTooltip(effectif: number) {
  switch (effectif) {
    case 6:
      return "establishmentTooltip--xxl";
    case 5:
      return "establishmentTooltip--xl";
    case 4:
      return "establishmentTooltip--l";
    case 3:
      return "establishmentTooltip--m";
    case 2:
      return "establishmentTooltip-s";
    default:
      return "";
  }
}

/**
 * Détermination de la fonction affine qui passe par les deux points
 * @param point1
 * @param point2
 */
export function findAffineExpression(point1: { x: number, y: number }, point2: { x: number, y: number }): { a: number, b: number } {
  const { x: x1, y: y1 } = point1;
  const { x: x2, y: y2 } = point2;
  const a = (y2 - y1) / (x2 - x1);
  const b = y2 - a * x2;
  return { a, b };
}

export const Name = styled.div`
  font-weight: 400;
  &::after {
    margin-right: 0.2rem;
    margin-left: 0.2rem;
  }
`;

/**
 * Formatage des nombres (ex: 100000 => 100 000);
 */
export function formatNumber(num: number): string | undefined {
  if (num) {
    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1 ");
  }
}
