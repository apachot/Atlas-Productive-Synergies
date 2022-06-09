/**
 * Partie haute de la sidebar avec les filtres géographiques
 * Affichage des selects ou version lecture seule
 */
import React from "react";
import Select from "react-select";
import { listeRegions } from "../maps/mapsConfig";
import { useTranslation } from 'react-i18next';
import { useSelector } from "react-redux";
import { RootState } from "../redux/store";
import './SideTopFiltres.scss'

const optionsRegions = Object.values(listeRegions).map((region) => {
  return { value: region.id, label: region.name };
});

type SideTopFiltresFullType = {
  titre: string;
  handleBack: (id?: string) => void;
}
const SideTopFiltresFull = ({ titre, handleBack }: SideTopFiltresFullType) => {
  const { t } = useTranslation();
  const { regionId, territoireId, regionData } = useSelector((state: RootState) => state.filter);

  let territoireName: string | undefined;
  if (territoireId && regionData) {
    const indus = regionData.industry_territory.find((obj) => obj.national_identifying === territoireId);
    territoireName = indus?.name.fr;
  }
  return (
    <div className="SideTopFiltresFull">
      <div className="Title">
        <div className={""}>{titre}</div>
        <div className={""}>
          {territoireName
            ? t("Secteur {{secteur}}", { secteur: territoireName })
            : t("Région {{region}}", { region: listeRegions[regionId].name })}
        </div>
      </div>
      <button
        className="Button"
        onClick={() => handleBack(undefined)}
      >
        X
      </button>
    </div>
  )
}

type SideTopFiltrestype = {
  setRegion: (id: string) => void,
  setTerritoire: (id?: string) => void,
  setEpci: (id?: string) => void,
  handleBack?: (id?: string) => void,
  mode: "full" | "detail",
  titre: string;
  modeRech:'regions' | 'territoire' | 'EPCI'
}

export default function SideTopFiltres({
  setRegion ,
  setTerritoire ,
  setEpci,
  handleBack = () => { },
  mode,
  titre,
  modeRech,
}: SideTopFiltrestype) {
  const { t } = useTranslation();
  const { regionId, territoireId, epciId, regionData } = useSelector((state: RootState) => state.filter);

  const getData = () : {value:string, label:string}[] => {
    if (!regionData) return [] ;
    if (modeRech === 'EPCI') {
      return regionData.epci.map(epci => ({
        value: epci.siren,
        label: epci.name.fr,
      }))
    }
    return regionData.industry_territory.map(it => ({
      value: it.national_identifying,
      label: it.name.fr,
    }))
  }

  const liste = getData();
  const rechId = (modeRech === 'EPCI') ? epciId : territoireId ;

  if (mode === "full") {
    return (
      <SideTopFiltresFull
        handleBack={handleBack}
        titre={titre}
      />
    );
  }
  return (
    <div className={`SideTopFiltres`}>
        <Select
          className="react-select-container"
          classNamePrefix="react-select"
          options={optionsRegions}
          value={optionsRegions.find((obj) => obj.value === regionId)}
          onChange={v => {
            if (!v) return ;
            (modeRech === 'EPCI') ? setEpci(undefined) : setTerritoire(undefined) ;
            setRegion(v.value)
          }}
          placeholder={t("Sélectionner une région")}
          noOptionsMessage={(texte) =>
            t("Aucune région trouvée pour : {{input}}", { input: texte.inputValue })
          }
        />
        <Select
          className="react-select-container"
          classNamePrefix="react-select"
          options={liste}
          value={rechId ? liste.find((obj) => obj.value === rechId) : undefined}
          onChange={(e) => (modeRech === 'EPCI') ? setEpci(e?.value) : setTerritoire(e?.value)}
          isClearable={true}
          placeholder={(modeRech === 'EPCI') ? t("Sélectionner un EPCI") : t("Sélectionner un territoire d'industrie")}
          noOptionsMessage={(texte) =>
            t((modeRech === 'EPCI') ? 
              "Aucun EPCI trouvé pour : {{input}}"
              : "Aucun territoire d'industrie trouvé pour : {{input}}", 
            { input: texte.inputValue })
          }
        />  
    </div>
  );
}
