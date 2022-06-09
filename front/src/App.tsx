import React from "react";
import { Helmet, HelmetProvider } from "react-helmet-async";
import "./css/main.css";
import "./css/App.css";
import "./css/custom_bootstrap.css";
import MainRouter from "./Router";
import ErrorBoundary from "./components/ErrorBoundary";
import { BrowserRouter as Router } from "react-router-dom";
import { useTranslation } from 'react-i18next';
import { isMobileOnly } from "react-device-detect";
import { QueryClient, QueryClientProvider } from 'react-query';
import useScreenOrientation from "./Utility/screenOrientation";

import "./App.scss";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 0,
      refetchOnWindowFocus: false,
    },
  },
});

function App() {
  const { t } = useTranslation();
  const urlMaps = `https://maps.googleapis.com/maps/api/js?key=${process.env.REACT_APP_GOOGLE_API_KEY}&libraries=places`;
  const orientation = useScreenOrientation();

  return (
    <QueryClientProvider client={queryClient}>
      <HelmetProvider>
        <Helmet>
          <title>{t('ATLAS de la résilience productive')}</title>
          {process.env.REACT_APP_USE_GOOGLE_API === "true" ? (
            <script src={urlMaps} />
          ) : null}
        </Helmet>
        <ErrorBoundary>
          <div className={`App ${isMobileOnly && "MobileOnly"} ${orientation}`}>
            <Router>
              <MainRouter />
            </Router>
          </div>
        </ErrorBoundary>
      </HelmetProvider>
    </QueryClientProvider>
  );
}

export default App;
