import { ProduitProximiteType } from "../api/Produits";

export const productEqualizer = (
    product: ProduitProximiteType,
    advantage: number,
    green: number,
    maslow: number,
    pci: number,
    resilience: number
): ProduitProximiteType => {
    const result: ProduitProximiteType = { ...product }
    /* do the equalization with factor */
    if (advantage > 0 || green > 0 || maslow > 0 || pci > 0 || resilience > 0) {
        const totPcent = advantage + green + maslow + pci + resilience;
        const taux = totPcent >= 100 ? 2.5 : (100 - totPcent);
        result.proximities = result.proximities.map(element => {
            const { proximity, advantage_norm = 0, green_norm = 0, maslow_norm = 0, pci_norm = 0, resilience_norm = 0 } = element;
            const prox = (
                (proximity * taux / 100) +
                (advantage_norm * advantage / 100) +
                (green_norm * green / 100) +
                (maslow_norm * maslow / 100) +
                (pci_norm * pci / 100) +
                (resilience_norm * resilience / 100)
            );
            return { ...element, proximity: prox }
        });
    }

    /* get only the first five for lvl1 */
    const lvl1_raw = result.proximities
        .filter(a => a.level === 1)
        .sort((a, b) => b.proximity - a.proximity)
        .slice(0, 5)

    /* normalize result */
    const lvl1 = function () {
        const minProximityLvl1 = lvl1_raw.length>0 ? lvl1_raw
            .reduce((prev, curr) => prev.proximity < curr.proximity ? prev : curr).proximity : 0;
        const maxProximityLvl1 = lvl1_raw.length>0 ? lvl1_raw
            .reduce((prev, curr) => prev.proximity > curr.proximity ? prev : curr).proximity : 0;
        if ((maxProximityLvl1 - minProximityLvl1) > 0.001) {
            return lvl1_raw.map(res => {
                return {
                    ...res,
                    proximity: ((res.proximity - minProximityLvl1) / (maxProximityLvl1 - minProximityLvl1)) * 0.6 + 0.20
                }
            })
        }
        return lvl1_raw
    }()

    /* get the lvl2 with link to lvl1 */
    const lvl2 = result.proximities
        .filter(a => a.level === 2)
        .filter(a => lvl1.some(item => a.parents.includes(item.code_hs4)))
        .sort((a, b) => b.proximity - a.proximity)

    const maxProximity = lvl2.length>0 ? lvl2
        .reduce((prev, curr) => prev.proximity > curr.proximity ? prev : curr).proximity : 0;


    result.proximities = [...lvl1, ...lvl2.map(a => { a.proximity = maxProximity - a.proximity; return a })]
    return result
}
