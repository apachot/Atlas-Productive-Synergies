import React, { Suspense, useEffect, useState } from "react";
import { useGetEtablissements } from "../api/Etablissements";
import { useTranslation } from 'react-i18next';
import { setCount } from "../redux/countSlice";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { useHistory } from "react-router";
import { getinitialData, setEpciId, setEtablissementId, setEtablissementOptionsAndId, setMetierId, setProduitId, setRegionAndTerritoireAndData, setTerritoireId } from "../redux/filterSlice";
import Loader from "../components/loader";
import { isMobileOnly } from "react-device-detect";
import useScreenOrientation from "../Utility/screenOrientation";
import { setBiom, setEmployer, setEstablishments, setParity, setPartners } from "../redux/establishmentsSlice";
import './Etablissements.scss';
import SideInfosRegion from "../components/SideInfosRegion";

const Region = React.lazy(() => import("../components/Region"));
const SideBar = React.lazy(() => import("../components/SideBar"));
const FiltresEtablissement = React.lazy(() => import("../components/Filtres"));


export default function EtablissementsPage() {
  const {
    secteurs,
    effectifs,
    regionId,
    epciId,
    territoireId,
    produitId,
    urlForApi,
    metierId,
  } = useSelector((state: RootState) => state.filter);
  const { establishments } = useSelector((state: RootState) => state.establishment);
  const dispatch = useDispatch();
  const history = useHistory();
  const [initMap, setInitMap] = useState(false);
  const { t } = useTranslation();
  const orientation = useScreenOrientation();

  const { data: dataEtablissement, isLoading: isLoadingEtablissement } = useGetEtablissements(urlForApi, 'establishments');
  const { data: dataBiom } = useGetEtablissements(urlForApi, 'biom');
  const { data: dataParity } = useGetEtablissements(urlForApi, 'parity');
  const { data: dataPartners } = useGetEtablissements(urlForApi, 'partners');
  const { data: dataCount } = useGetEtablissements(urlForApi, 'count');
  const { data: dataEmployer } = useGetEtablissements(urlForApi, 'employer');

  useEffect(() => {
    if (dataEtablissement) {
      dispatch(setEstablishments(dataEtablissement.establishments));
      setInitMap(false)
    }
  }, [dispatch, dataEtablissement]);

  useEffect(()=>{
    if (dataBiom) {
      dispatch(setBiom(dataBiom.biom))
    }
  }, [dispatch,dataBiom ])

  useEffect(()=>{
    if (dataParity) {
      dispatch(setParity(dataParity.parity))
    }
  }, [dispatch,dataParity ])

  useEffect(()=>{
    if (dataPartners) {
      dispatch(setPartners(dataPartners.partners))
    }
  }, [dispatch,dataPartners ])

  useEffect(()=>{
    if (dataCount) {
      const { job, product, establishment } = dataCount.count;
      dispatch(setCount({ nbProduit: product, nbEtablissement: establishment, nbMetier: job, }));
    }
  }, [dispatch,dataCount ])

  useEffect(()=>{
    if (dataEmployer) {
      dispatch(setEmployer(dataEmployer.employer))
    }
  }, [dispatch,dataEmployer ])


  const changementRegion = (region: string) => {
    if (region !== regionId) {
      dispatch(setRegionAndTerritoireAndData({ regionId: region, territoireId: undefined, epciId: undefined, data: undefined }));
      history.push(epciId ? `/etablissements/EPCI${region}-0` : `/etablissements/${region}`);
    }
  };

  const changementTI = (territoire?: string) => {
    dispatch(setEstablishments(undefined))
    dispatch(setTerritoireId(territoire));
    history.push(territoire ? `/etablissements/${territoire}` : `/etablissements/${regionId}`);
  };

  const changementEpci = (epci?: string) => {
    dispatch(setEstablishments(undefined))
    dispatch(setEpciId(epci ? epci : '0'));
    history.push(epci ? `/etablissements/EPCI${regionId}-${epci}` : `/etablissements/EPCI${regionId}-0`);
  };

  const changementProduit = (produitSelected?: string) => {
    const zone = epciId ? `EPCI${regionId}-${epciId}` : (territoireId ? territoireId : regionId);;
    if (produitSelected) {
      if (produitSelected !== produitId) {
        dispatch(setProduitId(produitSelected));
        history.push(`/etablissements/${zone}/produit/${produitSelected}`);
      }
    } else {
      //Le produit a été déselectionné
      if (produitId) {
        dispatch(setProduitId(undefined));
        history.push(`/etablissements/${zone}`);
      }
    }
  };

  const changementEtablissement = (selected?: string) => {
    const zone = epciId ? `EPCI${regionId}-${epciId}` : (territoireId ? territoireId : regionId);;
    if (selected) {
      dispatch(setEtablissementOptionsAndId({ option: undefined, id: parseInt(selected) }));
      history.push(`/etablissement/${zone}/${selected}`);
    } else {
      dispatch(setEtablissementId(undefined));
      history.push(`/etablissements/${zone}/`);
    }
  };

  const changementMetier = (selected?: string) => {
    if (selected !== metierId) {
      dispatch(setMetierId(selected));
    }
  };

  const modeRech: "regions" | "EPCI" | "territoire" = getinitialData().epciId ? 'EPCI' : getinitialData().territoireId ? "territoire" : "regions";

  return (
    <div className={`Etablissements ${orientation} ${isMobileOnly && "MobileOnly"} ${(isLoadingEtablissement) && "Wait"}`}>
      <div className="LeftPart">
        {establishments ? (
          <Suspense fallback={<Loader />}>
            <Region
              changementEtablissement={changementEtablissement}
              isLoading={isLoadingEtablissement}
              navigation={"etablissements"}
              initMap={initMap}
              setInitMap={setInitMap}
            />
          </Suspense>
        ) : (
          <div className={"Loader"}>
            <Loader />
          </div>
        )}
        <Suspense fallback={<Loader />}>
          <FiltresEtablissement
            secteurs={secteurs}
            effectifs={effectifs}
            isLoading={ isLoadingEtablissement}
            setInitMap={setInitMap}
          />
        </Suspense>
      </div>

      {establishments ? (
        <Suspense fallback={<Loader />}>
          <SideBar
            titre={t("Espace géographique")}
            setRegion={changementRegion}
            setTerritoire={changementTI}
            setEpci={changementEpci}
            modeRech={modeRech}
          >
            <SideInfosRegion
              navigation={"etablissements"}
              titre={t("Espace géographique")}
              setProduit={changementProduit}
              setEtablissement={changementEtablissement}
              setMetier={changementMetier}
              topMetiers={[]}
            />
          </SideBar>
        </Suspense>
      ) : (
        <Loader />
      )}
    </div>
  );
}
