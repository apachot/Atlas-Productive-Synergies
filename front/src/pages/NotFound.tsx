import React from "react";
import { Link } from "react-router-dom";
import { useTranslation } from 'react-i18next';

function NotFound() {
  const { t } = useTranslation();
  return (
    <div className="bg-blue-100 text-pink-800 inset-0 absolute w-full h-full text-center flex items-center justify-center">
      <div>
        <div className="text-5xl font-bold mt-8">404</div>
        <div className="text-xl font-bold mt-2">{t("Oups...")}</div>
        <div className="">
        {t("La page que vous recherchez")}<br />
        {t("est introuvable")}
        </div>

        <Link
          to="/"
          className="btn inline-block mt-12 text-black"
          style={{
            minWidth: "203px",
          }}
        >
          {t("Retour à l'Accueil")}
        </Link>
      </div>
    </div>
  );
}

export default NotFound;
