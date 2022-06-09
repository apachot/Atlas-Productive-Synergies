import { LoremIpsum } from "lorem-ipsum";

import {
  parsePourcentage,
  isHighlighted,
  isInFilter,
  computeMarkerSize,
  needAbbr,
} from "../Utils";
require("jest-extended");

describe("parsePourcentage", () => {
  test("Pourcentage", () => {
    expect(parsePourcentage(0.121284, 4)).toBe(12.1284);
    expect(parsePourcentage(0.121284, 2)).toBe(12.13);
    expect(parsePourcentage(0.121284)).toBe(12);
  });
});

describe("isHighlighted", () => {
  test("isHighlighted", () => {
    expect(isHighlighted("", [])).toBe(false);
    expect(isHighlighted("", [undefined, undefined, "123"])).toBe(false);
    expect(isHighlighted("0102", ["01", "02", "01023"])).toBe(false);
    expect(isHighlighted("0101", ["0101"])).toBe(true);
    expect(isHighlighted("8956", ["0", "", "8956"])).toBe(true);
    expect(isHighlighted("8956", undefined)).toBe(true);
  });
});

describe("isInFilter", () => {
  test("isInFilter", () => {
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "NN", "12"], value: 1 },
        [],
        []
      )
    ).toBe(false);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "NN", "12"], value: 1 },
        [1, 2, 3],
        [4, 5]
      )
    ).toBe(false);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "NN", "12"], value: 1 },
        [1, 2, 3, 9],
        [4, 5]
      )
    ).toBe(false);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "NN", "01", "12"], value: 1 },
        [1, 2, 3, 9],
        [1, 4, 5]
      )
    ).toBe(true);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "NN", "01", "12"], value: 0 },
        [1, 2, 3, 9],
        [1, 4, 5]
      )
    ).toBe(true);
    expect(
      isInFilter(
        { secteur: 8, workforces: ["00", "NN", "01", "12"], value: 1 },
        [1, 2, 3, 9],
        [1, 4, 5]
      )
    ).toBe(false);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "NN", "26", "52", "72"], value: 1 },
        [1, 2, 3, 9],
        [1, 4, 5]
      )
    ).toBe(false);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "NN", "26", "52", "72"], value: 0 },
        [1, 2, 3, 9],
        [1, 4, 5]
      )
    ).toBe(true);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["NN", "26", "52", "72"], value: 1 },
        [1, 2, 3, 9],
        [0, 4, 5]
      )
    ).toBe(true);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "26", "52", "72"], value: 1 },
        [1, 2, 3, 9],
        [0, 4, 5]
      )
    ).toBe(true);
    expect(
      isInFilter(
        { secteur: 9, workforces: ["00", "NN", "12", "41"], value: 1 },
        [1, 2, 3],
        [4, 5]
      )
    ).toBe(false);
  });
});

describe("computeMarkerSize", () => {
  test("computeMarkerSize", () => {
    expect(computeMarkerSize(1, 0, [4, 5])).toBeNumber();
    expect(computeMarkerSize(10, 4, [4, 5])).toBeNumber();
    expect(computeMarkerSize(10, 4, [])).toBeNumber();
    expect(computeMarkerSize(10, 4, undefined)).toBeNumber();
    const nanTest = computeMarkerSize(10, undefined, undefined);
    expect(nanTest).toBeNumber();
    expect(nanTest).not.toBeNaN();
  });
});

describe("needAbbr", () => {
  test("Gestion des abbréviations", () => {
    const lorem = new LoremIpsum({
      sentencesPerParagraph: {
        max: 8,
        min: 4,
      },
      wordsPerSentence: {
        max: 16,
        min: 4,
      },
    });
    const smallText = lorem.generateWords(1);
    const smallTextTooltip = needAbbr(smallText);
    const longText = lorem.generateParagraphs(1);
    const longTextTooltip = needAbbr(longText);
    const customTextTooltip = needAbbr("Test", 2);
    expect(smallTextTooltip.needAbbr).toBe(false);
    expect(longTextTooltip.needAbbr).toBe(true);
    expect(customTextTooltip.needAbbr).toBe(true);
    expect(smallTextTooltip.tooltipText).toBe("");
    expect(longTextTooltip.tooltipText).toBe(longText);
    expect(customTextTooltip.tooltipText).toBe("Test");
    expect(smallTextTooltip.displayText).toBe(smallText);
    expect(customTextTooltip.displayText).toBe("Te(...)");
    expect(longTextTooltip.displayText).not.toBe(longText);
    expect(longTextTooltip.displayText.substr(-5)).toBe("(...)");
  });
});
