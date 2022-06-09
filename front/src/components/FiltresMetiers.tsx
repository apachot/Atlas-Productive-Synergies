/**
 * Filtre sur les domaines des métiers
 */
import React from "react";
import {
  listeDomaines,
  defaultVisibleDomaines,
  allDomaines,
} from "../maps/mapsConfig";
import { map, intersection, difference } from "lodash-es";
import ReactTooltip from "react-tooltip";
import { useTranslation } from 'react-i18next';
import { useDispatch } from "react-redux";
import { setDomains } from "../redux/filterSlice";
import './FiltresMetiers.scss';

function Filtres(props: {
  domaines: any,
  domainesFiltrable?: string[],
  readOnly?: boolean,
  isLoading: boolean,
}) {
  const {
    domaines,
    domainesFiltrable = defaultVisibleDomaines,
    readOnly = false,
    isLoading,
  } = props;
  const { t } = useTranslation();
  const dispatch = useDispatch()
  const setDomaines = (valeur: any) => {
    dispatch(setDomains(valeur))
  };
  const onClickToggleAllDomaines = () => {
    if (readOnly || isLoading) {
      return;
    }
    const result: string[] = [];
    if (
      (domaines.length > 0 && domaines.length < domainesFiltrable.length) ||
      domaines.length === 0
    ) {
      domainesFiltrable.map((secteur) => {
        return result.push(secteur);
      });
    }
    setDomaines(result);
  };

  return (
    <div className={"Filtres Jobs"}>
      <div className="Block">
        <div className="FilterHeader">
          <div className="Description">{t("Domaine professionnel des métiers")}</div>
          <div 
            className={`Selection ${isLoading && 'Wait'}`} 
            onClick={!isLoading ? onClickToggleAllDomaines : undefined}
          >
            {allDomaines.length === domaines.length
                ? t("Tout déselectionner")
                : t("Tout sélectionner")}
          </div>
        </div>
        <div className={"Icons"}>
          <ReactTooltip
            place="top"
            type="dark"
            effect="solid"
            className={"filtersTooltip"}
          />
          {map(listeDomaines, (macroDomaine) => {
            const { code, color, name, Logo } = macroDomaine;
            const isActive = intersection([code], domaines).length > 0;
            const isFiltrable =
              intersection([code], domainesFiltrable).length > 0;
            const activeColor = isActive ? color : "#f3f3f4";
            const activeClass = isActive ? "active" : "inactive";
            const disableClass = !isFiltrable ? "disabled" : "";
            const inactiveBorder = isFiltrable ? color : "";

            const cursorClass = isLoading ? "Wait" : (readOnly || !isFiltrable ? "NotAllowed" : "Standard");
            return (
              <Logo
                key={code}
                data-tip={t(name)}
                data-filtre={`secteur-${code}`}
                style={{
                  color: activeColor,
                  backgroundColor: activeColor,
                  borderColor: inactiveBorder,
                }}
                className={`Icon ${activeClass} ${cursorClass} ${disableClass} `}
                onClick={() => {
                  if (
                    !readOnly &&
                    !isLoading &&
                    domainesFiltrable.length === 0
                  ) {
                    if (intersection([code], domaines).length > 0) {
                      setDomaines(difference(domaines, [code]));
                    } else {
                      setDomaines(domaines.concat(code));
                    }
                  } else if (
                    !readOnly &&
                    !isLoading &&
                    domainesFiltrable.length > 0
                  ) {
                    if (isActive) {
                      if (intersection([code], domainesFiltrable).length > 0) {
                        setDomaines(difference(domaines, [code]));
                      } else {
                        setDomaines(domaines.concat(code));
                      }
                    } else if (isFiltrable) {
                      setDomaines(domaines.concat(code));
                    }
                  }
                }}
              />
            );
          })}
        </div>
      </div>
    </div>
  );
}
export default Filtres;
