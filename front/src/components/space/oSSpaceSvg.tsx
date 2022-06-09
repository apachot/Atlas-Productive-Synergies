import { ProductSpaceFormat } from "../../Utils";
import { getI18n } from "react-i18next";
import { RefTooltip } from "../Utils";

type EdgesProps = {
    p: ProductSpaceFormat,
    idSelected?: string,
    idOvered?: string,
}
const Edges = ({ p, idSelected, idOvered }: EdgesProps) => {
    return <>
        {p.edge.map(l => (
            <line
                key={`line-${p.id}-${l.id}`}
                x1={p.position.x}
                y1={p.position.y}
                x2={l.x}
                y2={l.y}
                className={idSelected ? (
                    p.id === idSelected ? 'edge-Overred' : 'edge-standard'
                ) : (
                    p.id === idOvered ? 'edge-Overred' : 'edge-standard'
                )}
            />
        ))}
    </>
}

type NodeProps = {
    p: ProductSpaceFormat,
    setOvered: (id?: string) => void,
    setSelected: (id?: string) => void,
    refTooltip: React.RefObject<RefTooltip>,
    secteurs?: string[]
}
const Node = ({ 
    p, 
    setOvered,
    setSelected,
    refTooltip,
    secteurs,
}: NodeProps) => {
    
    const selected = (secteurs && secteurs.filter(value => p.secteurs.includes(value.toString())).length>0) || !secteurs

    const className = (!selected ? 'node-not-selected' : (!p.active ? 'node-inactive' : "node-standard" )) + ' node'

    return (
        <circle
            cx={p.position.x}
            cy={p.position.y}
            r={p.radius}
            fill={ p.color}
            className={className}
            onDoubleClick={(e) => {e.stopPropagation()}}
            onMouseEnter={() => setOvered(p.id)}
            onMouseLeave={() => setOvered(undefined)}
            onClick={() => setSelected(p.id)}
            onTouchEnd={() => setSelected(p.id)}
            onMouseMove={(e: React.MouseEvent<SVGPathElement>) => {
                refTooltip.current?.show(
                    e,
                    (
                        <div className=" ">
                            <div className="tooltip-header">{p.id}</div>
                            <div>{p.lib[getI18n().language]}</div>
                        </div>
                    )
                )}
            }
            onMouseOut={(e) => refTooltip.current?.hide()}
        />
    )
}

type Params = {
    data: ProductSpaceFormat[],
    setOvered: (id?: string) => void,
    idOvered?: string,
    setSelected: (id?: string) => void,
    idSelected?: string,
    refTooltip: React.RefObject<RefTooltip>,
    secteurs?: string[],
    box:{left: number, top: number, width: number, height: number}
}

export const rawSpace = ({
    data,
    setOvered,
    idOvered,
    setSelected,
    idSelected,
    refTooltip,
    secteurs,
    box,
}: Params) => {
    return (
        <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox={`${box.left} ${box.top} ${box.width} ${box.height}`}
        >
            <rect
                x={931}
                y={1632}
                width={2004}
                height={1366}
                fillOpacity={0}
                onClick={() => setSelected(undefined)}
                onTouchEnd={() => setSelected(undefined)}
                onDoubleClick={(e) => {e.stopPropagation()}}
            />
            {data.map(c => <Edges p={c} idOvered={idOvered} idSelected={idSelected} key={`edge-${c.id}`} />)}
            {data.map(c => (
                <Node
                    key={`circle-${c.id}`}
                    p={c}
                    refTooltip={refTooltip}
                    setOvered={setOvered}
                    setSelected={setSelected}
                    secteurs={secteurs}
               />
            ))}
        </svg>
    )
}