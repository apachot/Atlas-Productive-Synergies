import React from "react";
import { Trans } from 'react-i18next';

export default class ErrorBoundary extends React.Component {
  state = {
    error: undefined,
  };

  static getDerivedStateFromError(error:any) {
    return { error: error };
  }
  componentDidCatch(error: any, errorInfo: any) {
    this.setState({ error: { error, errorInfo } });
  }
  render() {
    if (this.state.error) {
      return (
        <div className="p-16 text-center text-2xl">
          <Trans>Une erreur est survenue.</Trans>
        </div>
      );
    }
    return this.props.children;
  }
}
