import { Trans } from "react-i18next";
import { LEGEND } from "../maps/france/france_regions";
import './paysLegende.scss';
const PaysLegende = () => {
    return (
        <div className={"PaysLegende"} >
            <div className="Legende">
                <p className={"Title"}><Trans>Index de Résilience</Trans></p>
                <div className={"Graphs"}>
                    {LEGEND.map((e) => {
                        return (
                            <div key={e.min} className={"Graph"} >
                                <svg
                                    viewBox="0 0 120 120"
                                    className={"Circle"}
                                >
                                    <circle
                                        fill={e.attrs.fill}
                                        cx="60"
                                        cy="60"
                                        r="50"
                                    />
                                </svg>
                                <span className={"Text"}>{e.label}</span>
                            </div>
                        );
                    })}
                </div>
            </div>
        </div>
    )
}

export default PaysLegende;