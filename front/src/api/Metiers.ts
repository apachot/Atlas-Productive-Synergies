import { useQuery } from "react-query";
import { StandardType } from "./Produits";
import { useAxios } from "./useAxios";

const baseUrl = `${process.env.REACT_APP_API_URL}visualisation/job`;

/**
 * Agrégation des métiers de la zone géographique.
 */
export type MetiersRepresentativeWorkType = {
  code: string
  longlabel: string
  value: string
}

export interface MetiersType extends StandardType {
  representativeWork: MetiersRepresentativeWorkType[]
}

export const useGetMetiers = (urlForApi: string) => {
  const api = useAxios(baseUrl) ;
  return useQuery<MetiersType>(
    ['useGetMetiers', urlForApi],
    async () => {
      const {data} = await api.get(urlForApi);
      return data
    }
  )
}

export const useGetMetierParente = (urlForApi: string, metierId: string | undefined) => {
  const api = useAxios(baseUrl) ;
  return useQuery<MetiersType>(
    ['useGetMetierParente', urlForApi, metierId],
    async () => {
      const {data} = await api.get(`/information/${metierId}${urlForApi}`);
      return data
    },
    {
      enabled : !!metierId,
    }
  )
}

