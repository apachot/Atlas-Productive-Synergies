import { UncontrolledReactSVGPanZoom } from "react-svg-pan-zoom";
import './GraphUtils.scss';

export const Zoom = ({ viewerRef }: { viewerRef: React.RefObject<UncontrolledReactSVGPanZoom> }) => {
    return (
        <div className="Zoom">
            <div className="In"
                onClick={() => { viewerRef.current?.zoomOnViewerCenter(1.1); }}
            >
                +
            </div>
            <div
                className="Out"
                onClick={() => { viewerRef.current?.zoomOnViewerCenter(0.9); }}
            >
                -
            </div>
        </div>
    );
};
