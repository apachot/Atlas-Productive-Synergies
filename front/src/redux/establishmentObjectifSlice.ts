 import { createSlice, PayloadAction } from "@reduxjs/toolkit";
 export const initialState = {
    womenMen : 0,
    distance : 0,
    number : 5,
    customer: false,
    provider: true,
    alternateProvider: true,
 }
 
 export type EstablishmentObjectiveState = typeof initialState;
 
 export const establishmentObjectiveSlice = createSlice({
     name: 'establishmentObjectives',
     initialState,
     reducers: {
        setCustomer: (state, action: PayloadAction<boolean>) => {
            state.customer = action.payload ;
        },
        setProvider: (state, action: PayloadAction<boolean>) => {
            state.provider = action.payload ;
        },
        setAlternateProvider: (state, action: PayloadAction<boolean>) => {
            state.alternateProvider = action.payload ;
        },        
        setWomenMen: (state, action: PayloadAction<number>) => {
            state.womenMen = action.payload ;
        },
        setDistance: (state, action: PayloadAction<number>) => {
            state.distance = action.payload ;
        },
        setNumber: (state, action: PayloadAction<number>) => {
            state.number = action.payload ;
        },
     }
 });
 
 export default establishmentObjectiveSlice.reducer;
 
 export const { setDistance, setNumber, setWomenMen, setCustomer, setProvider, setAlternateProvider } = establishmentObjectiveSlice.actions;