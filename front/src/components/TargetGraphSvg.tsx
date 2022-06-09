import { ProduitProximiteType } from "../api/Produits";
import { parseProducts, Point } from "./TargetGraphUtils";
import { RefTooltip } from "./Utils";

type targetGraphSvgType = {
    width:number;
    height:number;
    highlight: string[];
    produits: ProduitProximiteType;
    produitSelected?: ProduitProximiteType;
    secteurs: number[];
    effectifs: number[];
    produitIdHighlight?:string;
    produitsHighlight:string[];
    refTooltip: React.RefObject<RefTooltip>;
    hoverToSelected :(id?: string)=>void;
    isLoading: boolean;
    setOvered: (id?: string) => void;
}
export const targetGraphSvg = ({
    width,
    height,
    highlight,
    produits,
    produitSelected,
    secteurs,
    effectifs,
    produitIdHighlight,
    produitsHighlight,
    refTooltip,
    hoverToSelected,
    isLoading,
    setOvered,
}:targetGraphSvgType) => {
    const _height=height*0.9 ;
    const centerX = width / 2.5 ;
    const centerY = _height / 1.9;
    const innerRadius = _height / 4;
    const outerRadius = _height / 2 - 50;
    const maxValueRadius = (outerRadius - innerRadius) / 5; //18;

    const drawLine = (id: string, points : Point[], fromProduct: string, className:string = "") => {
        const center = points.filter((p) => p.id === fromProduct);
        const point = points.filter((p) => p.id === id);
        if (point.length > 0 && center.length > 0) {
          return (
            <line
              key={`${fromProduct}-${id}`}
              className={`proximityLine ${className}`}
              x1={center[0].x}
              y1={center[0].y}
              x2={point[0].x}
              y2={point[0].y}
            />
          );
        }
      };

      const points = parseProducts(
        produits,
        produitSelected ? highlight : undefined,
        {
          centerX,
          centerY,
          innerRadius,
          outerRadius,
          maxValueRadius,
        },
        secteurs,
        effectifs
      );

    return(
        <svg width={width} height={_height}>
        <circle
          cx={centerX}
          cy={centerY}
          r={outerRadius}
          fill="#ecf1f4"
        />
        <circle
          cx={centerX}
          cy={centerY}
          r={innerRadius}
          fill="#cbe6f1"
        />
        {highlight.map((id) => {
          return drawLine(
            id,
            points,
            produitSelected
              ? produitSelected.product.code_hs4
              : produits.product.code_hs4,
            "relatedToSelectedTarget"
          );
        })}
        {produitIdHighlight
          ? produitsHighlight.map((id) => {
            return drawLine(
              id,
              points,
              produitIdHighlight,
              "relatedToHoveredTarget"
            );
          })
          : null}
        {points.map((p) => {
          return p.drawForm({
            refTooltip,
            handleNodeClick: hoverToSelected,
            isLoading,
            setOvered,
          });
        })}
      </svg>
    )
}