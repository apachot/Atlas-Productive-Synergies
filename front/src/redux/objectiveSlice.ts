import { createSlice, PayloadAction } from "@reduxjs/toolkit";
export const initialState = {
    advantage: 0, // Competitive advantage
    pci: 0, // Economic growth
    resilience: 0, // Productive resilience
    maslow: 0, // Securing basic necessities
    green: 0, // Green production
}

export type ObjectiveState = typeof initialState;

export const objectiveSlice = createSlice({
    name: 'objectives',
    initialState,
    reducers: {
        setMaslow: (state, action: PayloadAction<number>) => {
            state.maslow = action.payload;
        },
        setResilience: (state, action: PayloadAction<number>) => {
            state.resilience = action.payload;
        },
        setGreen: (state, action: PayloadAction<number>) => {
            state.green = action.payload;
        },
        setPci: (state, action: PayloadAction<number>) => {
            state.pci = action.payload;
        },
        setAdvantage: (state, action: PayloadAction<number>) => {
            state.advantage = action.payload;
        },
    }
});

export default objectiveSlice.reducer;

export const { setAdvantage, setGreen, setMaslow, setPci, setResilience } = objectiveSlice.actions;