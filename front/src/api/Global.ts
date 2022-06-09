/**
 * Récupération des routes de configuration (alimentation des menus, selects, etc...)
 */
import { useQuery } from "react-query";
import { useAxios } from "./useAxios";
const baseUrl = `${process.env.REACT_APP_API_URL}visualisation`;

/**
 * Détail de la région, liste des TI, capacité RCA de la région
 * @param {number} regionId
 * @returns {Promise<object>}
 * - department, array, liste des départements de la région
 * - industry_territory, array, liste des TI de la région
 * - region, array, détail de la région
 */
export type DepartmentType = {
  code: string;
  name: { fr: string };
  region_id: number;
  slug: string;
}

export interface CommonRegionType {
  name: {
    fr: string
  },
  coef_rca: number
  score: {
    "20": {
      code: string
      name: {
        fr: string
      },
      value: number
    }
  }
}

type PointTuple = [number, number];
type Polyline = PointTuple[] ;

export interface RegionType extends CommonRegionType {
  code: string
  slug: string
  country_id: number
  poly: Polyline[]
}

export interface IndustryTerritoryType extends CommonRegionType {
  national_identifying: string
}

export interface EpciType extends CommonRegionType {
  siren: string
  region: string
  poly: Polyline[]
}

export type GetRegionType = {
  department: DepartmentType[];
  industry_territory: IndustryTerritoryType[];
  region: RegionType[];
  epci: EpciType[];
}

export const useGetRegion = ({ regionId, part }: { regionId: string, part?:string }) => {
  const api = useAxios(baseUrl) ;
  return useQuery<GetRegionType>(
    ['useGetRegion', regionId, part],
    async () => {
      const {data} = await api.get(`/region/${regionId}${part ? `?part=${part}`: ''}`);
      return data
    },
    {
      enabled : !!regionId
    }
  )
}

export type CountType = {
  job: number
  product: number
  establishment: number
}