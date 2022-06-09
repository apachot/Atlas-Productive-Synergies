 import { createSlice, PayloadAction } from "@reduxjs/toolkit";

 export type ErrorState = {
    error?:string
 };

 export const initialState:ErrorState = {
     error: undefined,
 }
 
 
 export const errorSlice = createSlice({
     name: 'error',
     initialState,
     reducers: {
         setOneError: (state, action: PayloadAction<string>) => {
             state.error = action.payload
         }
     }
 });
 
 export default errorSlice.reducer;
 
 export const { setOneError } = errorSlice.actions;