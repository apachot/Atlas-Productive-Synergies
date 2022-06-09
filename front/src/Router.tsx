import React, { Suspense, useEffect } from "react";
import { Route, Switch, useLocation } from "react-router-dom";
import NotFound from "./pages/NotFound";
import { useGetRegion } from "./api/Global";
import { useGetEtablissement } from "./api/Etablissements";
import Header from "./components/Header";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "./redux/store";
import { setEtablissementOptions, setRegionData } from "./redux/filterSlice";
import ReactGA from "react-ga";
import Loader from "./components/loader";

import 'leaflet';
import 'leaflet-providers';
import './lib/CanvasFlowmapLayer';

/*
import PaysPage from "./pages/Pays";
import EtablissementPage from "./pages/Etablissement";
import EtablissementsPage from "./pages/Etablissements";
import ProduitsPage from "./pages/Produits";
import ProduitPage from "./pages/Produit";
import MetiersPage from "./pages/Metiers";
import FiltresPage from "./pages/FiltresGlobaux";
*/

const EtablissementsPage = React.lazy(() => import("./pages/Etablissements"));
const EtablissementPage = React.lazy(() => import("./pages/Etablissement"));
const ProduitsPage = React.lazy(() => import("./pages/Produits"));
const ProduitPage = React.lazy(() => import("./pages/Produit"));
const MetiersPage = React.lazy(() => import("./pages/Metiers"));
const FiltresPage = React.lazy(() => import("./pages/FiltresGlobaux"));
const PaysPage = React.lazy(() => import("./pages/Pays"));



function MainRouter() {
  const dispatch = useDispatch()
  const { regionId, etablissementId, urlForApi, etablissementOptions, regionData, epciId } = useSelector((state: RootState) => state.filter)
  const { error } = useSelector((state: RootState) => state.errors)
  const isEpci = (epciId !== undefined)
  const { data: loadRegionData } = useGetRegion({regionId, part: (isEpci ? 'epci' : 'it')})
  const { data: dataEtablissement } = useGetEtablissement(urlForApi, etablissementId)
  //Initialisation des données asynchrones sur les filtres initiales

  useEffect(() => {
    if (loadRegionData) {
      dispatch(setRegionData(loadRegionData))
    }
  }, [loadRegionData, dispatch])

  useEffect(() => {
    if (!etablissementOptions && dataEtablissement) {
        dispatch(setEtablissementOptions([
          {
            id: dataEtablissement.id,
            value: dataEtablissement.id,
            label: dataEtablissement.usual_name,
          },
        ]))
    }
    if (!etablissementOptions && regionData && !etablissementId) {
      dispatch(setEtablissementOptions([]));
    }
  }, [dataEtablissement, dispatch, etablissementOptions, regionData, etablissementId]);

  useEffect(() => {
    if (error) {
      throw error;
    }
  }, [error]);

  const location = useLocation();
  if (process.env.REACT_APP_GOOGLE_ANALYTIC) {
    ReactGA.initialize(process.env.REACT_APP_GOOGLE_ANALYTIC, { debug: false });
    ReactGA.pageview(location.pathname);
  }

  return (
    <Suspense fallback={<Loader />}>
      <Switch>
        {/* Page d'accueil */}
        <Route path="/" exact>
          <Header first={true} />
          <PaysPage />
        </Route>
        <Route path="/territoire" exact>
          <Header />
          <PaysPage
            mode={"territoire"}
          />
        </Route>
        <Route path="/EPCI" exact>
          <Header />
          <PaysPage
            mode={"EPCI"}
          />
        </Route>

        {/* Vues Produits */}
        <Route path="/produits/:zoneId/:etablissementId?">
          <Header />
          <ProduitsPage />
        </Route>
        <Route path="/produit/:zoneId/:produitId?">
          <Header />
          <ProduitPage />
        </Route>

        {/* Vues Géolocalisées */}
        <Route path="/region/:zoneId">
          <Header />
          <EtablissementsPage />
        </Route>
        <Route path="/etablissements/:zoneId" exact>
          <Header />
          <EtablissementsPage />
        </Route>
        <Route path="/etablissements/:zoneId/produit/:produitId">
          <Header />
          <EtablissementsPage />
        </Route>
        <Route path="/etablissements/:zoneId/metier/:metierId">
          <Header />
          <EtablissementsPage />
        </Route>
        <Route path="/etablissement/:zoneId/:etablissementId">
          <Header />
          <EtablissementPage />
        </Route>

        {/* Vues Métiers */}
        <Route path="/metiers/:zoneId">
          <Header />
          <MetiersPage />
        </Route>
        <Route path={"/filtres/:redirect"}>
          <FiltresPage />
        </Route>

        <Route>
          <Header first={true} />
          <NotFound />
        </Route>
      </Switch>
    </Suspense>
  );
}

export default MainRouter;
