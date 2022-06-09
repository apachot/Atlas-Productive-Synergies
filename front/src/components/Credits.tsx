import React from "react";
import { ReactComponent as Uca } from "../svgs/logos/UCA.svg";
import { ReactComponent as Os } from "../svgs/logos/OS.svg";
import { useTranslation } from 'react-i18next';
import './Credits.scss' ;

function Credits() {
  const { t } = useTranslation();
  return (
    <div className="Credits" >
      <div className="Images">
        <Uca className="Uca" />
        <Os className="Os" />
      </div>
      <div className={"Text"}>
        <p>{t("Confidentialité")}</p>
        <p>{t("Cookies")}</p>
        <p>{t("Accessibilité")}</p>
        <p>{t("ATLAS de Synergies Productive ©2022")}</p>
      </div>
    </div>
  );
}

export default Credits;
