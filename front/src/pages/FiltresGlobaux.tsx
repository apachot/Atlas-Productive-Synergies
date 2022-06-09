import React from "react";
import { useHistory } from "react-router-dom";
import {
  listeEffectifs,
  listeSecteurs,
  listeDomaines,
} from "../maps/mapsConfig";
import { difference, intersection, map } from "lodash-es";
import { useTranslation } from 'react-i18next';
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { setDomains, setEffectifs, setSecteurs } from "../redux/filterSlice";
import { isMobileOnly } from "react-device-detect";
import useScreenOrientation from "../Utility/screenOrientation";

import './FiltresGlobaux.scss';

const Item = ({
  name,
  handleClick,
  children,
  key,
}: {
  name: string,
  handleClick: () => void,
  children: JSX.Element,
  key: any
}) => {
  return (
    <div
      key={key}
      className={"Data"}
      onClick={handleClick}
    >
      {children}
      <p className={"Text"}>{name}</p>
    </div>
  );
};

function FiltresPage() {
  const { t } = useTranslation();
  const dispatch = useDispatch();
  const { secteurs, effectifs, domaines } = useSelector((state: RootState) => state.filter);
  const history = useHistory();
  const orientation = useScreenOrientation() ;
  return (
    <div className={`FiltresGlobaux ${orientation} ${isMobileOnly && "MobileOnly"}`}>
      <div className="Header">
        <h2 className="Text">
          {t("Filtrer les résultats")}
        </h2>
        <button className="Button"
          onClick={() => { history.goBack(); }}
        >
          {t("Appliquer et fermer")}
        </button>
      </div>
      <div className="Filters">
        <div className="Activity">
          <div className={"Title"}>{t("Secteurs d'activités des entreprises")}</div>
          <div className={"Datas"}>
            {map(listeSecteurs, (macroSecteur) => {
              const { code, color, name, Logo } = macroSecteur;
              const isActive = intersection([code], secteurs).length > 0;
              const activeColor = isActive ? color : "#f3f3f4";
              const activeClass = isActive ? "active" : "inactive";
              return (
                <Item
                  key={code}
                  name={t(name)}
                  handleClick={() => {
                    if (intersection([code], secteurs).length > 0) {
                      dispatch(setSecteurs(difference(secteurs, [code])));
                    } else {
                      dispatch(setSecteurs(secteurs.concat(code)));
                    }
                  }}
                >
                  <Logo
                    data-filtre={`secteur-${code}`}
                    style={{
                      color: activeColor,
                      backgroundColor: activeColor,
                      borderColor: color,
                    }}
                    className={`Logo ${activeClass}`}
                  />
                </Item>
              );
            })}
          </div>
        </div>
        <hr className={"Separator"} />
        <div className="Jobs">
          <div className={"Title"}>{t("Domaines professionels des métiers")}</div>
          <div className={"Datas"}>
            {map(listeDomaines, (domaine) => {
              const { code, color, name, Logo } = domaine;
              const isActive = intersection([code], domaines).length > 0;
              const activeColor = isActive ? color : "#f3f3f4";
              const activeClass = isActive ? "active" : "inactive";

              return (
                <Item
                  key={code}
                  name={t(name)}
                  handleClick={() => {
                    if (intersection([code], domaines).length > 0) {
                      dispatch(setDomains(difference(domaines, [code])));
                    } else {
                      dispatch(setDomains(domaines.concat(code)));
                    }
                  }}
                >
                  <Logo
                    data-filtre={`secteur-${code}`}
                    style={{
                      color: activeColor,
                      backgroundColor: activeColor,
                      borderColor: color,
                    }}
                    className={`Logo ${activeClass}`}
                  />
                </Item>
              );
            })}
          </div>
        </div>
        <hr className={"Separator"} />
        <div className="Employees">
          <div className={"Title"}>{t("Nombre d'employés")}</div>
          <div className={"Datas"}>
            {map(listeEffectifs, (e) => {
              const { code, name } = e;
              const isActive = intersection([code], effectifs).length > 0;
              const activeClass = isActive ? "active" : "inactive";
              const bgColor = intersection([code], effectifs).length > 0 ? "Selected" : "UnSelected";
              return (
                <div
                  key={code}
                  data-filtre={`effectif-${code}`}
                  className={`Data ${bgColor} ${activeClass}`}
                  onClick={() => {
                    if (intersection([code], effectifs).length > 0) {
                      dispatch(setEffectifs(difference(effectifs, [code])));
                    } else {
                      dispatch(setEffectifs(effectifs.concat(code)));
                    }
                  }}
                >
                  {t(name)}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}

export default FiltresPage;
