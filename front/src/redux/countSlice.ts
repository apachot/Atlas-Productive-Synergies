import { createSlice, PayloadAction } from "@reduxjs/toolkit";

export const initialState = {
    nbProduit: 0,
    nbMetier: 0,
    nbEtablissement: 0,
    nbFormation: 0,
    nbIndividu: 0,
    countInit: false
}

export type CountState = typeof initialState;

export const countSlice = createSlice({
    name: 'count',
    initialState,
    reducers: {
        setCount: (state, action: PayloadAction<{
            nbProduit: number,
            nbEtablissement: number,
            nbMetier: number
        }>) => {
            state.nbEtablissement = action.payload.nbEtablissement;
            state.nbProduit = action.payload.nbProduit;
            state.nbMetier = action.payload.nbMetier;
            state.countInit = true;
        }
    }
});

export default countSlice.reducer;

export const { setCount } = countSlice.actions;