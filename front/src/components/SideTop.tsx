/**
 * Gestion des listes des top produits, entreprises, etc...
 */
import React, { useState } from "react";
import ReactTooltip from "react-tooltip";
import { needAbbr, needAbbrType } from "../Utils";
import { listeSecteurs, listeDomaines } from "../maps/mapsConfig";
import InfoIcon from "@material-ui/icons/Info";
import { useTranslation } from 'react-i18next';
import Loader from "./loader";
import { Madetype, RcaType } from "../api/Produits";
import { MetiersRepresentativeWorkType } from "../api/Metiers";
import './SideTop.scss';
import { useSelector } from "react-redux";
import { RootState } from "../redux/store";

type TopMenuType = {
  currentMenu: number,
  menu: number,
  setMenu: React.Dispatch<React.SetStateAction<number>>,
  titre: string
  withIcon?: boolean
}
export const TopMenu = ({ currentMenu, menu, setMenu, titre, withIcon = true }: TopMenuType) => {
  return (
    <div onClick={() => setMenu(currentMenu)} className={`TopMenu ${menu === currentMenu ? "Show" : "Hide"}`}>
      <span>{titre}</span>
      {withIcon && <InfoIcon className={"InfoIcon"} />}
    </div>
  );
};

type TopItemType = {
  id: number,
  code?: string,
  tooltipProxy: needAbbrType,
  handleClick: { (id?: string): void },
  color: string,
}
export const TopItem = ({
  id,
  code,
  tooltipProxy,
  handleClick,
  color,
}: TopItemType) => {
  return (
    <div
      className={"TopItem"}
      onClick={() => handleClick(id.toString())}
      data-tip={tooltipProxy.tooltipText}
      data-for={`topProduitsTooltip`}
    >
      <svg viewBox="0 0 120 120" className={"Svg"} >
        <circle fill={color} cx="60" cy="60" r="50" />
      </svg>
      <div className="Text">
        <span className="Display">{tooltipProxy.displayText}</span>
        <span className="Code">{code}</span>
      </div>
    </div>
  );
};

const DisplayBiom = () => {
  const { t } = useTranslation();
  const { parity, biom: avgBiom } = useSelector((state: RootState) => state.establishment) ;
  if (!avgBiom || avgBiom.nbr === 0) {
    if (!parity || parity === 0) {
      return (
        <div className='Nothing'>
          <span>{t('non renseigné')}</span>
        </div>
      )
    }
    return (
      <>
        <div className="Biom">{t('Egalité Femme/Homme: {{pcent}}', { pcent: Math.round(parity*100)/100 })}</div>
        <div className="Biom Copyright2">
          {t('Source : ')}
          <a href="https://index-egapro.travail.gouv.fr/">https://index-egapro.travail.gouv.fr/</a>
        </div>
      </>
    )
  }

  function pcent(p: number | null): string {
    if (!p) return 'N.R.'
    return (Math.round(p * 100).toString() + '%')
  }
  return (
    <>
      <div className="Biom First">{t(`Nombre de formulaire: {{count}}`, { count: avgBiom.nbr })}</div>
      <div className="Biom">{t(`Empreinte sociale: {{biom}}`, { biom: pcent(avgBiom.biom) })}</div>
      <div className="Biom">{t('Entreprise intergénérationnelle: {{pcent}}', { pcent: pcent(avgBiom.C1) })}</div>
      <div className="Biom">{t('Travailleurs en situation de handicap: {{pcent}}', { pcent: pcent(avgBiom.C2) })}</div>
      <div className="Biom">{t('Accessibilité à la formation: {{pcent}}', { pcent: pcent(avgBiom.C3) })}</div>
      {avgBiom.C4 ?
        <div className="Biom">{t('Egalité Femme/Homme: {{pcent}} pt', { pcent: Math.round(avgBiom.C4) })}</div> :
        <div className="Biom">{t('Egalité Femme/Homme: N.R.')}</div>
      }
      {avgBiom.C5 ?
        <div className="Biom">{t('Dons, sponsoring, mécénat: {{pcent}}€/employé', { pcent: Math.round(avgBiom.C5) })}</div> :
        <div className="Biom">{t('Dons, sponsoring, mécénat: N.R.')}</div>
      }
      <div className="Biom">{t('Achats en local: {{pcent}}', { pcent: pcent(avgBiom.C6) })}</div>
      <div className="Biom">{t('Energie verte: {{pcent}}', { pcent: pcent(avgBiom.C8) })}</div>
      <div className="Biom Copyright">{t('Source : Copyright BIOM Attitudes ©')}</div>
      { parity ? 
          <div className = "SecondList">
            <div className="Biom">{t('Egalité Femme/Homme: {{pcent}}', { pcent: Math.round(parity*100)/100 })}</div>
            <div className="Biom Copyright2">
              {t('Source : ')}
              <a href="https://index-egapro.travail.gouv.fr/">https://index-egapro.travail.gouv.fr/</a>
            </div>
          </div>
        : null
        }      
    </>
  )
}

type SideTopProduitType = {
  topProduits?: [RcaType[], Madetype[]];
  setProduit: { (id?: string): void };
}
const SideTopProduit = ({ topProduits, setProduit }: SideTopProduitType) => {
  const [menuProduit, setMenuProduit] = useState(0);
  const { t } = useTranslation();

  const Menu0 = ({ topProduits }: { topProduits: [RcaType[], Madetype[]] }) => {
    if (topProduits[0].length === 0) {
      return (
        <div className={"Nothing"}>
          <span>...</span>
        </div>
      )
    }
    return (
      <>
        {topProduits[0].map((p: any) => {
          const { name, code_hs4, sector_id } = p;
          const color = listeSecteurs[sector_id].color;
          const tooltipProxy = needAbbr(name, 95);
          return (
            <TopItem
              key={code_hs4}
              id={code_hs4}
              code={code_hs4}
              color={color}
              tooltipProxy={tooltipProxy}
              handleClick={setProduit}
            />
          );
        })}
      </>
    )
  }

  const Menu1 = ({ topProduits }: { topProduits: [RcaType[], Madetype[]] }) => {
    if (topProduits[1].length === 0) {
      return (
        <div className={"Nothing"}>
          <span>...</span>
        </div>
      )
    }
    return (
      <>
        {topProduits[1].map((p: any) => {
          const { name, code_hs4, sector_id } = p;
          const color = listeSecteurs[sector_id].color;
          const tooltipProxy = needAbbr(name, 95);
          return (
            <TopItem
              key={code_hs4}
              id={code_hs4}
              code={code_hs4}
              color={color}
              tooltipProxy={tooltipProxy}
              handleClick={setProduit}
            />
          );
        })}
      </>
    )
  }

  return (
    <div className="SideTopProduit">
      <div className="Container">
        <div className="Menu">
          {[
            { id: 0, titre: t("Produits représentatifs") },
            { id: 1, titre: t("Produits fabriqués") },
          ].map((e) => {
            return (
              <TopMenu
                key={e.id}
                menu={menuProduit}
                setMenu={setMenuProduit}
                currentMenu={e.id}
                titre={e.titre}
              />
            );
          })}
        </div>
        {topProduits ? (
          <div className={"List"}>
            <ReactTooltip
              place="left"
              type="dark"
              effect="solid"
              className={"sideTopTooltip sideProximityTooltip"}
              id={`topProduitsTooltip`}
            />
            {menuProduit === 0 ? <Menu0 topProduits={topProduits} /> : <Menu1 topProduits={topProduits} />}
          </div>
        ) : (
          <div className={"Loader"}>
            <Loader width={40} height={40} />
          </div>
        )}
      </div>
    </div>
  )
}

type SideTopEtablishmentType = {
  setEtablissement: { (id?: string): void };
}
const SideTopEtablishment = ({ setEtablissement }: SideTopEtablishmentType) => {
  const [menuEtablissement, setMenuEtablissement] = useState(0);
  const { t } = useTranslation();
  const { employer } = useSelector((state: RootState) => state.establishment) ;  

  const MenuMainEmployers = () => {
    if (employer.length === 0) {
      return (
        <div className={"Nothing"}>
          <span>...</span>
        </div>

      )
    }
    return (
      <>
        {employer.map((p) => {
          const { id, usual_name, siret, sector_id } = p;
          const color = listeSecteurs[sector_id].color;
          const tooltipProxy = needAbbr(
            usual_name ? usual_name : siret,
            95
          );
          return (
            <TopItem
              key={id}
              id={id}
              code={undefined}
              color={color}
              tooltipProxy={tooltipProxy}
              handleClick={setEtablissement}
            />
          );
        })}
      </>
    )

  }
  return (
    <div className="SideTopEtablishment">
      <div className="Container">
        <div className="Menu">
          {[
            { id: 0, titre: t("Employeurs principaux") },
            { id: 1, titre: t("Indicateurs RSE") },
          ].map((e) => {
            return (
              <TopMenu
                key={e.id}
                menu={menuEtablissement}
                setMenu={setMenuEtablissement}
                currentMenu={e.id}
                titre={e.titre}
              />
            );
          })}
        </div>
        <div className={"List"}>
          <ReactTooltip
            place="left"
            type="dark"
            effect="solid"
            className={"sideTopTooltip sideProximityTooltip"}
            id={"topProduitsTooltip"}
          />
          {menuEtablissement === 1 ? <DisplayBiom /> : <MenuMainEmployers />}
        </div>
      </div>
    </div>

  )
}

type SideTopMetierType = {
  topMetiers?: MetiersRepresentativeWorkType[];
  setMetier: { (id?: string): void };
}
const SideTopMetier = ({ topMetiers, setMetier }: SideTopMetierType) => {
  const [menuMetier, setMenuMetier] = useState(0);
  const { t } = useTranslation();

  return (
    <div className="SideTopMetier">
      <div className="Container">
        <div className="Menu" >
          {[{ id: 0, titre: t("Métiers représentatifs") }].map((e) => {
            return (
              <TopMenu
                key={e.id}
                menu={menuMetier}
                setMenu={setMenuMetier}
                currentMenu={e.id}
                titre={e.titre}
              />
            );
          })}
        </div>
        {topMetiers ? (
          <div className={"List"}>
            <ReactTooltip
              place="left"
              type="dark"
              effect="solid"
              className={"sideTopTooltip sideProximityTooltip"}
              id={"topProduitsTooltip"}
            />
            {topMetiers.length > 0 ? (
              topMetiers.map((p: any) => {
                const { longlabel, code } = p;
                const domaine = code.substr(0, 1);
                const color = listeDomaines[domaine].color;
                const tooltipProxy = needAbbr(longlabel, 95);
                return (
                  <TopItem
                    key={code}
                    id={code}
                    code={code}
                    color={color}
                    tooltipProxy={tooltipProxy}
                    handleClick={setMetier}
                  />
                );
              })
            ) : (
              <div className={"Nothing"}>
                <span>...</span>
              </div>
            )}
          </div>
        ) : (
          <div className={"Loader"}>
            <Loader width={40} height={40} />
          </div>
        )}
      </div>
    </div>
  )
}

type SideTopType = {
  navigation: 'produit' | "produits" | "etablissement" | "etablissements" | "metiers",
  topProduits?: [RcaType[], Madetype[]],
  setProduit: { (id?: string): void },
  topMetiers?: MetiersRepresentativeWorkType[],
  setMetier: { (id?: string): void },
  setEtablissement: { (id?: string): void },
}
export default function SideTop({
  navigation,
  topProduits,
  setProduit,
  topMetiers,
  setMetier,
  setEtablissement,
}: SideTopType) {

  if (navigation === 'produit' || navigation === 'produits') {
    return <SideTopProduit setProduit={setProduit} topProduits={topProduits} />
  }

  if (navigation === 'etablissement' || navigation === 'etablissements') {
    return <SideTopEtablishment 
      setEtablissement={setEtablissement} 
    />
  }

  return <SideTopMetier setMetier={setMetier} topMetiers={topMetiers} />;
}
