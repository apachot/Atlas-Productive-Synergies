import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { GetRegionType } from "../api/Global";
import { defaultVisibleDomaines, defaultVisibleSectors, defaultVisibleWorkforces, listeEffectifs } from "../maps/mapsConfig";
import { parseZoneId } from "../Utils";

 type EtablissementOptions = {
    id: any,
    value: any,
    label: any,
  }[]

export const getinitialData = () => {
    const path = window.location.pathname;
    const parsedUrl = path.match(/^\/([a-z]+)\/((?:EPCI[0-9]+-[0-9]+)|(?:TI[0-9]+)|(?:[0-9]+))\/?([0-9]+)?/i);
    const zoneId = parsedUrl ? parsedUrl[2] : "";
    const { regionId, territoireId, epciId } = parseZoneId(zoneId);

    const pageName = parsedUrl ? parsedUrl[1] : "";
    const id = parsedUrl && parsedUrl[3] ? parsedUrl[3] : undefined;

    const etablissementId = id && pageName.indexOf("etablissement") !== -1 ? parseInt(id) : undefined;
    const produitId = id && pageName.indexOf("produit") !== -1 ? id : undefined;
    return ({ regionId, territoireId, etablissementId, produitId, epciId })
}

export const initialState: FilterState = {
    regionId: getinitialData().regionId,
    territoireId: getinitialData().territoireId,
    epciId: getinitialData().epciId,
    effectifs: defaultVisibleWorkforces,
    secteurs: defaultVisibleSectors,
    domaines: defaultVisibleDomaines,
    etablissementId: getinitialData().etablissementId,
    produitId: getinitialData().produitId,
    metierId: undefined,
    urlForApi: getUrlFromFilter(
        {
            regionId: getinitialData().regionId,
            territoireId: getinitialData().territoireId,
            epciId: getinitialData().epciId,
            effectifs: defaultVisibleWorkforces,
            secteurs: defaultVisibleSectors,
            domaines: defaultVisibleDomaines,
            etablissementId: getinitialData().etablissementId,
            produitId: getinitialData().produitId,
            metierId: undefined,
            urlForApi: '',
        }
    )
}

export type FilterState = {
    regionId: string,
    territoireId: string | undefined,
    epciId: string | undefined,
    effectifs: number[],
    secteurs: number[],
    domaines: string[],
    etablissementId: number | undefined,
    produitId: string | undefined,
    metierId: string | undefined,
    urlForApi: string,
    regionData?: GetRegionType,
    etablissementOptions?:EtablissementOptions,    
}

export function getUrlFromFilter(filtres: FilterState): string {
    const {
        regionId,
        territoireId,
        epciId,
        effectifs,
        secteurs,
        domaines,
        etablissementId,
        produitId,
        metierId,
    } = filtres;
    let urlParam = "";
    const lang = localStorage.getItem("lang") || 'en';
    if (territoireId) {
        urlParam += `?industry_territory=${territoireId}`;
    } else if (epciId && epciId !=='0') {
        urlParam += `?epci=${epciId}`;
    } else {
        urlParam += `?region=${regionId}`;
    }
    if (domaines) {
        urlParam += `&domain=${domaines}`;
    }
    if (secteurs) {
        urlParam += `&sector=${secteurs}`;
    }
    urlParam += "&workforce=";
    if (effectifs.length > 0) {
        let urlEffectif = "";
        for (const key in effectifs) {
            if (effectifs.hasOwnProperty(key)) {
                urlEffectif += listeEffectifs[effectifs[key]].workforceCodes + ",";
            }
        }
        urlParam += urlEffectif.replace(/,$/, "");
    }

    if (etablissementId) {
        urlParam += `&establishment=${etablissementId}`;
    }
    if (produitId) {
        urlParam += `&hs4=${produitId}`;
    }
    if (metierId) {
        urlParam += `&rome=${metierId}`;
    }
    // add language
    urlParam += `&lang=${lang}`;

    return urlParam;
}

export const filterSlice = createSlice({
    name: 'filter',
    initialState,
    reducers: {
        reinitFilter: (state) => {
            state.territoireId=undefined;
            state.effectifs= defaultVisibleWorkforces;
            state.secteurs= defaultVisibleSectors;
            state.domaines= defaultVisibleDomaines; 
            state.etablissementId= undefined;
            state.produitId= undefined;
            state.metierId= undefined;
            state.urlForApi = getUrlFromFilter(state)
        },
        setRegionAndTerritoire: (state, action: PayloadAction<{ regionId: string, territoireId: string | undefined, epciId: string | undefined  }>) => {
            state.regionId = action.payload.regionId;
            state.territoireId = action.payload.territoireId;
            state.epciId = action.payload.epciId;
            state.urlForApi = getUrlFromFilter(state);
        },
        setProduitId: (state, action: PayloadAction<string | undefined>) => {
            state.produitId = action.payload;
            state.urlForApi = getUrlFromFilter(state);
        },
        setEtablissementId: (state, action: PayloadAction<number | undefined>) => {
            state.etablissementId = action.payload;
            state.urlForApi = getUrlFromFilter(state);
        },
        setTerritoireId: (state, action: PayloadAction<string | undefined>) => {
            state.territoireId = action.payload;
            state.epciId = undefined;
            state.urlForApi = getUrlFromFilter(state);
        },
        setEpciId: (state, action: PayloadAction<string | undefined>) => {
            state.territoireId = undefined;
            state.epciId = action.payload;
            state.urlForApi = getUrlFromFilter(state);
        },
        setMetierId: (state, action: PayloadAction<string | undefined>) => {
            state.metierId = action.payload;
            state.urlForApi = getUrlFromFilter(state);
        },
        setDomains: (state, action: PayloadAction<string[]>) => {
            state.domaines = action.payload;
            state.urlForApi = getUrlFromFilter(state);
        },
        setSecteurs: (state, action: PayloadAction<number[]>) => {
            state.secteurs = action.payload;
            state.urlForApi = getUrlFromFilter(state);
        },
        setEffectifs: (state, action: PayloadAction<number[]>) => {
            state.effectifs = action.payload;
            state.urlForApi = getUrlFromFilter(state);
        },
        setRegionData: (state, action: PayloadAction<GetRegionType | undefined>) => {
            state.regionData = action.payload
        },
        setEtablissementOptions : (state, action: PayloadAction<EtablissementOptions | undefined>) => {
            state.etablissementOptions = action.payload
        },
        setEtablissementOptionsAndId : (state, action: PayloadAction<{option:EtablissementOptions | undefined, id:number | undefined}>) => {
            state.etablissementOptions = action.payload.option
            state.etablissementId = action.payload.id;
            state.urlForApi = getUrlFromFilter(state);
        },
        setRegionAndTerritoireAndData: (state, action: PayloadAction<{ regionId: string, territoireId: string | undefined, epciId: string | undefined, data:GetRegionType | undefined }>) => {
            state.regionId = action.payload.regionId;
            state.territoireId = action.payload.territoireId;
            state.epciId = action.payload.epciId;
            state.regionData = action.payload.data;
            state.urlForApi = getUrlFromFilter(state);
        },        
    }
});

export default filterSlice.reducer;

export const {
    reinitFilter,
    setRegionAndTerritoire,
    setProduitId,
    setEtablissementId,
    setTerritoireId,
    setMetierId,
    setDomains,
    setSecteurs,
    setEffectifs,
    setEtablissementOptions,
    setRegionData,
    setEtablissementOptionsAndId,
    setRegionAndTerritoireAndData,
    setEpciId,
} = filterSlice.actions;