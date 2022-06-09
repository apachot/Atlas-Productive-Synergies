import React from "react";
import { configRegions, LEGEND, regions } from "../maps/france/france_regions";
import { territoires } from "../maps/france/france_ti";
import { EPCI } from "../maps/france/france_epci";
import { setRegionAndTerritoire } from "../redux/filterSlice";
import { parsePourcentage, parseZoneId } from "../Utils";
import { Dispatch } from "redux";
import { RefTooltip } from "./Utils";
import { CommonRegionType, EpciType, IndustryTerritoryType, RegionType } from "../api/Global";

type Props = {
    refTooltip: React.RefObject<RefTooltip>
    mode: 'regions' | 'territoire' | 'EPCI'
    data: CommonRegionType[] 
    dispatch: Dispatch<any>
    history: any
}
const paysMap = ({ refTooltip, mode, data, dispatch, history }: Props) => {
    const carte = mode === "regions" ? regions : ( mode === "territoire" ? territoires : EPCI);
    const config = configRegions;
    const extractCode = (str: string, mode: string): string => {
        if (mode === "regions") {
            return str.split("-")[1];
        } else {
            return str;
        }
    };
    const determineColor = (score: number): string => {
        if (score===0) {
            return "lightgray" ;
        }
        const pourcentage = score * 100;
        const item = LEGEND.filter((e) => {
            return e.min <= pourcentage && e.max > pourcentage;
        })[0];
        return item.attrs.fill;
    };

    let svgText: JSX.Element[] = [];
    const viewBox = (mode === "regions") ? "-50 -50 700 820" : (mode === "territoire" ? "-100 -50 900 816.59" : "0 0 1241 1355" );

    const onClick = (id: string) => {
        const { regionId, territoireId, epciId } = parseZoneId(id);
        dispatch(setRegionAndTerritoire({ regionId, territoireId, epciId }));
        history.push(`/etablissements/${id}`)
    }

    function instanceOfRegionType(object : CommonRegionType): object is RegionType { return object && 'slug' in object} ;
    function instanceOfIndustryTerritoryType(object : CommonRegionType): object is IndustryTerritoryType { return object && 'national_identifying' in object} ;
    function instanceOfEpciType(object : CommonRegionType): object is EpciType { return object && 'siren' in object} ;

    return (
        <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox={viewBox}
        >
            {Object.keys(carte).map((key) => {
                if (key === "Fond") {
                    return (
                        <path
                            key={key}
                            d={carte[key]}
                            stroke={"#b1afaf"}
                            fill={"#f4f4e8"}
                        />
                    );
                }
                const id = extractCode(key, mode);
                const item = data.filter((e) => {
                    return (instanceOfRegionType(e) && e.code === id) || 
                        (instanceOfIndustryTerritoryType(e) && e.national_identifying === id) ||
                        (instanceOfEpciType(e) && e.siren === id) 
                        ;
                })[0];
                const clickId = instanceOfEpciType(item) ? `EPCI${item.region}-${id}` : id ;                
                const {
                    coef_rca,
                    name: { fr: name },
                } = (item ? item : {coef_rca:0, name:{fr:""}});
                if (mode === "regions") {
                    const { x, y, textAnchor } = config[key];
                    //On prépare les textes mais on les ajoutes après pour qu'ils soient au dessus
                    svgText.push(
                        <text
                            key={`label${id}`}
                            id={id}
                            x={x}
                            y={y}
                            className={"cursor-pointer"}
                            textAnchor={textAnchor}
                            fontSize={"12px"}
                            onClick={() => onClick(clickId)}
                            onTouchEnd={() => onClick(clickId)}
                        >
                            <tspan x={x} dy={"1.2em"}>
                                {name}
                            </tspan>
                            <tspan x={x} dy={"1.2em"} className={"font-bold"}>
                                {parsePourcentage(coef_rca)}%
                            </tspan>
                        </text>
                    );
                }
                return (
                    <path
                        className={"cursor-pointer"}
                        key={id}
                        id={`path${id}`}
                        d={carte[key]}
                        fill={determineColor(coef_rca)}
                        stroke={"#b1afaf"}
                        onClick={() => onClick(clickId)}
                        onTouchEnd={() => onClick(clickId)}
                        onMouseMove={(e: React.MouseEvent<SVGPathElement>) =>{
                            refTooltip.current?.show(
                                e, 
                                (
                                    <>
                                        <p>{name}</p>
                                        <p className={"font-bold"}>
                                            {parsePourcentage(coef_rca)}%
                                        </p>

                                    </>
                                ),
                                `path${id}`
                            )}
                        }
                        onMouseOut={(e) => refTooltip.current?.hide(`path${id}`) }
                    />
                );
            })}
            {svgText.map((t) => {
                return t;
            })}
        </svg>
    )
}

export default paysMap