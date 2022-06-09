/**
 * Navigation sur les écrans hors vue pays
 */
import { ReactComponent as Produit } from "../svgs/produit.svg";
import { ReactComponent as Etablissement } from "../svgs/etablissement.svg";
import { ReactComponent as Metier } from "../svgs/metier.svg";
import { ReactComponent as Formation } from "../svgs/formation.svg";
import { ReactComponent as Individu } from "../svgs/individu.svg";
import React, { useState } from "react";
import { Link } from "react-router-dom";
import { Trans } from 'react-i18next';
import { useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { isMobileOnly } from "react-device-detect";
import useScreenOrientation from "../Utility/screenOrientation";
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import { useHistory } from "react-router";
import './Navigation.scss';


type NavButtonType = {
  children: JSX.Element,
  url: string,
  selected: boolean
  Icon: React.FunctionComponent<React.SVGProps<SVGSVGElement> & { title?: string | undefined; }>
}

const NavButton = ({ children, url, selected, Icon }: NavButtonType) => {
  return (
    <Link to={url} className={"Link"}>
      <div className={`Button ${selected ? "Select" : ""}`}>
        <div className={"Content"}>
          <Icon className={"Icon"} />
          <div className={"Text"}>
            {children}
          </div>
        </div>
      </div>
    </Link>
  )
}

type NavGeneralType = {
  url: string,
  selected: boolean,
  init: boolean,
  nb: number
  Icon: React.FunctionComponent<React.SVGProps<SVGSVGElement> & { title?: string | undefined; }>
  title: string
}

const NavGeneral = ({ url, selected, init, nb, Icon, title }: NavGeneralType) => {
  return (
    <NavButton url={url} selected={selected} Icon={Icon}>
      <>
        <p className={"Title"}><Trans>{title}</Trans></p>
        <p className={"Number"}>{init ? nb : "\u00A0"}</p>
      </>
    </NavButton>
  );
}

type MobileButtonType = {
  init: boolean,
  nb: number
  Icon: React.FunctionComponent<React.SVGProps<SVGSVGElement> & { title?: string | undefined; }>
  title: string,
}
const MobileButton = ({ init, nb, Icon, title }: MobileButtonType) => {
  return (
    <div className={"Content"}>
      <Icon className={"Icon"} />
      <div className={"Text"}>
        <p className={"Title"}><Trans>{title}</Trans></p>
        <p className={"Number"}>{init ? nb : "\u00A0"}</p>
      </div>
      <KeyboardArrowDownIcon className="DropDown" />
    </div>

  )
}

type NavigationType = {
  navigation: "etablissements" | "produits" | "metiers";
}
export default function Navigation({ navigation }: NavigationType) {
  const [openMenu, setOpenMenu] = useState<boolean>(false);
  const {
    regionId,
    territoireId,
    epciId,
    etablissementId,
    produitId,
  } = useSelector((state: RootState) => state.filter);

  const { nbProduit,
    nbEtablissement,
    nbMetier,
    nbFormation,
    nbIndividu,
    countInit
  } = useSelector(
    (state: RootState) => state.count
  );

  const orientation = useScreenOrientation();
  const history = useHistory() ;

  const zone = epciId ? `EPCI${regionId}-${epciId}` : territoireId ? territoireId : regionId;
  //Logique de navigation
  let urlProduit,
    urlEtablissement,
    urlMetier = "";
  urlMetier = `/metiers/${zone}`;

  urlProduit = `/produits/${zone}`;

  if (etablissementId) {
    urlEtablissement = `/etablissement/${zone}/${etablissementId}`;
    urlProduit += "?etb=" + etablissementId;
    urlMetier += "?etb=" + etablissementId;

    if (produitId) {
      urlEtablissement += "?pdt=" + produitId;
    }
  } else {
    urlEtablissement = `/etablissements/${zone}`;

    if (produitId) {
      urlEtablissement += "/produit/" + produitId;
    }
  }

  if (isMobileOnly) {
    const bt = [
      { 
        But: <MobileButton Icon={Produit} init={countInit} nb={nbProduit} title={"Produits"} />, 
        sel: navigation === "produits", 
        url: urlProduit,
      },
      { 
        But: <MobileButton Icon={Etablissement} init={countInit} nb={nbEtablissement} title={"Etablissements"} />, 
        sel: navigation === "etablissements",
        url: urlEtablissement,
      },
      { 
        But: <MobileButton Icon={Metier} init={countInit} nb={nbMetier} title={"Métiers"} />, 
        sel: navigation === "metiers",
        url: urlMetier,
      },
      { 
        But: <MobileButton Icon={Formation} init={countInit} nb={nbFormation} title={"Formations"} />, 
        sel: false,
      },
      { 
        But: <MobileButton Icon={Individu} init={countInit} nb={nbIndividu} title={"Individus"} />, 
        sel: false 
      },
    ]
    return (
      <div className={`Navigation MobileOnly ${orientation}`}>
        <button className={"MenuButton"} onClick={(e) => setOpenMenu(!openMenu)}>
          {bt.find(b => b.sel)?.But}
        </button>
        {openMenu &&
          <div className={"ListItemMenu"} >
            {bt.filter(b => !b.sel).map((b, index) => (
              <button 
                key={index} 
                className={"MenuButton"}
                onClick={e => {
                  setOpenMenu(false);
                  b.url && history.push(b.url);
                }}
              >
                {b.But}
              </button>
            ))}
          </div>
        }
      </div>
    )
  }


  return (
    <div className="Navigation">
      <NavGeneral url={urlEtablissement} selected={navigation === "etablissements"} init={countInit} nb={nbEtablissement} Icon={Etablissement} title="Etablissements" />
      <NavGeneral url={urlProduit} selected={navigation === "produits"} init={countInit} nb={nbProduit} Icon={Produit} title='Produits' />
      <NavGeneral url={urlMetier} selected={navigation === "metiers"} init={countInit} nb={nbMetier} Icon={Metier} title="Métiers" />
      <NavGeneral url={'#'} selected={false} init={false} nb={nbFormation} Icon={Formation} title="Formations" />
      <NavGeneral url={'#'} selected={false} init={false} nb={nbIndividu} Icon={Individu} title="Individus" />
    </div>
  );
}
