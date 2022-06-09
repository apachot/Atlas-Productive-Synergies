/**
 * Wrapper du menu et boutons du bas
 */
import React from "react";
import SideTopFiltres from "./SideTopFiltres";
import { ReactComponent as Csv } from "../svgs/csv.svg";
import { ReactComponent as Image } from "../svgs/image.svg";
import { ReactComponent as Partager } from "../svgs/partager.svg";
import { Trans } from 'react-i18next';
import { useSelector } from "react-redux";
import { RootState } from "../redux/store";
import Loader from "./loader";
import './SideBar.scss';

type SideButtonType = {
  Image: React.FunctionComponent<React.SVGProps<SVGSVGElement> & { title?: string | undefined; }>
  text:string
}
const SideButton = ({Image, text}: SideButtonType) => {
  return (
    <button className="SideButton">
        <Image className="Image"/>
        <Trans className="Text">{text}</Trans>
    </button>
  )
}

function SideOptions() {
  return (
    <div className="SideOptions" style={{marginBottom:10}}>
    </div>
  );
  /*
  return (
    <div className="SideOptions">
      <SideButton Image={Csv} text={'Télécharger les données'} />
      <SideButton Image={Image} text={"Télécharger l'image"} />
      <SideButton Image={Partager} text={'Partager'} />
    </div>
  );
  */
}


type SideBareProp = {
  children: JSX.Element,
  mode?: "full" | "detail",
  titre: string,
  handleBack?: (id?: string) => void,
  setRegion: (id: string) => void,
  setTerritoire: (id?: string) => void,
  setEpci: (id?: string) => void,
  modeRech:'regions' | 'territoire' | 'EPCI',
}
export default function SideBar({ 
  mode = "detail", children, titre, handleBack, setRegion, setTerritoire, modeRech, setEpci 
}: SideBareProp) {
  const { regionData } = useSelector((state: RootState) => state.filter)

  return (
    <div className="SideBar">
      <SideTopFiltres
        setRegion={setRegion}
        setTerritoire={setTerritoire}
        setEpci={setEpci}
        handleBack={handleBack}
        titre={titre}
        mode={mode}
        modeRech={modeRech}
      />
      {regionData ? (
        mode === "full" ? children :
          <>
            <div className={`sideSeparator`} />
            {children}
          </>
      ) : (
        <Loader />
      )}
      <SideOptions />
    </div>
  );
}
