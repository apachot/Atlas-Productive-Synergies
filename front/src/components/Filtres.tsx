/**
 * Filtres des macro secteurs et effectifs
 */
import React from "react";
import {
  listeSecteurs,
  listeEffectifs,
  allWorkforces,
  allSecteurs,
} from "../maps/mapsConfig";
import { map, intersection, difference } from "lodash-es";
import ReactTooltip from "react-tooltip";
import { useTranslation } from 'react-i18next';
import { useDispatch } from "react-redux";
import { setEffectifs as filterSetEffectifs, setSecteurs as filterSetSecteurs } from "../redux/filterSlice";
import './Filtres.scss';


type BusinessSectorType = {
  secteurs: number[]
  readOnly: boolean,
  secteursFiltrable: number[],
  mode: "local" | "standard",
  isLoading: boolean,
  setSecteurs: (value: number[]) => void,
}
const BusinessSector = ({
  isLoading,
  readOnly,
  secteurs,
  secteursFiltrable,
  mode,
  setSecteurs
}: BusinessSectorType) => {
  const dispatch = useDispatch();
  const { t } = useTranslation();

  const setLocalSecteurs = (valeur: number[]) => {
    if (mode === "local") {
      setSecteurs(valeur);
    } else {
      dispatch(filterSetSecteurs(valeur))
    }
  };

  const onClickToggleAllSecteurs = () => {
    if (readOnly || isLoading) {
      return;
    }
    const result: number[] = [];
    if (
      (secteurs.length > 0 && secteurs.length < secteursFiltrable.length) ||
      secteurs.length === 0
    ) {
      secteursFiltrable.map((secteur) => {
        return result.push(secteur);
      });
    }
    setLocalSecteurs(result);
  };

  const onClickIcon = (code:number, isActive: boolean, isFiltrable:boolean) => {
    if (
      !readOnly &&
      !isLoading &&
      secteursFiltrable.length === 0
    ) {
      if (intersection([code], secteurs).length > 0) {
        setLocalSecteurs(difference(secteurs, [code]));
      } else {
        setLocalSecteurs(secteurs.concat(code));
      }
    } else if (
      !readOnly &&
      !isLoading &&
      secteursFiltrable.length > 0
    ) {
      if (isActive) {
        if (intersection([code], secteursFiltrable).length > 0) {
          setLocalSecteurs(difference(secteurs, [code]));
        } else {
          setLocalSecteurs(secteurs.concat(code));
        }
      } else if (isFiltrable) {
        setLocalSecteurs(secteurs.concat(code));
      }
    }
  }
  return (
    <div className={"BusinessSector"}>
      <p className={"Title"}>
        {t("Secteur d'activité des entreprises")}
        <span
          className={`Selector ${isLoading ? "Wait" : "Standard"}`}
          onClick={isLoading ? undefined : onClickToggleAllSecteurs}
        >
          {secteurs && allSecteurs.length === secteurs.length
            ? t("Tout déselectionner")
            : t("Tout sélectionner")}
        </span>
      </p>
      <div className={"Icons"}>
        <ReactTooltip
          place="top"
          type="dark"
          effect="solid"
          className={"Tooltip"}
        />
        {map(listeSecteurs, (macroSecteur) => {
          const { code, color,  Logo } = macroSecteur;
          const isActive = intersection([code], secteurs).length > 0;
          const isFiltrable =
            intersection([code], secteursFiltrable).length > 0;
          const activeColor = isActive ? color : "#f3f3f4";
          const disableClass = !isFiltrable ? "disabled" : "";
          const inactiveBorder = isFiltrable ? color : "";
          const cursorClass = isLoading ? "Wait" : (readOnly || !isFiltrable ? "notAllowed" : "standard");
          return (
            <div className="Icon" key={code}>
              <Logo
                style={{
                  color: activeColor,
                  backgroundColor: activeColor,
                  borderColor: inactiveBorder,
                }}
                className={`Logo ${cursorClass} ${disableClass}`}
                onClick={() => {onClickIcon(code, isActive, isFiltrable) }}
              />
            </div>
          );
        })}
      </div>
    </div>
  )
}

type EtablishmentSliceType = {
  isLoading: boolean,
  mode: "local" | "standard",
  setEffectifs: (value: number[]) => void,
  setInitMap: (value: boolean) => void,
  readOnly: boolean,
  effectifs: number[],
  effectifsFiltrable: number[],
}
const EtablishmentSlice = ({
  isLoading,
  mode,
  setEffectifs,
  setInitMap,
  readOnly,
  effectifs,
  effectifsFiltrable,
}: EtablishmentSliceType) => {
  const { t } = useTranslation();
  const dispatch = useDispatch();
  const setLocalEffectifs = (valeur: number[]) => {
    if (mode === "local") {
      setEffectifs(valeur);
    } else {
      setInitMap(false);
      dispatch(filterSetEffectifs(valeur));
    }
  };

  const onClickToggleAllEffectifs = () => {
    if (readOnly || isLoading) {
      return;
    }
    const result: any[] = [];
    if (
      (effectifs.length > 0 && effectifs.length < effectifsFiltrable.length) ||
      effectifs.length === 0
    ) {
      effectifsFiltrable.map((effectif: any) => {
        return result.push(effectif);
      });
    }
    setLocalEffectifs(result);
  };

  const onClickIcon = (code: number, isActive:boolean, isDisable:boolean) => {
    if (
      !readOnly &&
      !isLoading &&
      effectifsFiltrable.length === 0
    ) {
      if (intersection([code], effectifs).length > 0) {
        setLocalEffectifs(difference(effectifs, [code]));
      } else {
        setLocalEffectifs(effectifs.concat(code));
      }
    } else if (
      !readOnly &&
      !isLoading &&
      effectifsFiltrable.length > 0
    ) {
      if (isActive) {
        if (intersection([code], effectifsFiltrable).length > 0) {
          setLocalEffectifs(difference(effectifs, [code]));
        } else {
          setLocalEffectifs(effectifs.concat(code));
        }
      } else if (isDisable) {
        setLocalEffectifs(effectifs.concat(code));
      }
    }
  }

  return (
    <div className={"EtablishmentSlice"}>
      <p className={"Title"}>
        {t("Nombre d'employés")}
        <span 
          className={`Selector ${isLoading ? "Wait" : "Standard"}`}
          onClick={isLoading ? undefined : onClickToggleAllEffectifs}
        >
          {effectifs && allWorkforces && allWorkforces.length === effectifs.length
            ? t("Tout déselectionner")
            : t("Tout sélectionner")}
        </span>
      </p>
      <div className={"Icons"}>
        {map(listeEffectifs, (e) => {
          const { code, name } = e;
          const isActive = intersection([code], effectifs).length > 0;
          const isFiltrable =
            intersection([code], effectifsFiltrable).length > 0;
          const isDisable =
            !isActive && intersection([code], effectifsFiltrable).length > 0;
          const disableClass = !isFiltrable ? "disabled" : "enabled";
          const cursorClass = isLoading ? "Wait" : (readOnly || !isFiltrable ? "notAllowed" : "standard");
          const bgColor = intersection([code], effectifs).length > 0 ? "Sel" : "Unsel";
          return (
            <div
              key={code}
              className={`Icon ${bgColor} ${cursorClass} ${disableClass}`}
              onClick={() => {onClickIcon(code, isActive, isDisable) }}
            >
              {t(name)}
            </div>
          );
        })}
      </div>
    </div>

  )
}

type FiltresType = {
  secteurs: number[]
  effectifs: number[],
  readOnly?: boolean,
  secteursFiltrable?: number[],
  effectifsFiltrable?: number[],
  mode?: "local" | "standard",
  isLoading: boolean,
  setInitMap?: (value: boolean) => void,
  setEffectifs?: (value: number[]) => void,
  setSecteurs?: (value: number[]) => void,
}

function Filtres(props: FiltresType) {
  const {
    secteurs,
    effectifs,
    readOnly = false,
    secteursFiltrable = allSecteurs,
    effectifsFiltrable = allWorkforces,
    mode = "standard",
    isLoading,
    setInitMap = () => { },
    setEffectifs = () => { },
    setSecteurs = () => { },
  } = props;

  return (
    <div className={"Filtres"}>
      <BusinessSector
        isLoading={isLoading}
        secteurs={secteurs}
        secteursFiltrable={secteursFiltrable}
        mode={mode}
        readOnly={readOnly}
        setSecteurs={setSecteurs}
      />
      <div
        className={"Separator"}
      />
      <EtablishmentSlice
        effectifs={effectifs}
        effectifsFiltrable={effectifsFiltrable}
        isLoading={isLoading}
        setEffectifs={setEffectifs}
        setInitMap={setInitMap}
        mode={mode}
        readOnly={readOnly}
      />
    </div>
  );
}
export default Filtres;
