import React, { useEffect, useRef, useState } from "react";
import { UncontrolledReactSVGPanZoom } from "react-svg-pan-zoom";
import AutoSizer from "react-virtualized-auto-sizer";
import { Zoom } from "./GraphUtils";
import Navigation from "./Navigation";
import FiltresLink from "./FiltresLink";
import { Slider } from "@material-ui/core";
import { useTranslation } from "react-i18next";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { setAdvantage, setGreen, setMaslow, setPci, setResilience } from "../redux/objectiveSlice";
import { ProduitProximiteType } from "../api/Produits";
import { RefTooltip, Tooltip } from "./Utils";
import './TargetGraph.scss';
import { targetGraphSvg } from "./TargetGraphSvg";
import { ReactComponent as Losange } from "../svgs/losange.svg";
import { Trans } from 'react-i18next';

type SlideType = {
  value: number,
  onChange?: (event: React.ChangeEvent<{}>, value: number | number[]) => void
}
const Slide = ({ value, onChange }: SlideType) => {
  return <Slider 
    defaultValue={30}
    value={value}
    onChange={onChange}
    valueLabelDisplay="auto"
    step={5}
    marks
    min={0}
    max={100} />
}

const Legend = () => {
  return (
    <div className="Legend">
      <div className={"Data"}>
        <svg viewBox="0 0 120 120">
          <Losange className="Losange" />
        </svg>
        <Trans>Non fabriqué sur le territoire</Trans>
      </div>
      <div className={"Data"}>
        <svg viewBox="0 0 120 120">
          <circle fill={"#fff"} cx="60" cy="60" r="60" />
          <circle fill={"#ddd"} cx="60" cy="60" r="30" />
        </svg>
        <Trans>Proximité directe</Trans>
      </div>
      <div className={"Data"}>
        <svg viewBox="0 0 120 120">
          <circle fill={"#ddd"} cx="60" cy="60" r="60" />
          <circle fill={"#fff"} cx="60" cy="60" r="30" />
        </svg>
        <Trans>Proximité secondaire</Trans>
      </div>
    </div>
  );
};

const TargetGraph = (props: {
  produits: ProduitProximiteType,
  produitSelected?: ProduitProximiteType,
  handleNodeClick: (id?: string) => void,
  secteurs: number[],
  effectifs: number[],
  isLoading: boolean,
  navigation: "produits",
  className: string,
  regionId: string,
  territoireId: string | undefined,
  produitId?: string
}) => {
  const {
    produits,
    produitSelected,
    handleNodeClick,
    secteurs,
    effectifs,
    isLoading,
  } = props;
  const dispatch = useDispatch();
  const refTooltip = useRef<RefTooltip>(null);
  const { advantage, green, maslow, pci, resilience } = useSelector(
    (state: RootState) => state.objective
  );


  const { t } = useTranslation();
  const [produitIdHighlight, setProduitIdHighlight] = useState<string>();
  const [produitsHighlight, setProduitsHighlight] = useState<string[]>([]);
  const [doRefresh, setDoRefresh] = useState<boolean>(false)

  const viewerRef = useRef<UncontrolledReactSVGPanZoom>(null);
  const highlight = produitSelected
    ? [
      ...produitSelected.proximities
        .filter((e) => e.level === 1)
        .map((e) => {
          const { code_hs4 } = e;
          return code_hs4;
        }),
      produitSelected.product.code_hs4,
    ]
    : [
      ...produits.proximities
        .filter((e) => e.level === 1)
        .map((e) => {
          const { code_hs4 } = e;
          return code_hs4;
        }),
    ];

  //Gestion du survol
  useEffect(() => {
    if (produitIdHighlight) {
      const hovered = produits.proximities.filter((e: any) => {
        const { code_hs4 } = e;
        return code_hs4 === produitIdHighlight;
      });
      if (hovered.length > 0) {
        const { proximity_lvl1 } = hovered[0];
        if (proximity_lvl1 !== undefined) {
          setProduitsHighlight(proximity_lvl1);
        }
      }
    } else {
      setProduitsHighlight([]);
    }
  }, [produitIdHighlight, produits.proximities]);

  const setOvered = (id?: string) => {
    if (produitSelected) {
      const { code_hs4 } = produitSelected.product;
      if (id !== code_hs4) {
        setProduitIdHighlight(id);
      }
    } else if (id !== produits.product.code_hs4) {
      setProduitIdHighlight(id);
    }
  }

  const hoverToSelected = (id?: string) => {
    handleNodeClick(id);
    setProduitIdHighlight(undefined);
  };

  const rkChangeGreen = (event: React.ChangeEvent<{}>, value: any): void => {
    dispatch(setGreen(value))
  };

  const rkChangeAdvantage = (event: React.ChangeEvent<{}>, value: any): void => {
    dispatch(setAdvantage(value))
  };

  const rkChangePci = (event: React.ChangeEvent<{}>, value: any): void => {
    dispatch(setPci(value))
  };

  const rkChangeResilience = (event: React.ChangeEvent<{}>, value: any): void => {
    dispatch(setResilience(value))
  };

  const rkChangeMaslow = (event: React.ChangeEvent<{}>, value: any): void => {
    dispatch(setMaslow(value))
  };

  return (
    <div className={"Target"}>
      <Navigation navigation={props.navigation} />
      <FiltresLink navigation={props.navigation} />
      {isLoading ? null : (
        <Tooltip ref={refTooltip} />
      )}
      <AutoSizer onResize={() => setDoRefresh(!doRefresh)}>
        {({ height, width }) => (
          <UncontrolledReactSVGPanZoom
            className={"svgpanzoom"}
            ref={viewerRef}
            width={width}
            height={height}
            tool="auto"
            detectAutoPan={false}
            background={"#f5f5f5"}
            toolbarProps={{ position: "none" }}
            scaleFactorMax={4.2}
            onClick={() => {
              handleNodeClick(undefined);
            }}
            miniatureProps={{
              position: "none",
              height: 0,
              width: 0,
              background: ""
            }}
          >
            {targetGraphSvg({
              effectifs,
              height,
              highlight,
              hoverToSelected,
              isLoading,
              produitIdHighlight,
              produits,
              produitsHighlight,
              refTooltip,
              secteurs,
              setOvered,
              width,
              produitSelected
            })}
          </UncontrolledReactSVGPanZoom>)}
      </AutoSizer>
      <Zoom viewerRef={viewerRef} />
      <Legend />
      <div className="CustomSlide">
        {t("Avantage compétitif")}
        <Slide value={advantage} onChange={rkChangeAdvantage} />
        {t("Croissance économique")}
        <Slide value={pci} onChange={rkChangePci} />
        {t("Résilience productive")}
        <Slide value={resilience} onChange={rkChangeResilience} />
        {t("Nécessités de base")}
        <Slide value={maslow} onChange={rkChangeMaslow} />
        {t("Production écologique")}
        <Slide value={green} onChange={rkChangeGreen} />
      </div>
    </div>
  );
};
// export default React.memo(TargetGraph);
export default TargetGraph;