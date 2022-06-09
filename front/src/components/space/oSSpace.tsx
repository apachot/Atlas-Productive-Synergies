import { ProductSpaceFormat } from "../../Utils";
import AutoSizer from "react-virtualized-auto-sizer";
import { UncontrolledReactSVGPanZoom } from "react-svg-pan-zoom";
import { forwardRef, Ref, useEffect, useImperativeHandle, useRef, useState } from "react";
import Loader from "../loader";
import { Zoom } from "../GraphUtils";
import './oSSpace.scss'
import { rawSpace } from "./oSSpaceSvg";
import { RefTooltip, Tooltip } from "../Utils";
import { isMobileOnly } from "react-device-detect";


type Props = {
    data: ProductSpaceFormat[]
    onNodeClick?: (id?: string) => void,
    selected?:string,
    secteurs?:string[]
    box:{left: number, top: number, width: number, height: number}
}

export type RefOSSpace = {
    forceRefresh: () => void
  }

const OSSpace = forwardRef((props: Props, ref:Ref<RefOSSpace>) => {
    const {
        data,
        onNodeClick,
        selected,
        secteurs,
        box,
    } = props;
    useImperativeHandle(ref, () => ({
        forceRefresh: () => setDoRefresh(!doRefresh)
    }))
    const [doRefresh, setDoRefresh] = useState(true);
    const viewerRef = useRef<UncontrolledReactSVGPanZoom>(null);
    const refTooltip = useRef<RefTooltip>(null)
    const [idOvered, setIdOvered] = useState<string>()
    const [idSelected, setIdSelected] = useState<string>()
    const setOvered = (id?: string) => {
        setIdOvered(id)
    }
    const setSelected = (id?: string) => {
        setIdSelected(id)
        onNodeClick && onNodeClick(id) ;
    }

    useEffect(() => {
        setTimeout(() => {
            if (isMobileOnly) {
                viewerRef && viewerRef.current?.fitToViewer("center", "center");
                viewerRef && viewerRef.current?.zoomOnViewerCenter(2.5);
            } else {
                viewerRef && viewerRef.current?.fitToViewer("center", "center");
            }
        }, 0);
    }, [doRefresh])

    useEffect(()=>{
        setIdSelected(selected)
    }, [selected])

    return (
        <div className="OSSpace">
            {data.length > 0 ? (
                <AutoSizer onResize={() => setDoRefresh(!doRefresh)}>
                    {({ height, width }) => ((height>0 && width>0) ?
                        <UncontrolledReactSVGPanZoom
                            className={"svgpanzoom"}
                            ref={viewerRef}
                            width={width}
                            height={height}
                            tool="auto"
                            detectAutoPan={false}
                            background={"#f5f5f5"}
                            toolbarProps={{ position: "none" }}
                            scaleFactorMax={4.2}
                            preventPanOutside={true}
                            miniatureProps={{
                                position: "none",
                                height: 0,
                                width: 0,
                                background: ""
                            }}
                        >
                            {rawSpace({
                                data,
                                idOvered,
                                idSelected,
                                setOvered,
                                setSelected,
                                refTooltip,
                                secteurs,
                                box,
                            })}
                        </UncontrolledReactSVGPanZoom>:null)}
                </AutoSizer>
            ) : (
                <AutoSizer>
                    {({ height, width }) => (
                        <div
                            className={"Loader"}
                            style={{
                                width: width,
                                height: height,
                            }}
                        >
                            <Loader />
                        </div>)}
                </AutoSizer>
            )}
            <Zoom viewerRef={viewerRef} />
            <Tooltip ref={refTooltip} />
        </div>
    )
});

export default OSSpace;