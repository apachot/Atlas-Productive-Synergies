/**
 * Panneau latéral sur les métiers, affichage des infos pole emploi
 */
import React, { useState } from "react";
import { ReactComponent as Recommandations } from "../svgs/recommandation.svg";
import { listeDomaines } from "../maps/mapsConfig";
import { Trans, getI18n, useTranslation } from 'react-i18next';
import { useSelector } from "react-redux";
import { RootState } from "../redux/store";
import Loader from "./loader";
import { jobPosition } from "./space/spaceData";
import './SideInfosMetier.scss';
import { TopItem, TopMenu } from "./SideTop";

function cleanStr(str?: string) {
  if (str === undefined) {
    return "";
  }
  return str.split("\\n").join("\n");
}

function Description({ metier }: { metier: any }) {
  return (
    <div className={"Description"}>
      {[
        {k:1, title:"Définition", value:metier.info.definition},
        {k:2, title:"Accès", value:metier.info.acces},
        {k:3, title:"Condition", value:metier.info.condition},
      ].map( e => (
        <div key={e.k}>
          <span><Trans>{e.title}</Trans> : </span>
          <span>{cleanStr(e.value)}</span>
        </div>
        )
      )}
    </div>
  );
}
function Proximite({ metier, setMetier }: { metier: any, setMetier: { (id?: string): void } }) {
  return (
    <>
      {metier.link.length > 0 ? (
        metier.link.map((m: any) => {
          const { code, longLabel } = m;
          const domaine = code.substr(0, 1);
          const color = listeDomaines[domaine].color;
          return (
            <TopItem key={code} color={color} handleClick={setMetier} id={code} tooltipProxy={{displayText:longLabel, needAbbr:false, tooltipText:longLabel}} />
          );
        })
      ) : (
        <div className={"mb-2 flex align-center"}>
          <span><Trans>Aucune</Trans></span>
        </div>
      )}
    </>
  );
}

export default function SideInfosMetier({
  metier,
  setMetier,
}:
  {
    metier: any,
    setMetier: { (id?: string): void },
  }) {
  const { metierId } = useSelector((state: RootState) => state.filter);;
  const metierWoQuery = jobPosition.nodes.find(e => e.id === (metierId ?? ""))!

  // const { id, shortLabel } = metierWoQuery;
  const { t } = useTranslation();
  const domaine = t(metierWoQuery.secteurName);
  const [menu, setMenu] = useState<number>(0);

  return (
    <div className="SideInfosMetier">
      <div className="Container" >
        <div className="Head">
          <div className="Title">{metierWoQuery.libShort[getI18n().language]}</div>
          <div className={"Domain"}>{domaine}</div>
          <div className={"Code"}>
            {metierId}
          </div>
        </div>

        <div className="Menu">
        {[
            { id: 0, titre: t("Description métier") },
            { id: 1, titre: t("Evolution métier") },
          ].map((e) => {
            return (
              <TopMenu
                key={e.id}
                menu={menu}
                setMenu={setMenu}
                currentMenu={e.id}
                titre={e.titre}
                withIcon={false}
              />
            );
          })}
        </div>

          {!metier ? (
            <div className={"Loader"}>
              <Loader />
            </div>
          ) : (
            <div className={"List"}>
              {menu===0 ? <Description metier={metier} /> : <Proximite metier={metier} setMetier={setMetier} />}
            </div>
          )}
        <button className="Button">
          <Recommandations className="Recommandations" />
          <Trans>Voir les formations</Trans>
        </button>
      </div>
    </div>
  );
}
