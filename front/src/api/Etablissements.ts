import axios from "axios";
import { useQuery } from "react-query";
import { CountType } from "./Global";
import { useAxios } from "./useAxios";

const baseUrl = `${process.env.REACT_APP_API_URL}visualisation/establishment`;

export interface EtablissementShortType {
  id: number
  siret: string
  usual_name: string
  coordinates: L.LatLngTuple
  activity_code: string
  sector_id: number
  workforce_group: string
  naf_description: string
  rome_chapter_exists: boolean
}

export interface PartnerType extends EtablissementShortType {
  distance: number
  cust_coef: number | null
  prov_coef: number | null
  score: number | null
  provider: boolean
  customer: boolean
  alt_provider:boolean
}

export type AvgBiomType = {
  C1: number | null
  C2: number | null
  C3: number | null
  C4: number | null
  C5: number | null
  C6: number | null
  C8: number | null
  nbr: number
  biom: number | null
}

export type OnePartnerType = {
  coordinates: [number, number];
  id: number;
  naf_description: string;
  rome_chapter_exists: boolean;
  sector_id: number;
  workforce_group: string;
}

export type PartnersType = {
  dest : OnePartnerType ;
  src : OnePartnerType ;
}

export type EtablissementsType = {
  establishments: EtablissementShortType[]
  partners: PartnersType[]
  count: CountType
  employer: EtablissementShortType[]
  biom: AvgBiomType
  parity?: number
}


export const useGetEtablissements=(urlForApi: string, part?:string) => {
  const api = useAxios(baseUrl) ;
  return useQuery<EtablissementsType>(
    ['useGetEtablissements', urlForApi, part],
    async () => {
      const {data} = await api.get(`${urlForApi}${part ? `&part=${part}` : ""}`);
      return data
    },
  )
}

type BiomType = {
  C1: number | null
  C2: number | null
  C3: number | null
  C4: number | null
  C5: number | null
  C6: number | null
  C7: boolean
  C8: number | null
  C9: boolean
  Q12: boolean
  Q13: number | null
  biom: number | null
}
export interface EtablissementLongType extends EtablissementShortType {
  description: string | null
  phone_fix: string | null
  phone_mobile: string | null
  web_site: string | null
  way: string | null
  complement: string | null
  zip: string | null
  products: {
    id: number
    name: string
    code_hs4: string
    sector_id: number
    fake: boolean
  }[]
  partner: PartnerType[]
  count: CountType
  biom?: BiomType
  parity?:{
    avg_e?: number
    score?: number
    avg_naf?: number
  }
  ri?: {
    agility: number,
    resilience: number,
    local_relief: number,
    supply_flexibility: number,
    versatile_workforce: number,
  }
}

export const useGetEtablissement=(urlForApi: string, etablissementId: number | undefined) => {
  const api = useAxios(baseUrl) ;
  return useQuery<EtablissementLongType>(
    ['useGetEtablissement', urlForApi, etablissementId],
    async () => {
      const {data} = await api.get(`/information/${etablissementId}${urlForApi}`);
      return data
    },
    {
      enabled : !!etablissementId
    }
  )
}

/**
 * FTS sur siret et nom des établissements
 */
export type SearchEtablissementsType = {
  establishments: EtablissementShortType[]
  partners: any[]
}


export async function searchEtablissement({
  searchStr,
  regionId = undefined,
  indusTerritoryId = undefined,
}: {
  searchStr: string,
  regionId?: string,
  indusTerritoryId?: string,
}): Promise<SearchEtablissementsType> {
  let url = `${baseUrl}/search?q=${searchStr}`;

  if (indusTerritoryId) {
    url += `&industry_territory=${indusTerritoryId}`;
  } else if (regionId) {
    url += `&region=${regionId}`;
  }
  const res = await axios.get(url);
  return res.data;
}


