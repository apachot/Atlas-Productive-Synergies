import { configureStore, ThunkAction, Action } from "@reduxjs/toolkit";
import countReducer from "./countSlice";
import objectiveReducer from "./objectiveSlice";
import filterReducer from './filterSlice';
import errorReducer from './errorSlice';
import dataReducer from './dataSlice' ;
import establishmentObjectiveReducer from './establishmentObjectifSlice' ;
import establishmentsReducer from './establishmentsSlice' ;

export const store = configureStore({
  reducer: {
    count: countReducer,
    objective: objectiveReducer,
    filter: filterReducer,
    errors: errorReducer,
    data: dataReducer,
    establishmentObjective: establishmentObjectiveReducer,
    establishment : establishmentsReducer,
  }
});

export type RootState = ReturnType<typeof store.getState>;
export type AppThunk<ReturnType = void> = ThunkAction<
  ReturnType,
  RootState,
  unknown,
  Action<string>
>;
