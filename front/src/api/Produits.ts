import { useQuery } from "react-query";
import { CountType } from "./Global";
import { useAxios } from "./useAxios";

const baseUrl = `${process.env.REACT_APP_API_URL}visualisation/product`;

/**
 * Agrégation des produits de la zone géographique selon le nombre d'entreprises qui les produit.
 */
export type RcaType = {
  id: number
  code_hs4: string
  sector_id: number
  name: string
  rca: string
}
export type Madetype = {
  id: number
  code_hs4: string
  sector_id: number
  name: string
  exportation: string
}

export interface StandardType {
  data: {
    id: string
    value: number
  }[],
  config: {
    min: number
    max: number
  }
  count: CountType
}

export interface ProduitType extends StandardType {
  rca: RcaType[]
  made: Madetype[]
}

type Product =  {
  id: number
  code_hs4: string
  sector_id: number
  name: string
  workforce_group: string[]
  hasproximity: boolean
  value: number
  need: number
}

export interface ProximitiesStandard {
  id: number
  code_hs4: string
  macro_sector_id: number
  name: string
  level: number
  parents: string[]
  proximity: number
  workforce_group: string[]
  value: number
  need: number
}

export interface ProduitStandardType {
  product: Product,
  proximities: ProximitiesStandard[]
  relations: [string, string][],
  count: CountType,
  needs: {
    [key: string]: number
  },
}

interface ProximitiesProduit extends ProximitiesStandard {
  proximity_lvl1: string[]
  maslow_norm?: number
  resilience_norm?: number
  green_norm?: number
  pci_norm?: number
  advantage_norm?: number
}

export interface ProduitProximiteType extends ProduitStandardType {
  proximities: ProximitiesProduit[]
}

export interface ProduitParenteType extends ProduitStandardType {
}

export const useGetProduits = (urlForApi: string) => {
  const api = useAxios(baseUrl) ;
  return useQuery<ProduitType>(
    ['useGetProduits', urlForApi],
    async () => {
      const {data} = await api.get(urlForApi);
      return data
    }
  )
}

export const useGetProduitProximite = (urlForApi: string, produitId: string | undefined) => {
  const api = useAxios(baseUrl) ;
  return useQuery<ProduitProximiteType>(
    ['useGetProduitProximite', urlForApi, produitId],
    async () => {
      const {data} = await api.get(`/${produitId}/proximity${urlForApi}`);
      return data
    },
    {
      enabled: !!produitId,
    }
  )
}

export const useGetProduitParente = (urlForApi: string, produitId: string | undefined) => {
  const api = useAxios(baseUrl) ;
  return useQuery<ProduitParenteType>(
    ['useGetProduitParente', urlForApi, produitId],
    async () => {
      const {data} = await api.get(`/${produitId}${urlForApi}`);
      return data
    },
    {
      enabled: !!produitId,
    }
  )
}

