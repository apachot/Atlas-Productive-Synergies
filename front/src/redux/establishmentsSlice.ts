import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { AvgBiomType, EtablissementShortType, PartnersType } from "../api/Etablissements";

export type EstablishmentsState = {
    establishments?: EtablissementShortType[]
    partners: PartnersType[]
    employer: EtablissementShortType[]
    biom: AvgBiomType
    parity?: number    
};

export const initialState:EstablishmentsState = {
    partners: [],
    employer: [],
    biom: {
        C1: null,
        C2: null,
        C3: null,
        C4: null,
        C5: null,
        C6: null,
        C8: null,
        nbr: 0,
        biom: null,
    },
 }
 
 export const establishmentsSlice = createSlice({
     name: 'establishments',
     initialState,
     reducers: {
        setEstablishments: (state, action: PayloadAction<EtablissementShortType[] | undefined>) => {
            state.establishments = action.payload ;
        },
        setPartners: (state, action: PayloadAction<PartnersType[]>) => {
            state.partners = action.payload ;
        },
        setEmployer: (state, action: PayloadAction<EtablissementShortType[]>) => {
            state.employer = action.payload ;
        },
        setBiom: (state, action: PayloadAction<AvgBiomType>) => {
            state.biom = action.payload ;
        },
        setParity: (state, action: PayloadAction<number | undefined>) => {
            state.parity = action.payload ;
        },
     }
 });
 
 export default establishmentsSlice.reducer;
 
 export const { setEstablishments, setBiom, setEmployer, setParity, setPartners } = establishmentsSlice.actions;