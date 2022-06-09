import React from "react";
import { cleanup, render, configure } from "@testing-library/react";
import Filtres from "../components/Filtres";

// Note: running cleanup afterEach is done automatically for you in @testing-library/react@9.0.0 or higher
// unmount and cleanup DOM after the test is finished.
afterEach(cleanup);

configure({
  testIdAttribute: "data-filtre",
});

test("Filtres", () => {
  const { getByTestId } = render(
    <Filtres
      secteurs={[1, 2]}
      setSecteurs={() => {}}
      secteursFiltrable={[1, 2, 3]}
      effectifs={[1, 3]}
      setEffectifs={() => {}}
      effectifsFiltrable={[1, 2, 3]}
    />
  );

  const s1 = getByTestId("secteur-1");
  const s2 = getByTestId("secteur-2");
  const s3 = getByTestId("secteur-3");
  const s4 = getByTestId("secteur-4");
  const e1 = getByTestId("effectif-1");
  const e2 = getByTestId("effectif-2");
  const e3 = getByTestId("effectif-3");
  const e4 = getByTestId("effectif-4");
  expect(s1).toHaveClass("active");
  expect(s1).not.toHaveClass("inactive");
  expect(s1).not.toHaveClass("disabled");
  expect(e1).toHaveClass("active");
  expect(e1).not.toHaveClass("disabled");
  expect(e1).not.toHaveClass("inactive");

  expect(s2).toHaveClass("active");
  expect(s2).not.toHaveClass("inactive");
  expect(s2).not.toHaveClass("disabled");
  expect(e2).toHaveClass("inactive");
  expect(e2).not.toHaveClass("disabled");
  expect(e2).not.toHaveClass("active");

  expect(s3).toHaveClass("inactive");
  expect(s3).not.toHaveClass("active");
  expect(s3).not.toHaveClass("disabled");
  expect(e3).toHaveClass("active");
  expect(e3).not.toHaveClass("disabled");
  expect(e3).not.toHaveClass("inactive");

  expect(s4).toHaveClass("inactive");
  expect(s4).not.toHaveClass("active");
  expect(s4).toHaveClass("disabled");
  expect(e4).toHaveClass("inactive");
  expect(e4).toHaveClass("disabled");
  expect(e4).not.toHaveClass("active");
});
