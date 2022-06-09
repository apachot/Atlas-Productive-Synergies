import React from "react";
import { render, screen } from "@testing-library/react";

import Credits from "../components/Credits";

describe("App", () => {
  test("Credits component", () => {
    render(<Credits />);

    expect(screen.getByText("UCA.svg")).toBeInTheDocument();
    expect(screen.getByText("OS.svg")).toBeInTheDocument();
  });
});
