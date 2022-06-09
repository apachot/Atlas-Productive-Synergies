/**
 * Détail du panneau latéral pour un produit, proximité ou parenté productive
 */
import React from "react";
import { needAbbr, parsePourcentage } from "../Utils";
import ReactTooltip from "react-tooltip";
import { Link } from "react-router-dom";
import { ReactComponent as Sauts } from "../svgs/sauts.svg";
import { ReactComponent as Losange } from "../svgs/losange.svg";
import { ReactComponent as Recommandations } from "../svgs/recommandation.svg";
import InfoIcon from "@material-ui/icons/Info";
import { listeSecteurs } from "../maps/mapsConfig";
import { Trans, getI18n, useTranslation, TFunction } from 'react-i18next';
import Loader from "./loader";
import { productNames, productPosition, ShortDataNode } from "./space/spaceData";
import { ProduitStandardType, ProximitiesStandard } from "../api/Produits";
import './SideInfosProduit.scss';
import { RootState } from "../redux/store";
import { useSelector } from "react-redux";

const LibelleProduit = ({ produit, setProduit, t, isLoading = false }: {
  produit: ShortDataNode,
  setProduit: { (id: string): void },
  t: TFunction<"translation">,
  isLoading?: boolean
}) => {
  if (!produit) {
    return null;
  }
  const tooltipName = needAbbr(produit.lib[getI18n().language], 68);
  const tooltipSector = needAbbr(t(produit.secteurName), 47);
  return (
    <div className={"LibelleProduit"}>
      <div
        className={`Title ${isLoading ? "Wait" : "Pointer"}`}
        onClick={() => setProduit(produit.id)}
      >
        <div
          className="Primary"
          data-tip={tooltipName.tooltipText}
          data-for={"sideProduitTooltip"}
        >
          {tooltipName.displayText}
        </div>
        <div
          className={"Secondary"}
          data-tip={tooltipSector.tooltipText}
          data-for={"sideProduitTooltip"}
        >
          {tooltipSector.displayText}
        </div>
        <div className="Code">
          {produit.id}
        </div>
      </div>
    </div>
  );
};

const DetailProximite = ({
  produit,
  typeLiaison,
  setProduit = () => { },
  isLoading = false,
}: {
  produit: ProduitStandardType,
  typeLiaison: "Parenté" | "Proximité";
  setProduit?: { (id: string): void },
  isLoading?: boolean,
}) => {
  const nbProximite = produit.proximities.filter((e) => e.level === 1).length;
  const { t } = useTranslation();

  type ValuesType = {
    tooltipText: string;
    p: ProximitiesStandard;
    color: string;
    displayText: string;
  }
  const Values = ({ p, tooltipText, color, displayText }: ValuesType) => {
    const { code_hs4 } = p;
    return (
      <div className={`Values ${isLoading ? "Wait" : "Pointer"}`}
        onClick={() => setProduit(code_hs4)}
        data-tip={tooltipText}
        data-for={"sideProximityTooltip"}
      >
        <svg viewBox="0 0 120 120" className={"SVG"}>
          {p.value !== 0 || typeLiaison === "Parenté" ? (
            <circle className="Graph" fill={color} cx="60" cy="60" r="50" />
          ) : (
            <Losange className="Graph" fill={color} cx="60" cy="60" />
          )}
        </svg>
        <div>
          <span className={"Display"}>{displayText}</span>
          <span className={"Code"}>{code_hs4}</span>
        </div>
      </div>
    )
  }

  const theDatas = () => {
    if (typeLiaison !== 'Parenté') {
      if (nbProximite > 0) {
        return produit.proximities.filter(p => p.level === 1).map((p) => {
          const { id, name, macro_sector_id } = p;
          const color = listeSecteurs[macro_sector_id].color;
          const tooltipProxy = needAbbr(name, 85);
          return <Values color={color} displayText={tooltipProxy.displayText} p={p} tooltipText={tooltipProxy.tooltipText} key={id} />
        })
      }
      return (
        <div className={"None"}>
          <span><Trans>Aucune</Trans></span>
        </div>
      );
    }
    const prod = productPosition.nodes.find(e => e.id === produit.product.code_hs4)
    if (!prod) {
      return (
        <div className={"None"}>
          <span><Trans>Aucune</Trans></span>
        </div>
      );
    }
    return (
      prod.edge
        .sort((a, b) => (b.strength ?? 0) - (a.strength ?? 0))
        .map(e => {
          const f = productPosition.nodes.find(n => n.id === e.id);

          const color = f?.color ?? '#fff';
          const name = f?.lib[getI18n().language] ?? '';
          const tooltipProxy = needAbbr(name, 85);
          const p: ProximitiesStandard = {
            code_hs4: e.id,
            id: parseInt(e.id),
            level: 1,
            macro_sector_id: 0,
            name,
            need: 0,
            parents: [],
            proximity: 0,
            value: 0,
            workforce_group: []
          }
          return <Values color={color} displayText={tooltipProxy.displayText} p={p} tooltipText={tooltipProxy.tooltipText} key={e.id} />
        }))
  }

  return (
    <div className="DetailProximite">
      <ReactTooltip
        place="left"
        type="dark"
        effect="solid"
        className={"sideProximityTooltip"}
        id={"sideProximityTooltip"}
      />
      <div className="Title">
        <span className="Text">
          {t(`${typeLiaison === 'Parenté' ? 'Proximité' : typeLiaison} productive`)}
        </span>
        <InfoIcon className="InfoIcon" />
      </div>
      <div className="Container" >
        <div className={"Datas"}>
          {theDatas()}
        </div>
      </div>
      {typeLiaison === "Proximité" ? (
        <div className="Proximity">
          <div className={"Detail"}>
            <div className={"Left"}>
              <Trans>Nombre d'entreprise fabriquant le produit sur le territoire</Trans>
            </div>
            <div className={"Right"}>
              {produit.product.value}
            </div>
          </div>
          <div className={"Detail"}>
            <div className={"Left"}>
              <Trans>Volume de demande locale sur le territoire</Trans>
            </div>
            <div className={"Right"}>
              {parsePourcentage(produit.product.need, 2)}%
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
};

export default function SideInfosProduit(props: {
  produit?: ProduitStandardType,
  produitIdSelected?: string,
  produitSelected?: ProduitStandardType,
  typeLiaison: "Parenté" | "Proximité",
  setProduit: { (id: string): void }
}) {
  const {
    produit,
    produitIdSelected = undefined,
    produitSelected = undefined,
    typeLiaison,
    setProduit,
  } = props;
  const {
    regionId,
    territoireId,
    epciId,
    produitId,
  } = useSelector((state: RootState) => state.filter);
  const produitWoQuery = productNames.nodes.find(e => e.id === (produitIdSelected ?? produitId ?? ""))
    ?? productPosition.nodes.find(e => e.id === (produitIdSelected ?? produitId ?? ""))!
  const { t } = useTranslation();
  const prod = produitIdSelected && produitSelected ? produitSelected : produit;
  const nbProximite = prod?.proximities.filter((e) => e.level === 1).length ?? 0;

  return (
    <div className="SideInfosProduit">
      <ReactTooltip
        place="left"
        type="dark"
        effect="solid"
        className={"sideProduitTooltip"}
        id={"sideProduitTooltip"}
      />
      <div className={"productHead"}>
        <LibelleProduit produit={produitWoQuery} setProduit={setProduit} t={t} />
      </div>
      <div className="Product" >
        {(produitIdSelected && !produitSelected) || !produit ? (
          <div className={"Loader"}><Loader /></div>
        ) : (
          <DetailProximite
            typeLiaison={props.typeLiaison}
            produit={produitIdSelected && produitSelected ? produitSelected : produit}
            setProduit={setProduit}
          />
        )}
      </div>
      {produit ? (
        typeLiaison === "Proximité" || !produit.product.hasproximity || nbProximite === 0 ? (
          <button className={"ProximityLink"}>
            <Recommandations className={"Wand"} />
            <Trans>Voir les recommandations</Trans>
          </button>
        ) : (
          <Link
            to={`/produit/${epciId ? `EPCI${regionId}-${epciId}` : (territoireId ? territoireId : regionId)
              }/${produitId}`}
            className={"LinkProximityLink"}
          >
            <button className={"ProximityLink"}>
              <Sauts className={"Wand"} />
              <Trans>Voir les sauts productifs</Trans>
            </button>
          </Link>
        )
      ) : null}
    </div>
  );
}
