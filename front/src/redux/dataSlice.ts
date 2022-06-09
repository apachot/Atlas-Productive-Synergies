import { createSlice, PayloadAction } from "@reduxjs/toolkit";
import { RegionType, IndustryTerritoryType, EpciType, DepartmentType, GetRegionType } from "../api/Global";

export type DataState = {
    regions: RegionType[]
    territoires: IndustryTerritoryType[]
    epci: EpciType[]
    department: DepartmentType[]
}
export const initialState: DataState = {
    regions: [],
    territoires: [],
    epci: [],
    department: [],
}

export const dataSlice = createSlice({
    name: 'data',
    initialState,
    reducers: {
        setData: (state, action: PayloadAction<GetRegionType>) => {
            state.regions = action.payload.region;
            state.territoires = action.payload.industry_territory;
            state.epci = action.payload.epci;
            state.department = action.payload.department;
        },
        setDataRegion: (state, action: PayloadAction<RegionType[]>) => {
            state.regions = action.payload;
        },
        setDataTerritoire: (state, action: PayloadAction<IndustryTerritoryType[]>) => {
            state.territoires = action.payload;
        },
        setDataEpci: (state, action: PayloadAction<EpciType[]>) => {
            state.epci = action.payload;
        },
    }
});

export default dataSlice.reducer;

export const { setData, setDataEpci, setDataRegion, setDataTerritoire } = dataSlice.actions;