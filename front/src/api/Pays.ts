import { useQuery } from "react-query";
import { GetRegionType } from "./Global";
import { useAxios } from "./useAxios";
const baseUrl = `${process.env.REACT_APP_API_URL}visualisation`;


export const useGetPays = (part?: string) => {
    const api = useAxios(baseUrl) ;
    return useQuery<GetRegionType>( ['useGetPays', part],
    async () => {
        const {data} = await api.get(`/country${part ? `?part=${part}` : ''}`);
        return data
      },
    )
}

