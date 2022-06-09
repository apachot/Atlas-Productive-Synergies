import React from "react";
import { cleanup, render } from "@testing-library/react";

import Navigation from "../components/Navigation";
require("jest-extended");

// Note: running cleanup afterEach is done automatically for you in @testing-library/react@9.0.0 or higher
// unmount and cleanup DOM after the test is finished.
afterEach(cleanup);

test("Navigation sans param", () => {
  const { getAllByRole, getByText } = render(
    <Navigation
      navigation={"produits"}
      regionId={84}
      territoireId={undefined}
      etablissement={undefined}
      produitId={undefined}
    />
  );
  const links = getAllByRole("link");
  const produitLink = getByText("Produits").closest("a");
  const produitLinkDiv = getByText("Produits").closest("a > div");
  expect(links.length).toBeNumber(5);
  expect(produitLink).toHaveAttribute(
    "href",
    `${process.env.REACT_APP_BASE_URL}produits/84`
  );
  expect(produitLinkDiv.className).toMatch(/border-blue-400/);

  expect(getByText("Métiers").closest("a")).toHaveAttribute(
    "href",
    `${process.env.REACT_APP_BASE_URL}metiers/84`
  );
  expect(getByText("Établissements").closest("a")).toHaveAttribute(
    "href",
    `${process.env.REACT_APP_BASE_URL}etablissements/84`
  );
});
