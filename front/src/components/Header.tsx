/**
 * Bandeau haut de l'application
 */
import React from "react";
import { ReactComponent as LogoEn } from "../svgs/logos/logo-atlas-en.svg";
import { ReactComponent as LogoFr } from "../svgs/logos/logo-atlas-fr.svg";
import { Link } from "react-router-dom";
import { useTranslation, Trans, getI18n } from 'react-i18next';
import { useDispatch } from "react-redux";
import { reinitFilter } from "../redux/filterSlice";
import useScreenOrientation from "../Utility/screenOrientation";
import { isMobileOnly } from "react-device-detect";
import './Header.scss'

const changeLanguageHandler = (i18n: any, lang: string) => {
  localStorage.setItem("lang", lang);
  window.location.reload();
}

const TheLogo = () => {
  const dispatch = useDispatch();
  const Logo = getI18n().language === "en" ? LogoEn : LogoFr ;
  return (
    <div className="Logo">
      <Link className = "Link" to={`/`} onClick={() => { dispatch(reinitFilter()) }}>
        <Logo className = "LogoSVG"/>
      </Link>
      <span className={"Version"}>
        <Trans>Version bêta</Trans>
      </span>
    </div>
  )
}

const Title = () => {
  return (
    <div className="Title">
      <span className="Text">
        <Trans>Produire localement, développer l'économie circulaire et sécuriser
          les approvisionnements</Trans>
      </span>
    </div>
  )
}

const Button = () => {
  const { i18n } = useTranslation();
  return (
    <div className="Button">
      {i18n.language === 'en' ? (
        <button onClick={() => changeLanguageHandler(i18n, 'fr')}>
          <Trans>Fr</Trans>
        </button>
      ) : (
        <button onClick={() => changeLanguageHandler(i18n, 'en')}>
          <Trans>En</Trans>
        </button>
      )}
    </div>
  )
}

const Header = ({first=false}:{first?:boolean}) => {
  const orientation = useScreenOrientation()
  return (
    <header className={`Header ${isMobileOnly && "Mobile "+orientation} ${first && "first"}`}>
      <TheLogo />
      <Title />
      <Button />
    </header>
  );
}

export default Header;