/**
 * Affichage du panneau latéral avec les infos de la région ou TI sélectionné
 */
import React from "react";
import { find } from "lodash-es";
import { parsePourcentage, formatNumber } from "../Utils";
import { ReactComponent as Recommandations } from "../svgs/recommandation.svg";
import SideFiltres from "./SideFiltres";
import SideTop from "./SideTop";
import { listeRegions } from "../maps/mapsConfig";
import { useTranslation } from 'react-i18next';
import { useSelector } from "react-redux";
import { RootState } from "../redux/store";
import Loader from "./loader";
import { Madetype, RcaType } from "../api/Produits";
import './SideInfosRegion.scss';
import { MetiersRepresentativeWorkType } from "../api/Metiers";

type IndicateurNumberType = {
  totalTitre: string;
  total: number;
}
const IndicateurNumber = ({ totalTitre, total }: IndicateurNumberType) => {
  return (
    <div className={"IndicateurNumber"}>
      <div className={"Title"}>
        {totalTitre}
      </div>
      <div className={"Value"}>
        {formatNumber(total)}
      </div>
    </div>
  )
}

const IndicateurAdvantage = () => {
  const { t } = useTranslation();
  const { territoireId, regionData } = useSelector((state: RootState) => state.filter);
  let territoireName: string | undefined;
  let territoireCoefRca: number | undefined = undefined;
  if (territoireId && regionData?.industry_territory) {
    const indus = find(regionData?.industry_territory, function (e) {
      return e.national_identifying === territoireId;
    });
    territoireName = indus?.name.fr;
    territoireCoefRca = indus?.coef_rca;
  }

  return (
    <div className={"IndicateurAdvantage"}>
      <div className={"Title"}>{t("Avantage compétitif")}</div>
      <div className={"Value"} >
        {regionData
          ? !territoireName
            ? `${parsePourcentage(
              regionData.region[0].coef_rca
            )} %`
            : `${parsePourcentage(territoireCoefRca)} %`
          : null}
      </div>
    </div>
  )
}

type TitreEtFiltreType = {
  titre: string;
  navigation: 'produit' | "produits" | "etablissement" | "etablissements" | "metiers";
  filtresIndisponibles?: any;
  setEtablissement: (selected?: string | undefined) => void;
  setMetier: { (id?: string): void };
  setProduit: { (id?: string): void };
}
const TitreEtFiltre = ({
  titre,
  navigation,
  filtresIndisponibles,
  setEtablissement,
  setMetier,
  setProduit,
}: TitreEtFiltreType) => {
  const { t } = useTranslation();
  const { regionId, territoireId, regionData } = useSelector((state: RootState) => state.filter);
  let territoireName: string | undefined;
  if (territoireId && regionData?.industry_territory) {
    const indus = find(regionData?.industry_territory, function (e) {
      return e.national_identifying === territoireId;
    });
    territoireName = indus?.name.fr;
  }
  const { nbProduit, nbEtablissement, nbMetier, } = useSelector((state: RootState) => state.count);
  let total = undefined;
  let totalTitre = "";
  switch (navigation) {
    case "produit":
    case "produits":
      total = nbProduit;
      totalTitre = t("Nombre de produits");
      break;
    case "etablissement":
    case "etablissements":
      total = nbEtablissement;
      totalTitre = t("Nombre d'établissements");
      break;
    case "metiers":
      total = nbMetier;
      totalTitre = t("Nombre de métiers");
      break;
  }
  return (
    <div className={"TitreEtFiltre"}>
      <div className={"Titre"}>{titre}</div>
      <div className={"Region"}>
        {territoireName
          ? t("Secteur {{secteur}}", { secteur: territoireName })
          : t("Région {{region}}", { region: listeRegions[regionId].name })}
      </div>
      <div className={"Indicateur"} >
        <IndicateurAdvantage />
        {total ? <IndicateurNumber total={total} totalTitre={totalTitre} /> : null}
      </div>
      <SideFiltres
        filtresIndisponibles={filtresIndisponibles}
        setEtablissement={setEtablissement}
        setMetier={setMetier}
        setProduit={setProduit}
      />
    </div>

  );
}

type SideInfosRegionType = {
  titre: string,
  navigation: 'produit' | "produits" | "etablissement" | "etablissements" | "metiers",
  filtresIndisponibles?: any,
  topProduits?: [RcaType[], Madetype[]],
  setProduit: { (id?: string): void },
  topMetiers?: MetiersRepresentativeWorkType[],
  setMetier: { (id?: string): void },
  setEtablissement: (selected?: string | undefined) => void,
}


export default function SideInfosRegion({
  titre,
  navigation,
  filtresIndisponibles,
  topProduits,
  setProduit,
  topMetiers,
  setMetier,
  setEtablissement,
}: SideInfosRegionType) {
  const { regionData } = useSelector((state: RootState) => state.filter);
  const { t } = useTranslation();

  if (regionData === undefined) {
    return (
      <div className="SideInfosRegionLoader">
        <Loader />
      </div>
    );
  }

  return (
    <div className="SideInfosRegion">
      <TitreEtFiltre
        navigation={navigation}
        setEtablissement={setEtablissement}
        setMetier={setMetier}
        setProduit={setProduit}
        titre={titre}
        filtresIndisponibles={filtresIndisponibles}
      />
      <SideTop
        navigation={navigation}
        topProduits={topProduits}
        setProduit={setProduit}
        topMetiers={topMetiers}
        setMetier={setMetier}
        setEtablissement={setEtablissement}
      />
      <button className={"Button"} >
        <Recommandations className="Recommandations" />{t("Voir les recommandations")}
      </button>
    </div>
  );
}
