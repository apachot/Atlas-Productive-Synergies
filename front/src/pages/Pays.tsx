import React, { useEffect } from "react";
import Pays from "../components/Pays";
import NavigationMap from "../components/NavigationMap";
import Credits from "../components/Credits";
import { useGetPays } from "../api/Pays";
import FiltresLink from "../components/FiltresLink";
import { useDispatch, useSelector } from "react-redux";
import Loader from "../components/loader";
import { setDataEpci, setDataRegion, setDataTerritoire } from "../redux/dataSlice";
import { RootState } from "../redux/store";
import { isMobileOnly } from "react-device-detect";
import './Pays.scss';
import SideTopFiltres from "../components/SideTopFiltres";
import { setEpciId, setRegionAndTerritoireAndData, setTerritoireId } from "../redux/filterSlice";
import { useHistory } from "react-router";
import useScreenOrientation from "../Utility/screenOrientation";

export default function PaysPage(props: {mode?:'regions' | 'territoire' | 'EPCI'}) {
  const { mode = "regions" } = props;
  const dispatch=useDispatch() ;
  const { regions } = useSelector(
    (state: RootState) => state.data
  );
  const {
    regionId,
    territoireId,
    epciId,
  } = useSelector((state: RootState) => state.filter);
  const history = useHistory();
  const orientation = useScreenOrientation();
  const {data: regionData} = useGetPays ('region');
  const {data: itData} = useGetPays ('it');
  const {data: epciData} = useGetPays ('epci');

  useEffect(() => {
    regionData && dispatch(setDataRegion(regionData.region)) ;
  }, [regionData, dispatch])

  useEffect(() => {
    itData && dispatch(setDataTerritoire(itData.industry_territory)) ;
  }, [itData, dispatch])

  useEffect(() => {
    epciData && dispatch(setDataEpci(epciData.epci)) ;
  }, [epciData, dispatch])

  const changementRegion = (region: string) => {
    if (region !== regionId) {
      dispatch(setRegionAndTerritoireAndData({ regionId: region, territoireId: undefined, epciId: undefined, data: undefined }));
    }
  };

  const changementTI = (territoire?: string) => {
    if (territoire !== territoireId) {
      dispatch(setTerritoireId(territoire));
    }
  };

  const changementEpci = (epci?: string) => {
    if (epci !== epciId) {
      dispatch(setEpciId(epci));
    }
  };

  if (regions.length === 0) {
    return <Loader />
  } 

  if (isMobileOnly) {
    return(
      <div className={`Alt-Pays ${orientation}`}>
        <div className = {`Fond ${orientation}`}>
          <SideTopFiltres 
            mode="detail" 
            titre="" 
            setRegion={changementRegion} 
            setTerritoire={changementTI} 
            setEpci={changementEpci}
            modeRech={mode}
          />
          <button
            className="Explore"
            onClick={() => {history.push(`/etablissements/${epciId ? `EPCI${regionId}-${epciId}` : (territoireId ? territoireId : regionId)}`);}}
            disabled = {regionId === ""}
          >
            Commencer à explorer
          </button>
          <Credits />
          <NavigationMap mode={mode} /> 
          {regions.length === 0 ? <Loader /> : <Pays mode={mode}/> }
        </div>
      </div>
    )
  }

  return (
    <div className="Pays">
      <NavigationMap mode={mode} />
      <FiltresLink />
      <Credits />
      <Pays
        mode={mode}
      />
    </div>
  );
}
