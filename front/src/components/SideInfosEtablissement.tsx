/**
 * Affichage des infos de l'établissement à partir de l'API Google Maps
 */
import { listeEffectifs, listeSecteurs } from "../maps/mapsConfig";
import React, { useEffect, useState } from "react";
import ArrowDropDownIcon from "@material-ui/icons/ArrowDropDown";
import { Dropdown } from "react-bootstrap";
import ReactTooltip from "react-tooltip";
import { needAbbr } from "../Utils";
import { Trans, useTranslation } from 'react-i18next';
import { EtablissementLongType } from "../api/Etablissements";
import './SideInfosEtablissement.scss';
import { TopItem } from "./SideTop";

const today = new Date();
const dayOfTheweek = today.getDay() === 0 ? 6 : today.getDay() - 1;


type TopMenuType = {
  currentMenu: number,
  menu: number,
  setMenu: React.Dispatch<React.SetStateAction<number>>,
  titre: string
}
const TopMenu = ({ currentMenu, menu, setMenu, titre }: TopMenuType) => {
  return (
    <div onClick={() => setMenu(currentMenu)} className={`TopMenu ${menu === currentMenu ? "Show" : "Hide"}`}>
      <span>{titre}</span>
    </div>
  );
};

function SideInfosEtablissement({ etablissement, sideHeight, setProduit }:
  { etablissement: EtablissementLongType, sideHeight: number, setProduit: { (id?: string): void } }) {
  let map = React.useRef<any>();
  const [imageUrl, setImageUrl] = useState<any>();
  const [telephone, setTelephone] = useState<string>();
  const [ouvertures, setOuvertures] = useState<any>();
  const [ouvert, setOuvert] = useState<any>();
  const [website, setWebsite] = useState<any>();
  const [adresse, setAdresse] = useState<any>();
  const mapRef = React.useRef<any>();
  const { t } = useTranslation();
  const [menu, setMenu] = useState(0);


  useEffect(() => {
    const center = {
      lat: parseFloat(etablissement.coordinates[0] as any),
      lng: parseFloat(etablissement.coordinates[1] as any),
    };

    const setDetailData = (place: any) => {
      if (place.photos !== undefined) {
        setImageUrl(place.photos[0]?.getUrl({ maxWidth: 200, maxHeight: 200 }));
      }
      if (place.formatted_phone_number) {
        setTelephone(place.formatted_phone_number);
      }
      if (place.formatted_address) {
        setAdresse(place.formatted_address);
      }
      if (place.opening_hours) {
        setOuvertures(place.opening_hours);
        if (place.utc_offset_minutes) {
          setOuvert(place.opening_hours.isOpen());
        }
      }
      if (place.website) {
        setWebsite(website);
      }
    }

    if (
      (window as any).google !== undefined &&
      process.env.REACT_APP_USE_GOOGLE_API === "true" &&
      mapRef.current
    ) {
      map.current = new (window as any).google.maps.Map(mapRef.current, {
        center: center,
        zoom: 8,
        mapTypeControl: false,
        streetViewControl: false,
      });
      const request = {
        query: etablissement.usual_name + " " + etablissement.zip,
        locationBias: { radius: 1, center: center },
        fields: ["place_id", "name", "geometry"],
      };

      const service = new (window as any).google.maps.places.PlacesService(map);

      service.findPlaceFromQuery(request, function (results: any, status: any) {
        if (status === (window as any).google.maps.places.PlacesServiceStatus.OK) {
          for (let i = 0; i < results.length; i++) {
            //Log pour valider les résultats en cas de soucis en prod
            new (window as any).google.maps.Marker({
              position: results[i].geometry.location,
              map,
            });
          }

          map.current.setCenter(results[0].geometry.location);
          if (results.length > 0) {
            const detailRequest = {
              placeId: results[0].place_id,
              fields: [
                "name",
                "rating",
                "formatted_phone_number",
                "formatted_address",
                "geometry",
                "opening_hours",
                "photos",
                "utc_offset_minutes",
              ],
            };
            service.getDetails(detailRequest, setDetailData);
          }
        } else {
          console.warn("FindPlace status:" + status);
        }
      });
    }
  }, [etablissement.usual_name, etablissement.zip, etablissement.coordinates, website]);

  function getEffectifName(): string {
    let valeurEffectif = "...";

    const wfg = [];

    for (const key in listeEffectifs) {
      if (listeEffectifs.hasOwnProperty(key)) {
        const effectif = listeEffectifs[key];
        wfg.push(effectif);
      }
    }

    wfg.forEach((wf) => {
      const wfg = wf.workforceCodes.split(",");
      if (wfg.includes(etablissement.workforce_group)) {
        valeurEffectif = t(wf.name);
      }
    });

    return valeurEffectif + " employés";
  }

  const InfoBiom = () => {
    function pcent(p: number | null): string {
      if (!p) return 'N.R.'
      return (Math.round(p * 100).toString() + '%')
    }

    function notEquality () {
      if ((!parity || (!parity.avg_e && !parity.avg_naf && !parity.score)) && !ri ) {
        return true
      }
      return false ;
    }
    const Equality = () => {
      return (
        <>
          {(parity && (parity.avg_e || parity.avg_naf || parity.score)) && (
            <>
          <div className="Biom">{t('Egalité Femme/Homme: {{pcent}}', { 
              pcent: parity?.score ? Math.round(parity.score) : 'N.R.'
            })}
          </div>
          <div className="Biom">{t('Index de la sélection: {{pcent}}', { 
              pcent: parity?.avg_e ? parity.avg_e : 'N.R.'
            })}
          </div>          
          <div className="Biom">{t("Index du secteur d'activité: {{pcent}}", { 
              pcent: parity?.avg_naf ? parity.avg_naf : 'N.R.'
            })}
          </div>          
          <div className="Biom Copyright2">
            {t('Source : ')}
            <a href="https://index-egapro.travail.gouv.fr/">https://index-egapro.travail.gouv.fr/</a>
          </div>  
          </>)}
          {parity && ri && (<div className="Biom Copyright2"><br/></div>)}
          {ri && (
            <>
              <div className="Biom">{t("Source de secours local: {{pcent}}", {pcent: ri.local_relief})}</div>          
              <div className="Biom">{t("Agilité: {{pcent}}", {pcent: ri.agility})}</div>          
              <div className="Biom">{t("Main-d'œuvre polyvalente: {{pcent}}", {pcent: ri.versatile_workforce})}</div>          
              <div className="Biom">{t("Flexibilité de l'approvisionnement: {{pcent}}", {pcent: ri.supply_flexibility})}</div>       
              <div className="Biom Copyright2"><br/></div>   
              <div className="Biom">{t("Index de résilience: {{pcent}}", {pcent: ri.resilience})}</div>       
            </>
          )}
        </>
      )
    }

    const { biom, parity, ri } = etablissement;
    if (!biom) {
      if (notEquality()) {
        return (
          <div className='h-full text-lg justify-center items-center flex flex-row'>
            <div>{t('non renseigné')}</div>
          </div>
        )
      }
      return (
        <div className='List ListBiom'>
          <Equality />
        </div>
      )
    }
    return (
      <div className='List ListBiom'>
        <div className="Biom" >{t(`Empreinte sociale: {{biom}}`, { biom: pcent(biom.biom) })}</div>
        <div className="Biom">{t('Entreprise intergénérationnelle: {{pcent}}', { pcent: pcent(biom.C1) })}</div>
        <div className="Biom">{t('Travailleurs en situation de handicap: {{pcent}}', { pcent: pcent(biom.C2) })}</div>
        <div className="Biom">{t('Accessibilité à la formation: {{pcent}}', { pcent: pcent(biom.C3) })}</div>
        {biom.C4 ?
          <div className="Biom">{t('Egalité Femme/Homme: {{pcent}}', { pcent: Math.round(biom.C4) })}</div> :
          <div className="Biom">{t('Egalité Femme/Homme: N.R.')}</div>
        }
        {biom.C5 ?
          <div className="Biom">{t('Dons, sponsoring, mécénat: {{pcent}}€/employé', { pcent: Math.round(biom.C5) })}</div> :
          <div className="Biom">{t('Dons, sponsoring, mécénat: N.R.')}</div>
        }
        <div className="Biom">{t('Achats en local: {{pcent}}', { pcent: pcent(biom.C6) })}</div>
        <div className="Biom">{t('Economie sociale et solidaire: {{rep}}', { rep: biom.C7 === null ? t("N.R.") : biom.C7 ? t("Oui") : t("Non") })}</div>
        <div className="Biom">{t('Energie verte: {{pcent}}', { pcent: pcent(biom.C8) })}</div>
        <div className="Biom">{t('Gestion des déchets: {{rep}}', { rep: biom.C9 === null ? t("N.R.") : biom.C9 ? t("Oui") : t("Non") })}</div>
        {biom.Q12 === null || !biom.Q12 || biom.Q13 === null ?
          <div className="Biom">{t('Emission des Gaz à Effets de Serre: {{rep}}', { rep: t("Bilan non fait") })}</div> :
          <div className="Biom">{t('Emission des Gaz à Effets de Serre: {{rep}}', { rep: biom.Q13 })}</div>
        }
        <div className="Biom Copyright">{t('Source : Copyright BIOM Attitudes ©')}</div>
        { (parity || ri) ? 
          <div className = "SecondList">
            <Equality />
          </div>
        : null
        }
      </div>
    )
  }

  const Entete = () => {
    return (
      <>
        <div className={"Title"}>
          <h2 className="Etablishment">{etablissement.usual_name}</h2>
          <span className="Siret">{etablissement.siret}</span>
        </div>
        <div className={"API"}>
          {imageUrl ? (
            <div className="ImageUrl">
              <img
                src={imageUrl}
                alt={"Entreprise"}
              />
            </div>
          ) : null}
          {process.env.REACT_APP_USE_GOOGLE_API === "true" ? (
            <div className="Google" ref={mapRef} />
          ) : (
            <div className="NR">
              <Trans>API Maps non chargée</Trans>
            </div>
          )}
        </div>

      </>
    )
  }

  const Info = ({ info, value }: { info: string, value: string }) => {
    return (
      <div className="Info">
        <span className="Title"><Trans>{info}</Trans></span>
        <span className="Value">{value}</span>
      </div>
    )
  }

  const InfoLink = ({ info, value, valuea }: { info: string, valuea: string, value: string }) => {
    return (
      <div className="Info">
        <span className="Title"><Trans>{info}</Trans></span>
        <a className="ValueLink" href={valuea}>{value}</a>
      </div>
    )
  }

  const InfoShedule = () => {
    return (
      <div className="Info">
        <span className="Title"><Trans>Horaires</Trans></span>
        <div className={"ValueShedule"}>
          <Dropdown>
            <Dropdown.Toggle>
              {ouvertures?.weekday_text[dayOfTheweek].split(": ")[1]}
              <ArrowDropDownIcon viewBox="0 0 28 28" width={"20"} height={"20"} />
            </Dropdown.Toggle>
            <Dropdown.Menu className={"dropdownHoraires"}>
              {ouvertures?.weekday_text.map((day: any, index: number) => {
                return (
                  <p key={index} className={`text-xs ${index === dayOfTheweek ? "font-bold" : ""}`}>
                    {day}
                  </p>
                );
              })}
            </Dropdown.Menu>
          </Dropdown>
        </div>
      </div>
    )
  }

  const Menu0 = () => {
    return (
      <>
        <div className="Menu0-Info">
          {adresse && <Info info='Adresse' value={adresse} />}
          <Info info="Effectif" value={getEffectifName()} />
          {telephone && <InfoLink info="Téléphone" valuea={"tel:+" + telephone?.replace(/ /g, "")} value={telephone} />}
          {website && <InfoLink info="Site internet" valuea={website} value={website} />}
          {ouvert && (
            <div className="Info">
              <span className={`OpenClose ${ouvert ? "Open" : "Close"}`} >
                {ouvert ? t("Ouvert") : t("Fermé")}
              </span>
            </div>
          )}
          {ouvertures && <InfoShedule />}
        </div>
        {etablissement.products && etablissement.products.length > 0 && (
          <div className={"List"}>
            <ReactTooltip
              place="left"
              type="dark"
              effect="solid"
              className={"sideTopTooltip sideProximityTooltip"}
              id={`topProduitsTooltip`}
            />
            {etablissement.products.map((p) => {
              const { name, code_hs4, sector_id, id } = p;
              const color = listeSecteurs[sector_id].color;
              const tooltipProxy = needAbbr(name, 95);
              if (p.fake) {
                tooltipProxy.displayText = tooltipProxy.displayText+' *';
                tooltipProxy.needAbbr = true; 
                tooltipProxy.tooltipText = tooltipProxy.tooltipText+t(' (simulé)')
              }
              return (
                <TopItem
                  key={id}
                  id={parseInt(code_hs4)}
                  code={code_hs4}
                  color={color}
                  tooltipProxy={tooltipProxy}
                  handleClick={setProduit}
                />
              );
            })}
          </div>)}
      </>)
  }

  return (
    <div className="SideInfosEtablissement">
      <div className="Container">
        <Entete />
        <div className="Datas" >
          <div className="Title">
            {etablissement.naf_description}
          </div>
          <div className="Menu">
            {[
              { id: 0, titre: t("Informations") },
              { id: 1, titre: t("Indicateurs") },
            ].map((e) => {
              return (
                <TopMenu
                  key={e.id}
                  menu={menu}
                  setMenu={setMenu}
                  currentMenu={e.id}
                  titre={e.titre}
                />
              );
            })}
          </div>
          <div className="Data" >
            {menu === 0 ? <Menu0 /> : <InfoBiom />}
          </div>
        </div>
      </div>
    </div>
  );
}

export default React.memo(SideInfosEtablissement);
