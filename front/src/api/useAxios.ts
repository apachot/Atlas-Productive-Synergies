import axios from 'axios';

export const useAxios = (baseURL: string) => {
    return axios.create({
      baseURL,
      responseType: 'json',
    });
  };