/**
 * Carte nationnale découpée en région ou TI
 */
import React, { useEffect, useRef, useState } from "react";
import { UncontrolledReactSVGPanZoom } from "react-svg-pan-zoom";
import { Zoom } from "./GraphUtils";
import paysMap from "./paysMap";
import PaysLegende from "./paysLegende";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "../redux/store";
import { useHistory } from "react-router";
import AutoSizer from "react-virtualized-auto-sizer";
import { Tooltip, RefTooltip } from "./Utils";


const Pays = ({ mode }: { mode: 'regions' | 'territoire' | 'EPCI' }) => {
  const dispatch = useDispatch();
  const history = useHistory();
  const { regions, territoires, epci } = useSelector(
    (state: RootState) => state.data
  );
  const data = (mode === 'regions' ? regions : (mode === 'territoire' ? territoires : epci));
  const viewerRef = useRef<UncontrolledReactSVGPanZoom>(null);
  const refTooltip = useRef<RefTooltip>(null)
  const [doRefresh, setDoRefresh] = useState<boolean>(true)
  useEffect(() => {
    setTimeout(() => {
      viewerRef && viewerRef.current?.fitToViewer("center", "center");
    }, 0);
  }, [mode, doRefresh]);

  return (
    <div className="Pays">
      <AutoSizer onResize={() => setDoRefresh(!doRefresh)}>
        {({ height, width }) => (
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
            {paysMap({ data, mode, refTooltip, history, dispatch })}
          </UncontrolledReactSVGPanZoom>
        )}
      </AutoSizer>
      <Zoom viewerRef={viewerRef} />
      { (mode === "territoire" || mode === "EPCI") ? <Tooltip ref={refTooltip} /> : null }
      <PaysLegende />
    </div>
  );
};

export default Pays;
