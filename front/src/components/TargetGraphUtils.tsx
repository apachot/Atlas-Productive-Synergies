import {
  findAffineExpression,
  getCartesianCoordinates,
  isHighlighted,
  isInFilter,
  Name,
} from "../Utils";
import React from "react";
import { listeSecteurs } from "../maps/mapsConfig";
import { ReactComponent as Losange } from "../svgs/losange.svg";
import { ProduitProximiteType } from "../api/Produits";
import './TargetGraphUtils.scss'
import { RefTooltip } from "./Utils";
const inactiveOpacity = 0.2;

/**
 * Données communes à un produit
 */
export class Produit {
  id:string
  label:string
  value:any
  r:any
  secteur:number
  workforces:string | string[]
  constructor(code_hs4:string, name:string, value:any, need:any, macro_sector_id:number, workforce_group:string | string[]) {
    this.id = code_hs4;
    this.label = name;
    this.value = value;
    this.r = need;
    this.secteur = macro_sector_id;
    this.workforces = workforce_group;
  }
}

/**
 * Factorisation des éléments du graphe
 * @method tooltipValue génération du contenu de l'info bulle
 * @method drawform permet d'appeler la bonne méthode pour tracer le point
 */
export class Point extends Produit {
  highlighted: boolean
  x:number
  y:number
  visible:boolean
  constructor(
    x:number,
    y:number,
    code_hs4: string,
    name:string,
    value:any,
    need:any,
    macro_sector_id:any,
    workforce_group:any,
    highlight:string[] | undefined,
    secteurs:number[],
    effectifs: number[]
  ) {
    super(code_hs4, name, value, need, macro_sector_id, workforce_group);
    this.x = x;
    this.y = y;
    //No longer used
    this.highlighted = isHighlighted(this.id, highlight);
    this.visible =
      isInFilter(
        {
          secteur: this.secteur,
          workforces: this.workforces,
        },
        secteurs,
        effectifs
      ) && this.highlighted;
  }
  tooltipValue() {
    return (
      <>
        <span
          className={"bg-gray-700 px-2 py-1 text-white rounded font-normal"}
        >
          {this.id}
        </span>
        <Name>{this.label}</Name>
      </>
    );
  }
  drawCircle({ refTooltip, handleNodeClick, isLoading, setOvered }:
    { refTooltip: React.RefObject<RefTooltip>, handleNodeClick: any, isLoading: boolean, setOvered:{(id?:string):void} }) {
    return (
      <circle
        key={this.id}
        className={isLoading ? "cursor-wait" : "cursor-pointer"}
        cx={this.x}
        cy={this.y}
        r={this.r}
        fill={listeSecteurs[this.secteur].color}
        stroke={"#000"}
        onClick={(e) => {
          e.stopPropagation() ;
          handleNodeClick(this.id);
        }}
        onTouchEnd={(e) => {
          e.stopPropagation() ;
          setOvered(undefined)
          handleNodeClick(this.id);
        }}
        onMouseMove={(e) => {
          refTooltip.current?.show(e, this.tooltipValue())
        }}
        onMouseOut={() => {
          refTooltip.current?.hide()
        }}
        onMouseEnter={() => {
          setOvered(this.id)
        }}
        onMouseLeave={() => {
          setOvered(undefined)
        }}
        fillOpacity={this.visible ? 1 : inactiveOpacity}
        strokeWidth={this.visible ? "1" : "0.2"}
      />
    );
  }
  drawLosange({ refTooltip, handleNodeClick, isLoading, setOvered }:
    { refTooltip: React.RefObject<RefTooltip>, handleNodeClick:any, isLoading:boolean, setOvered:{(id?:string):void} }) {
    return (
      <Losange
        key={this.id}
        className={isLoading ? "cursor-wait" : "cursor-pointer"}
        x={this.x - this.r}
        y={this.y - this.r}
        width={this.r * 2}
        height={this.r * 2}
        fill={listeSecteurs[this.secteur].color}
        stroke={"#000"}
        onClick={(e) => {
          e.stopPropagation() ;
          handleNodeClick(this.id);
        }}
        onTouchEnd={(e) => {
          e.stopPropagation() ;
          handleNodeClick(this.id);
        }}
        onMouseMove={(e) => refTooltip.current?.show(e, this.tooltipValue())}
        onMouseOut={() => refTooltip.current?.hide()}
        onMouseEnter={() => setOvered(this.id)}
        onMouseLeave={() => setOvered(undefined)}
        fillOpacity={this.visible ? 1 : inactiveOpacity}
        strokeWidth={this.visible ? "2" : "0.5"}
      />
    );
  }
  drawForm(props:{refTooltip: React.RefObject<RefTooltip>; handleNodeClick: any; isLoading: boolean; setOvered:{(id?:string):void}}) {
    return this.value > 0 ? this.drawCircle(props) : this.drawLosange(props);
  }
}
/**
 * Transforme la liste des produits pour générer la cible, retourne la liste des points à afficher
 * @param listeProduits {{product:{}, proximities:{}}} coeur de la cible et ses proximités
 * @param highlight {string[]} liste des codes hs4
 * @param conf {{ centerX:int, centerY:int, innerRadius:int, outerRadius:int, maxValueRadius:int }}
 * @param secteurs {int[]} liste des macro secteurs sélectionnés
 * @param effectifs {string[]} liste des effectifs sélectionnés
 * @returns {Point[]}
 */
export function parseProducts(
  listeProduits: ProduitProximiteType,
  highlight: string[] | undefined,
  conf: { centerX:number, centerY:number, innerRadius:number, outerRadius:number, maxValueRadius:number },
  secteurs: number[],
  effectifs: number[]
) {
  const { centerX, centerY, innerRadius, outerRadius, maxValueRadius } = conf;
  const { product, proximities: listeProximite } = listeProduits;
  const data = [];
  let count1 = 0;
  let count2 = 0;
  const countLvl1 = listeProximite.filter(e => e.level === 1).length;
  let rMin = 1;
  let rMax = 0;
  const listLvl2 = listeProximite.filter(e => {
    const { need, level } = e;
    if (need < rMin) {
      rMin = need;
    }
    if (need > rMax) {
      rMax = need;
    }
    return level === 2;
  });
  const minValueRadius = 2 + rMin * maxValueRadius;
  const countLvl2 = listLvl2.length;
  const { a, b } = findAffineExpression(
    { x: rMin, y: innerRadius + minValueRadius },
    { x: rMax, y: outerRadius - maxValueRadius }
  );

  //Centre de la cible
  const {
    code_hs4,
    need,
    value,
    sector_id: macro_sector_id,
    name,
    workforce_group,
  } = product;
  data.push(
    new Point(
      centerX,
      centerY,
      code_hs4,
      name,
      value,
      2 + need * maxValueRadius,
      macro_sector_id,
      workforce_group,
      highlight,
      secteurs,
      effectifs
    )
  );

  for (const produitIdx in listeProximite) {
    if (listeProximite.hasOwnProperty(produitIdx)) {
      const produit = listeProximite[produitIdx];
      const {
        code_hs4,
        need,
        proximity,
        level,
        value,
        macro_sector_id,
        name,
        workforce_group,
      } = produit;

      const { x, y } = getCartesianCoordinates(
        level === 1 ? proximity * innerRadius : a * need + b,
        (360 / (level === 1 ? countLvl1 : countLvl2)) *
          (level === 1 ? count1 : count2)
      );
      level === 1 ? count1++ : count2++;
      data.push(
        new Point(
          x + centerX,
          y + centerY,
          code_hs4,
          name,
          value,
          2 + need * maxValueRadius,
          macro_sector_id,
          workforce_group,
          highlight,
          secteurs,
          effectifs
        )
      );
    }
  }

  return data;
}


