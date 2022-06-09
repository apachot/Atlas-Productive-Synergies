import React, { useEffect, useRef, useState } from "react";
import SideBar from "../components/SideBar";
import FiltresProduits from "../components/Filtres";
import { useGetProduits, useGetProduitParente, ProduitParenteType, RcaType, Madetype } from "../api/Produits";
import { newProductSpaceFormat, ProductSpaceFormat } from "../Utils";
import { allWorkforces, defaultVisibleSectors } from "../maps/mapsConfig";
import SideInfosProduit from "../components/SideInfosProduit";
import SideInfosRegion from "../components/SideInfosRegion";
import { useTranslation } from 'react-i18next';
import { useDispatch, useSelector } from "react-redux";
import { setCount } from "../redux/countSlice";
import { RootState } from "../redux/store";
import { getinitialData, setEpciId, setEtablissementId, setMetierId, setProduitId, setRegionAndTerritoireAndData, setTerritoireId } from "../redux/filterSlice";
import { useHistory } from "react-router";
import { productPosition } from "../components/space/spaceData";
import OSSpace, { RefOSSpace } from "../components/space/oSSpace";
import Navigation from "../components/Navigation";
import FiltresLink from "../components/FiltresLink";
import { isMobileOnly } from "react-device-detect";
import useScreenOrientation from "../Utility/screenOrientation";

import './Produits.scss';

type LeftPartType = {
  produits: ProductSpaceFormat[];
  changementProduit: (produitSelected?: string) => void;
  spaceRef: React.RefObject<RefOSSpace>;
  isLoading: boolean;
}
const LeftPart = ({ produits, changementProduit, spaceRef, isLoading }: LeftPartType) => {
  const {
    secteurs,
    effectifs,
    produitId,
  } = useSelector((state: RootState) => state.filter);
  return (
    <div className="LeftPart">
      <Navigation navigation={'produits'} />
      <FiltresLink navigation={'produits'} />
      <OSSpace
        data={produits}
        onNodeClick={changementProduit}
        selected={produitId}
        ref={spaceRef}
        secteurs={secteurs.map(v => v.toString())}
        box={productPosition.box}
      />
      <FiltresProduits
        secteurs={secteurs}
        effectifs={effectifs}
        secteursFiltrable={defaultVisibleSectors}
        effectifsFiltrable={allWorkforces}
        isLoading={isLoading}
      />
    </div>

  )
}

type RightPartType = {
  produit?: ProduitParenteType;
  changementProduit: (selected?: string) => void;
  changementRegion: (selected: string) => void;
  changementTI: (selected?: string) => void;
  changementEpci: (selected?: string) => void;
  changementEtablissement: (selected?: string) => void;
  changementMetier: (selected?: string) => void;
  topProduits?: [RcaType[], Madetype[]];
}
const RightPart = ({
  produit,
  changementProduit,
  changementRegion,
  changementTI,
  changementEpci,
  changementEtablissement,
  changementMetier,
  topProduits,
}: RightPartType) => {
  const {
    produitId,
  } = useSelector((state: RootState) => state.filter);
  const { t } = useTranslation();
  const dispatch = useDispatch();

  const modeRech: "regions" | "EPCI" | "territoire" = getinitialData().epciId ? 'EPCI' : getinitialData().territoireId ? "territoire" : "regions";

  if (produitId) {
    return (
      <SideBar
        titre={t("Espace productif")}
        mode={"full"}
        handleBack={() => {
          dispatch(setProduitId(undefined));
        }}
        modeRech={modeRech}
        setTerritoire={() => { }}
        setRegion={() => { }}
        setEpci={() => { }}
      >
        <SideInfosProduit
          produit={produit}
          setProduit={changementProduit}
          typeLiaison={"Parenté"}
        />
      </SideBar>
    )
  }
  return (
    <SideBar
      titre={t("Espace productif")}
      setRegion={changementRegion}
      setTerritoire={changementTI}
      modeRech={modeRech}
      setEpci={changementEpci}
    >
      <SideInfosRegion
        filtresIndisponibles={{ metier: true, }}
        navigation={"produits"}
        setEtablissement={changementEtablissement}
        setMetier={changementMetier}
        setProduit={changementProduit}
        titre={t("Espace productif")}
        topProduits={topProduits}
        topMetiers={[]}
      />
    </SideBar >
  )
}

export default function ProduitsPage() {
  const {
    regionId,
    territoireId,
    produitId,
    etablissementId,
    urlForApi,
    metierId,
    epciId,
  } = useSelector((state: RootState) => state.filter);
  const dispatch = useDispatch();
  const history = useHistory();
  const [produits, setProduits] = useState<ProductSpaceFormat[]>([]);
  const [topProduits, setTopProduits] = useState<[RcaType[], Madetype[]]>();
  const [produit, setProduit] = useState<ProduitParenteType>();
  const spaceRef = useRef<RefOSSpace>(null)
  const orientation = useScreenOrientation();

  const { data: dataProduitParente, isLoading: isLoadingProduitParente} = useGetProduitParente (urlForApi, produitId)
  const { data: dataProduits, isLoading: isLoadingProduits} = useGetProduits (urlForApi)

  const isLoading = isLoadingProduitParente || isLoadingProduits;

  //Récupération des éléments à afficher selon la sélection de l'utilisateur
  useEffect(() => {
    if (dataProduits) {
        const mustRefresh = produits.length === 0;
        setProduits(newProductSpaceFormat(dataProduits, productPosition));
        mustRefresh && spaceRef.current?.forceRefresh();
        setTopProduits([dataProduits.rca, dataProduits.made]);
        const { job, product, establishment } = dataProduits.count;
        dispatch(setCount({ nbProduit: product, nbEtablissement: establishment, nbMetier: job, }));
    }
  }, [dispatch, produits.length, dataProduits]);  

  //Récupération des données du produit sélectionné
  useEffect(() => {
    if (dataProduitParente) {
        setProduit(dataProduitParente);
        const { job, product, establishment } = dataProduitParente.count;
        dispatch(setCount({ nbProduit: product, nbEtablissement: establishment, nbMetier: job }));
      };
  }, [dispatch, dataProduitParente]);  

  const changementProduit = (produitSelected?: string) => {
    if (produitSelected !== produitId) {
      setProduit(undefined);
      dispatch(setProduitId(produitSelected));
    }
  };

  const changementMetier = (metierSelected?: string) => {
    if (metierSelected !== metierId) {
      setProduits([]);
      dispatch(setMetierId(metierSelected))
    }
  };

  const changementEtablissement = (selected?: string) => {
    const si = selected ? parseInt(selected) : undefined;
    if (si === etablissementId) return;
    //attente du chargement du graphe
    dispatch(setEtablissementId(si));
  };

  const changementTI = (territoire?: string) => {
    if (territoire !== territoireId) {
      setProduits([]);
      if (territoire) {
        dispatch(setTerritoireId(territoire));
        history.push(`/produits/${territoire}`);
      } else {
        dispatch(setTerritoireId(undefined))
        history.push(`/produits/${regionId}`);
      }
    }
  };

  const changementEpci = (epci?: string) => {
    if (epci !== epciId) {
      setProduits([]);
      dispatch(setEpciId(epci ? epci : '0'));
      history.push(`/produits/EPCI${regionId}-${epci ? epci : '0'}`);
    }
  };

  const changementRegion = (region: string) => {
    if (region !== regionId) {
      dispatch(setRegionAndTerritoireAndData({ regionId: region, territoireId: undefined, epciId: undefined, data: undefined }));
      history.push(`/produits/${region}`);
    }
  };

  return (
    <div className={`Produits ${isLoading ? "Wait" : ""} ${isMobileOnly && "MobileOnly"} ${orientation}`}>
      <LeftPart
        changementProduit={changementProduit}
        isLoading={isLoading}
        produits={produits}
        spaceRef={spaceRef}
      />
      <RightPart
        changementEtablissement={changementEtablissement}
        changementMetier={changementMetier}
        changementProduit={changementProduit}
        changementRegion={changementRegion}
        changementTI={changementTI}
        changementEpci={changementEpci}
        produit={produit}
        topProduits={topProduits}
      />
    </div>
  );
}
