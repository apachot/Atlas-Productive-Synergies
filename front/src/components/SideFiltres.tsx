/**
 * Filtres sur les différents éléments (produits, établissements, métiers)
 */
import React, { useCallback, useEffect, useState } from "react";
import Select from "react-select";
import AsyncSelect from "react-select/async";
import { EtablissementShortType, searchEtablissement } from "../api/Etablissements";
import { useTranslation, getI18n } from 'react-i18next';
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { setEtablissementOptions } from "../redux/filterSlice";
import { jobPosition, productNames} from "./space/spaceData";
import './SideFiltres.scss' ;

const customFilter = (option: { value: string, label: string }, searchText: string) => {
  return (
    option.value.toLowerCase().includes(searchText.toLowerCase()) ||
    option.label.toLowerCase().includes(searchText.toLowerCase())
  );
};

export default function SideFiltres(props: {
  setEtablissement?: (selected?: string | undefined) => void,
  setProduit?: {(id?:string): void},
  setMetier?:  {(id?:string): void},
  filtresIndisponibles?: any,
}) {
  const {
    setEtablissement = () => { },
    setProduit = () => { },
    setMetier = () => { },
    filtresIndisponibles,
  } = props;
  const {
    regionId,
    territoireId,
    etablissementId,
    produitId,
    metierId,
    etablissementOptions,
  } = useSelector((state: RootState) => state.filter);
  const { t } = useTranslation();
  const [optionsProduits, setOptionsProduits] = useState<{ value: string, label: string }[]>([])
  const [optionsMetiers, setOptionsMetiers] = useState<{ value: string, label: string }[]>([])
  // const [optionsMetiers, setOptionsMetiers] = useState<{ value: string, label: string }[]>([])

  useEffect(() => {
    setOptionsProduits(productNames.nodes.map(n => ({
      value: n.id,
      label: n.libShort[getI18n().language] + ` (${n.id})`
    })).sort((a,b) => ((a.label>b.label) && 1) || -1)
    )
    setOptionsMetiers(jobPosition.nodes.map(n => ({
      value: n.id,
      label: n.libShort[getI18n().language] + ` (${n.id})`
    })).sort((a,b) => ((a.label>b.label) && 1) || -1))
  }, [])

  const dispatch = useDispatch();
  const mapOptionsToValues = useCallback((options: EtablissementShortType[]) => {
    return options.map((option) => ({
      value: option.id,
      label: option.usual_name
        ? option.usual_name + " " + option.siret
        : option.siret,
      id: option.id,
      wf: option.workforce_group,
    }));
  }, []);

  const loadSuggestions = (inputValue: any, callback: any) => {
    if (inputValue.length === 0) {
      return etablissementOptions;
    }
    //TODO gérer une temporisation sur la recherche
    if (inputValue.length < 3) {
      return callback([]);
    }
    searchEtablissement({
      searchStr: inputValue,
      regionId,
      indusTerritoryId: territoireId,
    }).then((data) => {
      const newEtablishments = mapOptionsToValues(data.establishments)
      callback(newEtablishments);
      dispatch(setEtablissementOptions(newEtablishments));
    });
  };

  return (
    <div className="SideFiltres" >
      <div className={`relative ${filtresIndisponibles?.etablissement ? "disabled" : ""}`} >
        <AsyncSelect
          className="react-select-container"
          classNamePrefix="react-select"
          onChange={(e) => setEtablissement(e?.id)}
          isClearable={true}
          placeholder={t("Sélectionner un établissement")}
          noOptionsMessage={(texte) =>
            texte.inputValue.length > 2
              ? t("Aucun établissement trouvé pour : {{input}}", { input: texte.inputValue })
              : t("Saisir le nom ou siret d'une entreprise")
          }
          value={etablissementOptions?.find((obj) => obj.id === etablissementId)}
          defaultOptions={etablissementOptions}
          cacheOptions={true}
          loadOptions={loadSuggestions}
          isDisabled={filtresIndisponibles?.etablissement}
        />
      </div>
      <div className={`relative ${filtresIndisponibles?.produit ? "disabled" : ""}`}>
        <Select
          className="react-select-container"
          classNamePrefix="react-select"
          options={optionsProduits}
          value={optionsProduits.find((obj) => obj.value === produitId)}
          onChange={(e) => setProduit && setProduit(e?.value)}
          filterOption={customFilter}
          isClearable={true}
          placeholder={t("Sélectionner un produit")}
          noOptionsMessage={(texte) =>
            t("Aucun produit trouvé pour : {{input}}", { input: texte.inputValue })
          }
          isSearchable={true}
          isOptionSelected={(selOpt) => selOpt.value === produitId}
        />
      </div>
      <div className={`relative ${filtresIndisponibles?.metier ? "disabled" : ""}`}>
        <Select
          className="react-select-container"
          classNamePrefix="react-select"
          options={optionsMetiers}
          value={optionsMetiers.find((obj) => obj.value === metierId)}
          onChange={(e) => setMetier && setMetier(e?.value)}
          filterOption={customFilter}
          isClearable={true}
          placeholder={t("Sélectionner un métier")}
          noOptionsMessage={(texte) =>
            t("Aucun produit métier  pour  : {{input}}", { input: texte.inputValue })
          }
          isOptionSelected={(selOpt) => selOpt.value === metierId}
        />
      </div>
      {/* TODO: SELECT FORMATION 
      <div className={`relative ${filtresIndisponibles?.metier ? "disabled" : ""}`}>
        <Select
          className="react-select-container"
          classNamePrefix="react-select"
          isClearable={true}
          placeholder={t("Sélectionner une formation")}
          noOptionsMessage={(texte) =>
            t("Aucun formation pour  : {{input}}", { input: texte.inputValue })
          }
          isDisabled={filtresIndisponibles?.metier}
        />
      </div>
      */}
    </div>
  );
}
