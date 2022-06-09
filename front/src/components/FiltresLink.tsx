/**
 * Visuel et lien vers la page de filtres
 */
import React from "react";
import { Link } from "react-router-dom";
import { ReactComponent as FiltreIcon } from "../svgs/filtre.svg";
import { ReactComponent as HistoryIcon } from "../svgs/time.svg";
import './FiltresLink.scss' ;

const Filtre = ({ navigation }: {navigation: string}) => {
  return (
    <Link
      to={`/filtres/${navigation}`}
      className={`filtreButton `}
    >
      <div className={`filtre`}>
        <FiltreIcon className={"FiltreIcon"} />
      </div>
    </Link>
  )
}

const FiltresLink = ({ navigation }: {navigation?: string}) => {
  return (
    <div className={"FiltresLink"}>
      {navigation ? <Filtre navigation={navigation} /> : null}
      <div className={`yearButton `}>
        <div className={`image`}>
          <HistoryIcon className={"HistoryIcon"} />
        </div>
      </div>
      <div
        className={`year`}
      >
        2020
      </div>
    </div>
  );
};

export default FiltresLink;
