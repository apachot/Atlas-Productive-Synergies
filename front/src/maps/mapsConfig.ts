/**
 * Configure les zones pour un affichage optimisé des cartes
 * center: coordonnées GPS du point central,
 * maxBounds, deux points extreme pour contraindre la carte dans une zone
 * {"codeRegion": {center: number[], maxBounds: number[][]}}
 * pour ajouter un nouveau : "":{center: [1,1], maxBounds: [[1,1],[1,1]]},
 * avec valeurs aura : "":{center: [45.777494, 3.087152], maxBounds: [[44.886654, 7.337404],[46.946725, 1.996139]]},
 *
 * Liste des regions :
 * 11 : Île-de-France
 * 24 : Centre-Val de Loire
 * 27 : Bourgogne-Franche-Comté
 * 28 : Normandie
 * 32 : Hauts-de-France
 * 44 : Grand Est
 * 52 : Pays de la Loire
 * 53 : Bretagne
 * 75 : Nouvelle-Aquitaine
 * 76 : Occitanie
 * 84 : Auvergne-Rhône-Alpes
 * 93 : Provence-Alpes-Côte d'Azur
 * 94 : Corse
 */
import { ReactComponent as SvgSecteur1 } from "../svgs/SvgSecteur1.svg";
import { ReactComponent as SvgSecteur2 } from "../svgs/SvgSecteur2.svg";
import { ReactComponent as SvgSecteur3 } from "../svgs/SvgSecteur3.svg";
import { ReactComponent as SvgSecteur4 } from "../svgs/SvgSecteur4.svg";
import { ReactComponent as SvgSecteur5 } from "../svgs/SvgSecteur5.svg";
import { ReactComponent as SvgSecteur6 } from "../svgs/SvgSecteur6.svg";
import { ReactComponent as SvgSecteur7 } from "../svgs/SvgSecteur7.svg";
import { ReactComponent as SvgSecteur8 } from "../svgs/SvgSecteur8.svg";
import { ReactComponent as SvgSecteur9 } from "../svgs/SvgSecteur9.svg";
import { ReactComponent as SvgSecteur10 } from "../svgs/SvgSecteur10.svg";
import { ReactComponent as SvgSecteur11 } from "../svgs/SvgSecteur11.svg";
import { ReactComponent as SvgSecteur12 } from "../svgs/SvgSecteur12.svg";
import { ReactComponent as SvgSecteur13 } from "../svgs/SvgSecteur13.svg";
import { ReactComponent as SvgSecteur14 } from "../svgs/SvgSecteur14.svg";
import { ReactComponent as SvgSecteur15 } from "../svgs/SvgSecteur15.svg";
import { ReactComponent as SvgSecteur16 } from "../svgs/SvgSecteur16.svg";
import { ReactComponent as SvgSecteur17 } from "../svgs/SvgSecteur17.svg";
import { ReactComponent as SvgSecteur18 } from "../svgs/SvgSecteur18.svg";
import { ReactComponent as SvgSecteur19 } from "../svgs/SvgSecteur19.svg";
import { ReactComponent as SvgMetierA } from "../svgs/SvgMetierA.svg";
import { ReactComponent as SvgMetierB } from "../svgs/SvgMetierB.svg";
import { ReactComponent as SvgMetierC } from "../svgs/SvgMetierC.svg";
import { ReactComponent as SvgMetierD } from "../svgs/SvgMetierD.svg";
import { ReactComponent as SvgMetierE } from "../svgs/SvgMetierE.svg";
import { ReactComponent as SvgMetierF } from "../svgs/SvgMetierF.svg";
import { ReactComponent as SvgMetierG } from "../svgs/SvgMetierG.svg";
import { ReactComponent as SvgMetierH } from "../svgs/SvgMetierH.svg";
import { ReactComponent as SvgMetierI } from "../svgs/SvgMetierI.svg";
import { ReactComponent as SvgMetierJ } from "../svgs/SvgMetierJ.svg";
import { ReactComponent as SvgMetierK } from "../svgs/SvgMetierK.svg";
import { ReactComponent as SvgMetierL } from "../svgs/SvgMetierL.svg";
import { ReactComponent as SvgMetierM } from "../svgs/SvgMetierM.svg";
import { ReactComponent as SvgMetierN } from "../svgs/SvgMetierN.svg";
import { LatLngExpression } from "leaflet";

export const listeRegions: {
  [key:string] : {
    id:string
    name:string
    center:LatLngExpression
    maxBounds:number[][]
    zoom?:number
  }
} = {
  "11": {
    id: "11",
    name: "Île-de-France",
    center: [48.83579746, 2.3840332],
    maxBounds: [
      [48.07807894, 3.42773438],
      [49.21042045, 1.40625],
    ],
  },
  "24": {
    id: "24",
    name: "Centre-Val de Loire",
    center: [47.38347387, 1.63696289],
    maxBounds: [
      [46.36209301, 3.40576172],
      [48.92249926, -0.05493164],
    ],
  },
  "27": {
    id: "27",
    name: "Bourgogne-Franche-Comté",
    center: [47.15984001, 4.89990234],
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "28": {
    id: "28",
    name: "Normandie",
    center: [49.23912083, 0.05493164],
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "32": {
    id: "32",
    name: "Hauts-de-France",
    center: [49.97948776, 2.84545898],
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "44": {
    id: "44",
    name: "Grand Est",
    center: [48.73445537, 5.72387695],
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "52": {
    id: "52",
    name: "Pays de la Loire",
    center: [47.41322033, -0.9173584],
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "53": {
    id: "53",
    name: "Bretagne",
    center: [48.12210103, -2.85095215],
    zoom: 9,
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "75": {
    id: "75",
    name: "Nouvelle-Aquitaine",
    center: [44.94924927, -0.16479492],
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "76": {
    id: "76",
    name: "Occitanie",
    center: [43.77109382, 2.31811523],
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "84": {
    id: "84",
    name: "Auvergne-Rhône-Alpes",
    center: [45.56790961, 4.7845459],
    maxBounds: [
      [44.412741, 8.921541], //Genoa, IT
      [47.399276, 0.678272], //Tours
    ],
  },
  "93": {
    id: "93",
    name: "Provence-Alpes-Côte d'Azur",
    center: [43.86621801, 6.16333008],
    maxBounds: [
      [44.886654, 7.337404],
      [46.946725, 1.996139],
    ],
  },
  "94": {
    id: "94",
    name: "Corse",
    center: [42.1308213, 8.99780273],
    maxBounds: [
      [1, 1],
      [1, 1],
    ],
  },
  "01": {
    id: "01",
    name: "Guadeloupe",
    center: [16.27005071, -61.59896851],
    maxBounds: [
      [1, 1],
      [1, 1],
    ],
  },
  "02": {
    id: "02",
    name: "Martinique",
    center: [14.6113732, -60.9620777],
    maxBounds: [
      [1, 1],
      [1, 1],
    ],
  },
  "03": {
    id: "03",
    name: "Guyane",
    center: [4.0039882, -52.999998],
    maxBounds: [
      [1, 1],
      [1, 1],
    ],
  },
  "04": {
    id: "04",
    name: "La Réunion",
    center: [-21.1309332, 55.5265771],
    maxBounds: [
      [1, 1],
      [1, 1],
    ],
  },
  "06": {
    id: "06",
    name: "Mayotte",
    center: [-12.823048, 45.1520755],
    maxBounds: [
      [1, 1],
      [1, 1],
    ],
  },
};
/**
 * Liste des macro secteurs
 */
export const listeSecteurs : {
  [key:number] : {
    code:number,
    name: string,
    color: string,
    Logo: React.FunctionComponent<React.SVGProps<SVGSVGElement> & { title?: string | undefined; }>
  }
} = {
  1: {
    code: 1,
    name: "Agriculture, sylviculture et pêche",
    color: "#8ABF4F",
    Logo: SvgSecteur1,
  },
  2: {
    code: 2,
    name: "Industries extractives",
    color: "#FFDC50",
    Logo: SvgSecteur2,
  },
  3: {
    code: 3,
    name:
      "Fabrication de denrées alimentaires, de boissons et de produits à base de tabac",
    color: "#DDC4DF",
    Logo: SvgSecteur3,
  },
  4: {
    code: 4,
    name:
      "Fabrication de textiles, industries de l'habillement, industrie du cuir et de la chaussure",
    color: "#F6A961",
    Logo: SvgSecteur4,
  },
  5: {
    code: 5,
    name: "Travail du bois, industries du papier et imprimerie",
    color: "#E2AC7D",
    Logo: SvgSecteur5,
  },
  6: {
    code: 6,
    name: "Cokéfaction et raffinage",
    color: "#F5B2AB",
    Logo: SvgSecteur6,
  },
  7: {
    code: 7,
    name: "Industrie chimique",
    color: "#EA8286",
    Logo: SvgSecteur7,
  },
  8: {
    code: 8,
    name: "Industrie pharmaceutique",
    color: "#D1E5CA",
    Logo: SvgSecteur8,
  },
  9: {
    code: 9,
    name:
      "Fabrication de produits en caoutchouc et en plastique ainsi que d'autres produits minéraux non métalliques",
    color: "#E4CAB4",
    Logo: SvgSecteur9,
  },
  10: {
    code: 10,
    name:
      "Métallurgie et fabrication de produits métalliques à l'exception des machines et des équipements",
    color: "#B8CFD1",
    Logo: SvgSecteur10,
  },
  11: {
    code: 11,
    name: "Fabrication de produits informatiques, électroniques et optiques",
    color: "#CEEAFB",
    Logo: SvgSecteur11,
  },
  12: {
    code: 12,
    name: "Fabrication d'équipements électriques",
    color: "#83C5A3",
    Logo: SvgSecteur12,
  },
  13: {
    code: 13,
    name: "Fabrication de machines et équipements n.c.a.",
    color: "#00A99D",
    Logo: SvgSecteur13,
  },
  14: {
    code: 14,
    name: "Fabrication de matériels de transport",
    color: "#A3A33A",
    Logo: SvgSecteur14,
  },
  15: {
    code: 15,
    name:
      "Autres industries manufacturières ; réparation et installation de machines et d'équipements",
    color: "#FFA4D8",
    Logo: SvgSecteur15,
  },
  16: {
    code: 16,
    name:
      "Production et distribution d'électricité, de gaz, de vapeur et d'air conditionné",
    color: "#7DC8CF",
    Logo: SvgSecteur16,
  },
  17: {
    code: 17,
    name:
      "Production et distribution d'eau ; assainissement, gestion des déchets et dépollution",
    color: "#42CFF4",
    Logo: SvgSecteur17,
  },
  18: {
    code: 18,
    name: "Construction",
    color: "#F5B2AB",
    Logo: SvgSecteur18,
  },
  19: {
    code: 19,
    name: "Autres produits",
    color: "#1F8DC1",
    Logo: SvgSecteur19,
  },
};

export const listeEffectifs : {
  [key: string] : {
    name:string,
    code:number,
    workforceCodes:string,
    factor:number
  }
} = {

    0: {
      name: "NN et 0",
      code: 0,
      workforceCodes: "NN,00",
      factor: 1.3,
    },
    1: {
      name: "1 à 10",
      code: 1,
      workforceCodes: "01,02,03",
      factor: 1.3,
    },
    2: {
      name: "10 à 20",
      code: 2,
      workforceCodes: "11",
      factor: 1.8,
    },
    3: {
      name: "20 à 50",
      code: 3,
      workforceCodes: "12",
      factor: 2.3,
    },
    4: {
      name: "50 à 100",
      code: 4,
      workforceCodes: "21",
      factor: 3,
    },
    5: {
      name: "100 à 500",
      code: 5,
      workforceCodes: "22,31,32",
      factor: 4,
    },
    6: {
      name: "+ de 500",
      code: 6,
      workforceCodes: "41,42,51,52,53",
      factor: 5,
    },
};

export const listeDomaines : {
  [key:string] : {
    code: string
    name: string
    color: string
    Logo: any
  }
} = {
  A: {
    code: "A",
    name:
      "Agriculture et Pêche, Espaces naturels et Espaces verts, Soins aux animaux",
    color: "#8ABF4F",
    Logo: SvgMetierA,
  },
  B: {
    code: "B",
    name: "Arts et Façonnage d'ouvrages d'art",
    color: "#F5A982",
    Logo: SvgMetierB,
  },
  C: {
    code: "C",
    name: "Banque, Assurance, Immobilier",
    color: "#F199C0",
    Logo: SvgMetierC,
  },
  D: {
    code: "D",
    name: "Commerce, Vente et Grande distribution",
    color: "#F49B25",
    Logo: SvgMetierD,
  },
  E: {
    code: "E",
    name: "Communication, Média et Multimédia",
    color: "#EC6B69",
    Logo: SvgMetierE,
  },
  F: {
    code: "F",
    name: "Construction, Bâtiment et Travaux publics",
    color: "#7BC7CC",
    Logo: SvgMetierF,
  },
  G: {
    code: "G",
    name: "Hôtellerie-Restauration, Tourisme, Loisirs et Animation",
    color: "#A076B1",
    Logo: SvgMetierG,
  },
  H: {
    code: "H",
    name: "Industrie",
    color: "#D1E5CA",
    Logo: SvgMetierH,
  },
  I: {
    code: "I",
    name: "Installation et Maintenance",
    color: "#FFED50",
    Logo: SvgMetierI,
  },
  J: {
    code: "J",
    name: "Santé",
    color: "#E95160",
    Logo: SvgMetierJ,
  },
  K: {
    code: "K",
    name: "Services à la personne et à la collectivité",
    color: "#89C066",
    Logo: SvgMetierK,
  },
  L: {
    code: "L",
    name: "Spectacle",
    color: "#89C066",
    Logo: SvgMetierL,
  },
  M: {
    code: "M",
    name: "Support à l'entreprise",
    color: "#81CFF4",
    Logo: SvgMetierM,
  },
  N: {
    code: "N",
    name: "Transport et Logistique",
    color: "#A3A33A",
    Logo: SvgMetierN,
  },
};

export const companySizes = {
  "00":
    "0 salarié (n'ayant pas d'effectif au 31/12 mais ayant employé des salariés au cours de l'année de référence)",
  NN: "",
  "01": "1 ou 2 salariés",
  "02": "3 à 5 salariés",
  "03": "6 à 9 salariés",
  "11": "10 à 19 salariés",
  "12": "20 à 49 salariés",
  "21": "50 à 99 salariés",
  "22": "100 à 199 salariés",
  "31": "200 à 249 salariés",
  "32": "250 à 499 salariés",
  "41": "500 à 999 salariés",
  "42": "1 000 à 1 999 salariés",
  "51": "2 000 à 4 999 salariés",
  "52": "5 000 à 9 999 salariés",
  "53": "10 000 salariés et plus",
};

export const defaultVisibleSectors = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
];
export const allSecteurs = defaultVisibleSectors;
export const defaultVisibleWorkforces = [3, 4, 5, 6];
export const allWorkforces = [0, 1, 2, 3, 4, 5, 6];
export const partnerColor = "#fa63b7";
export const defaultVisibleDomaines = [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
];
export const allDomaines = defaultVisibleDomaines;
