import React, { useEffect, useState } from "react";
import Etablissement from "../components/Etablissement";
import SideBar from "../components/SideBar";
import Filtres from "../components/Filtres";
import SideInfosEtablissement from "../components/SideInfosEtablissement";
import { EtablissementLongType, useGetEtablissement } from "../api/Etablissements";
import { findActivesFilters } from "../Utils";
import { useTranslation } from 'react-i18next';
import { useDispatch, useSelector } from "react-redux";
import { setCount } from "../redux/countSlice";
import { RootState } from "../redux/store";
import { useHistory } from "react-router";
import { setEtablissementId, setEtablissementOptionsAndId, setProduitId } from "../redux/filterSlice";
import Loader from "../components/loader";
import { isMobileOnly } from "react-device-detect";
import useScreenOrientation from "../Utility/screenOrientation";
import './Etablissement.scss'

export default function EtablissementPage() {
  const { etablissementId, regionId, territoireId, epciId, urlForApi } = useSelector((state: RootState) => state.filter);
  const dispatch = useDispatch();
  const history = useHistory();
  const isLoading =false;
  const [etablissement, setEtablissement] = useState<EtablissementLongType>();
  const [secteurs, setSecteurs] = useState<number[]>([]);
  const [effectifs, setEffectifs] = useState<number[]>([]);
  const [availableFilters, setAvailableFilters] = useState<{
    effectifs: any[],
    secteurs: any[],
  }>({
    effectifs: [],
    secteurs: [],
  });
  const { t } = useTranslation();
  const orientation=useScreenOrientation();

  const setProduit = (produitSelected?: string) => {
    const zone = epciId ? `EPCI${regionId}-${epciId}` : (territoireId ? territoireId : regionId);
    if (produitSelected) {
      dispatch(setProduitId(produitSelected))
      history.push(`/produits/${zone}`)
    }
  };

  const {data: dataEtablissement} = useGetEtablissement(urlForApi, etablissementId) ;

  useEffect(() => {
    if (dataEtablissement) {
      const { secteursActifs, effectifsActifs } = findActivesFilters(
        dataEtablissement.partner,
        dataEtablissement
      );      
      setSecteurs(secteursActifs);
      setEffectifs(effectifsActifs);
      setAvailableFilters({
        secteurs: secteursActifs,
        effectifs: effectifsActifs,
      });
      setEtablissement(dataEtablissement);
      const { job, product, establishment } = dataEtablissement.count;
      dispatch(setCount({ nbProduit: product, nbEtablissement: establishment, nbMetier: job }));
  }
  }, [dataEtablissement, dispatch])

  const changementEtablissement: { (selected?: string): void } = (selected) => {
    const zone = epciId ? `EPCI${regionId}-${epciId}` : (territoireId ? territoireId : regionId);
    if (selected) {
      dispatch(setEtablissementOptionsAndId({ option: undefined, id: parseInt(selected) }));
      history.push(`/etablissement/${zone}/${selected}`);
    } else {
      dispatch(setEtablissementId(undefined));
      history.push(`/etablissements/${zone}/`);
    }
  };

  return (
    <div className={`Etablissement ${orientation} ${isMobileOnly && "MobileOnly"}`}>
      <div className="LeftPart">
        {etablissement ? (
          <Etablissement
            etablissement={etablissement}
            secteurs={secteurs}
            effectifs={effectifs}
            changementEtablissement={changementEtablissement}
            isLoading={isLoading}
          />
        ) : (
          <div className={"Loader"} >
            <Loader />
          </div>
        )}
        <Filtres
          secteurs={secteurs}
          setSecteurs={setSecteurs}
          secteursFiltrable={availableFilters.secteurs}
          effectifs={effectifs}
          setEffectifs={setEffectifs}
          effectifsFiltrable={availableFilters.effectifs}
          mode={"local"}
          isLoading={isLoading}
        />
      </div>
      {etablissement ? (
        <SideBar
          titre={t("Espace géographique")}
          mode={"full"}
          handleBack={changementEtablissement}
          setEpci={()=>{}}
          setRegion={()=>{}}
          setTerritoire={()=>{}}
          modeRech='regions'
        >
          <SideInfosEtablissement
            etablissement={etablissement}
            setProduit={setProduit}
            sideHeight={window.innerHeight - 68}
          />
        </SideBar>
      ) : (
        <Loader />
      )}
    </div>
  );
}
