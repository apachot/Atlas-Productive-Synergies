import React, { useEffect, useState } from "react";
import FiltresProduits from "../components/Filtres";
import SideBar from "../components/SideBar";
import SideInfosProduit from "../components/SideInfosProduit";
import TargetGraph from "../components/TargetGraph";
import { useGetProduitProximite, useGetProduits, ProduitProximiteType } from "../api/Produits";
import { getEffectifFromWF } from "../Utils";
import { useTranslation } from 'react-i18next';
import { setCount } from "../redux/countSlice";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { productEqualizer } from "../Utility/productUtil";
import { getUrlFromFilter, setProduitId } from "../redux/filterSlice";
import { useHistory } from "react-router";
import Loader from "../components/loader";
import { isMobileOnly } from "react-device-detect";
import useScreenOrientation from "../Utility/screenOrientation";
import './Produit.scss';

type availableFiltersType = {
  effectifs: number[],
  secteurs: number[],
}

type LeftPartType = {
  produits?: ProduitProximiteType;
  secteurs: number[];
  effectifs: number[];
  produit?: ProduitProximiteType;
  setProduitIdSelected: React.Dispatch<React.SetStateAction<string | undefined>>;
  isLoading: boolean;
  setSecteurs: React.Dispatch<React.SetStateAction<number[]>>;
  availableFilters: availableFiltersType;
  setEffectifs: React.Dispatch<React.SetStateAction<number[]>>;
}
const LeftPart = ({
  produits,
  secteurs,
  produit,
  effectifs,
  setProduitIdSelected,
  isLoading,
  setSecteurs,
  availableFilters,
  setEffectifs,
}: LeftPartType) => {
  const { regionId, territoireId, produitId } = useSelector((state: RootState) => state.filter)
  return (
    <div className="LeftPart">
      <div className={"TargetGraph"} >
        {produits ? (
          <TargetGraph
            navigation={"produits"}
            className={"h-full"}
            produits={produits}
            produitSelected={produit}
            regionId={regionId}
            territoireId={territoireId}
            secteurs={secteurs}
            effectifs={effectifs}
            produitId={produitId}
            handleNodeClick={(id?: string) => {
              setProduitIdSelected(id);
            }}
            isLoading={isLoading}
          />
        ) : (
          <div className='Loader'><Loader /></div>
        )}
      </div>
      <FiltresProduits
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

  )
}

export default function ProduitPage(props: {}) {
  const filterState = useSelector((state: RootState) => state.filter)
  const { regionId, territoireId, epciId, produitId, urlForApi } = filterState;
  const dispatch = useDispatch();
  const history = useHistory();
  const { advantage, green, maslow, pci, resilience } = useSelector(
    (state: RootState) => state.objective
  );

  const [secteurs, setSecteurs] = useState<number[]>([]);
  const [effectifs, setEffectifs] = useState<number[]>([]);
  const [availableFilters, setAvailableFilters] = useState<availableFiltersType>({
    effectifs: [],
    secteurs: [],
  });
  const [produits, setProduits] = useState<ProduitProximiteType>();
  const [produitsRaw, setProduitsRaw] = useState<ProduitProximiteType>();
  const [produitIdSelected, setProduitIdSelected] = useState<string>();
  const [produit, setProduit] = useState<ProduitProximiteType>();
  const { t } = useTranslation();
  const orientation = useScreenOrientation();

  const { data: dataProduitProximite, isLoading: isLoadingProduitProximite} = useGetProduitProximite(getUrlFromFilter({
    ...filterState,
    produitId: produitIdSelected,
  }), produitIdSelected)
  const { data: dataProduitProximiteCentre, isLoading: isLoadingProduitProximiteCentre} = useGetProduitProximite(urlForApi, produitId)  
  const { data: dataProduit, isLoading: isLoadingProduit} = useGetProduits(urlForApi)  

  const isLoading = isLoadingProduitProximite || isLoadingProduitProximiteCentre || isLoadingProduit;

  /**
   * Si on arrive sur cette page sans être passé par l'espace géo,
   * on envoie la requête pour avoir les compteurs
   */
   useEffect(() => {
     if (dataProduit) {
      const { job, product, establishment } = dataProduit.count;
      dispatch(setCount({ nbProduit: product, nbEtablissement: establishment, nbMetier: job, }));
     }
  }, [dataProduit, dispatch]);

  /**
   * Récupération du coeur de la cible et définition des filtres utilisables
   * On ne considère pas les filtres actifs, les données sont filtrées sur le front
   */
   useEffect(() => {
     if (dataProduitProximiteCentre) {
      setProduitsRaw(dataProduitProximiteCentre);
      const { job, product, establishment } = dataProduitProximiteCentre.count;
      dispatch(setCount({ nbProduit: product, nbEtablissement: establishment, nbMetier: job, }))
     }
  }, [dispatch, dataProduitProximiteCentre]);

  useEffect(() => {
    if (dataProduitProximite) {
        setProduitsRaw(dataProduitProximite);
        setProduit(productEqualizer(dataProduitProximite, advantage, green, maslow, pci, resilience));
    } else {
      setProduit(undefined);
    }
  }, [dataProduitProximite, advantage, green, maslow, pci, resilience]);


  const changementProduit = (produitSelected?: string) => {
    if (produitSelected !== produitId) {
      const zone = epciId ? `EPCI${regionId}-${epciId}` : (territoireId ? territoireId : regionId);
      dispatch(setProduitId(produitSelected))
      produitSelected ? history.push(`/produit/${zone}/${produitSelected}`) : history.push(`/produits/${zone}`);
    }
  };

  

  useEffect(() => {
    const secteursActifs: number[] = [];
    const effectifsActifs: number[] = [];
    if (produits) {
      secteursActifs.push(produits.product.sector_id);

      produits.product.workforce_group.forEach((wfGroup) => {
        if (!effectifsActifs.includes(getEffectifFromWF(wfGroup))) {
          effectifsActifs.push(getEffectifFromWF(wfGroup));
        }
      });
      produits.proximities.map((produit) => {
        if (!secteursActifs.includes(produit.macro_sector_id)) {
          secteursActifs.push(produit.macro_sector_id);
        }
        produit.workforce_group.map((wfGroup) => {
          if (!effectifsActifs.includes(getEffectifFromWF(wfGroup))) {
            effectifsActifs.push(getEffectifFromWF(wfGroup));
          }
          return true;
        });
        return true;
      });
    }
    setSecteurs(secteursActifs);
    setEffectifs(effectifsActifs);
    setAvailableFilters({
      secteurs: secteursActifs,
      effectifs: effectifsActifs,
    });
  }, [produits])

  useEffect(() => {
    if (produitsRaw) {
      setProduits(productEqualizer(produitsRaw, advantage, green, maslow, pci, resilience));
    }
  }, [advantage, green, maslow, pci, resilience, produitsRaw])

  return (
    <div className={`Produit ${isLoading && "Wait"} ${isMobileOnly && "MobileOnly"} ${orientation}`}>
      <LeftPart
        availableFilters={availableFilters}
        effectifs={effectifs}
        isLoading={isLoading}
        secteurs={secteurs}
        setEffectifs={setEffectifs}
        setProduitIdSelected={setProduitIdSelected}
        setSecteurs={setSecteurs}
        produit={produit}
        produits={produits}
      />
      {produits ? (
        <SideBar
          titre={t("Espace productif")}
          mode={"full"}
          handleBack={
            produit
              ? () => {
                setProduitIdSelected(undefined);
              }
              : () => {
                changementProduit(undefined);
              }
          }
          modeRech="regions"
          setEpci={()=>{}}
          setRegion={()=>{}}
          setTerritoire={()=>{}}
        >
          <SideInfosProduit
            typeLiaison={"Proximité"}
            produit={produits}
            produitIdSelected={produitIdSelected}
            produitSelected={produit}
            setProduit={changementProduit}
          />
        </SideBar>
      ) : (
        <Loader />
      )}
    </div>
  );
}
