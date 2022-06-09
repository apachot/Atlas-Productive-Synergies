import React, { useEffect, useRef, useState } from "react";
import SideBar from "../components/SideBar";
import { useGetMetiers, useGetMetierParente, MetiersType, MetiersRepresentativeWorkType } from "../api/Metiers";
import { ProductSpaceFormat, newProductSpaceFormat } from "../Utils";
import SideInfosMetier from "../components/SideInfosMetier";
import SideInfosRegion from "../components/SideInfosRegion";
import { useTranslation } from 'react-i18next';
import FiltresCompo from "../components/FiltresMetiers";
import { setCount } from "../redux/countSlice";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { getinitialData, setEpciId, setEtablissementId, setMetierId, setProduitId, setRegionAndTerritoireAndData, setTerritoireId } from "../redux/filterSlice";
import { useHistory } from "react-router";
import { jobPosition } from "../components/space/spaceData";
import OSSpace, { RefOSSpace } from "../components/space/oSSpace";
import Navigation from "../components/Navigation";
import FiltresLink from "../components/FiltresLink";
import { isMobileOnly } from "react-device-detect";
import useScreenOrientation from "../Utility/screenOrientation";
import './Metiers.scss';

export default function MetiersPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  const {
    domaines,
    regionId,
    metierId,
    urlForApi,
    produitId,
    etablissementId,
  } = useSelector((state: RootState) => state.filter);
  const [metiers, setMetiers] = useState<ProductSpaceFormat[]>([]);
  const [metier, setMetier] = useState<MetiersType>();
  const [topMetiers, setTopMetiers] = useState<MetiersRepresentativeWorkType[]>();
  const { t } = useTranslation();
  const spaceRef = useRef<RefOSSpace>(null)
  const orientation = useScreenOrientation();
  const [lastUrlForApi, setLastUrlForApi] = useState<string>('');

  const {data: dataMetierParente, isLoading: isLoadingParente} = useGetMetierParente (urlForApi, metierId)
  const {data: dataMetier, isLoading: isLoadingMetier} = useGetMetiers(urlForApi)

  const isLoading = isLoadingParente || isLoadingMetier;

  useEffect(() => {
    //Récupération des données du métier sélectionné
    setMetier(dataMetierParente)
    if (dataMetierParente) {
      const { job, product, establishment } = dataMetierParente.count;
        dispatch(setCount({ nbProduit: product, nbEtablissement: establishment, nbMetier: job }))
    }
  }, [dispatch, dataMetierParente]);

  //Récupération des éléments à afficher selon la sélection de l'utilisateur
  useEffect(() => {
    if (dataMetier) {
        const mustRefresh = metiers.length === 0;
        setMetiers(newProductSpaceFormat(dataMetier, jobPosition));
        mustRefresh && spaceRef.current?.forceRefresh();
        setTopMetiers(dataMetier.representativeWork);
        const { job, product, establishment } = dataMetier.count;
        dispatch(setCount({ nbProduit: product, nbEtablissement: establishment, nbMetier: job }))
      };
  }, [dispatch, dataMetier, metiers.length]);  

  useEffect(() => {
    if (lastUrlForApi !== urlForApi) {
      setLastUrlForApi(urlForApi);
    }
  }, [urlForApi,lastUrlForApi]);    

  const changementTI = (territoire?: string) => {
    if (territoire) {
      dispatch(setTerritoireId(territoire));
      history.push(`/produits/${territoire}`);
    } else {
      dispatch(setTerritoireId(undefined));
      history.push(`/produits/${regionId}`);
    }
  };

  const changementEpci = (epci?: string) => {
    dispatch(setEpciId(epci ? epci : '0'));
    history.push(`/produits/EPCI${regionId}-${epci ? epci : '0'}`);
  };

  const changementRegion = (region: string) => {
    if (region !== regionId) {
      dispatch(setRegionAndTerritoireAndData({ regionId: region, territoireId: undefined, epciId: undefined, data: undefined }));
      history.push(`/produits/${region}`);
    }
  };

  const changementEtablissement = (selected?: string) => {
    const si = selected ? parseInt(selected) : undefined;
    if (si === etablissementId) return;
    //attente du chargement du graphe
    dispatch(setEtablissementId(si));
  };

  const changementProduit = (produitSelected?: string) => {
    if (produitSelected !== produitId) {
      dispatch(setProduitId(produitSelected))
    }
  };

  const changementMetier = (metierSelected?: string) => {
    if (metierSelected !== metierId) {
      setMetier(undefined);
      dispatch(setMetierId(metierSelected))
    }
  };





  const modeRech: "regions" | "EPCI" | "territoire" = getinitialData().epciId ? 'EPCI' : getinitialData().territoireId ? "territoire" : "regions";

  return (
    <>
      <div className={`Metiers ${orientation} ${isMobileOnly && "MobileOnly"} ${isLoading && "Wait"}`}>
        <div className="LeftPart">
          <Navigation navigation={'metiers'} />
          <FiltresLink navigation={'metiers'} />
          <OSSpace
            data={metiers}
            onNodeClick={changementMetier}
            selected={metierId}
            ref={spaceRef}
            secteurs={domaines}
            box={jobPosition.box}
          />
          <FiltresCompo
            domaines={domaines}
            isLoading={isLoading}
          />
        </div>

        {metierId ? (
          <SideBar
            titre={t("Espace métier")}
            mode={"full"}
            handleBack={() => changementMetier(undefined)}
            modeRech="regions"
            setEpci={() => { }}
            setRegion={() => { }}
            setTerritoire={() => { }}
          >
            <SideInfosMetier
              metier={metier}
              setMetier={changementMetier}
            />
          </SideBar>
        ) : (
          <SideBar
            titre={t("Espace métier")}
            setRegion={changementRegion}
            setTerritoire={changementTI}
            setEpci={changementEpci}
            modeRech={modeRech}
          >
            <SideInfosRegion
              navigation={"metiers"}
              titre={t("Espace métier")}
              setEtablissement={changementEtablissement}
              setMetier={changementMetier}
              setProduit={changementProduit}
              topMetiers={topMetiers}
            />
          </SideBar>
        )}
      </div>
    </>
  );
}
