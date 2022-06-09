/**
 * Navigation sur la vue pays uniquemennt
 */
import React from "react";
import { Link } from "react-router-dom";
import { Trans } from 'react-i18next';
import './NavigationMap.scss'

const Region = ({ mode }: { mode: 'regions' | 'territoire' | 'EPCI' }) => {
  if (mode === "regions") {
    return (
        <button><Trans>Régions</Trans></button>
    )
  }
  return (
    <Link to={`/`} className={"Link"}>
      <button><Trans>Régions</Trans></button>
    </Link>
  )
}

const Territoire = ({ mode }: { mode: 'regions' | 'territoire' | 'EPCI' }) => {
  if (mode === "territoire") {
    return (
      <button><Trans>Territoires d'industrie</Trans></button>
    )
  }
  return (
    <Link to={`/territoire`} className={"Link"}>
      <button><Trans>Territoires d'industrie</Trans></button>
    </Link>
  )
}

const Epci = ({ mode }: { mode: 'regions' | 'territoire' | 'EPCI' }) => {
  if (mode === "EPCI") {
    return (
      <button><Trans>EPCI</Trans></button>
    )
  }
  return (
    <Link to={`/EPCI`} className={"Link"}>
      <button><Trans>EPCI</Trans></button>
    </Link>
  )
}

const NavigationMap = ({ mode = "regions" }: {mode : 'regions' | 'territoire' | 'EPCI'}) => {
  return (
    <div className="NavigationMap">
      <Region mode={mode} />
      <Territoire mode={mode} />
      <Epci mode={mode} />
    </div>
  );
}

export default NavigationMap;
