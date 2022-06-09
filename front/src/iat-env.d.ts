import 'leaflet'
import { LayerOptions } from "leaflet";

type OriginAndDestinationFieldIds = {
    originUniqueIdField: string,
    originGeometry: {
        x: string,
        y: string
    },
    destinationUniqueIdField: string,
    destinationGeometry: {
        x: string,
        y: sring
    }
}

type CanvasBezierStyle = {
    type?: string,
    symbol: {
        // use canvas styling options (compare to CircleMarker styling below)
        // strokeStyle: string,
        [key:string] : any,
    },
}

declare module 'leaflet' {
    export function canvasFlowmapLayer(geojson?: geojson.GeoJsonObject, options?: {
        originAndDestinationFieldIds: OriginAndDestinationFieldIds,
        style?: function,
        canvasBezierStyle?: CanvasBezierStyle,
        animatedCanvasBezierStyle?: any,
        pathDisplayMode?:'selection'|'all',
        wrapAroundCanvas?:boolean,
        animationStarted?:boolean,
        animationDuration?:number,
        animationEasingFamily?:string,
        animationEasingType?:string
    }) : CanvasFlow 
export interface IatLayerOptions extends LayerOptions {
    id?: string
    customId?: number
    workforceGroup?: string
    effectif?: number
    isVisible?: boolean
}
export interface IatCircleMarkerOptions extends CircleMarkerOptions {
    customId?: number
    workforceGroup?: string
    effectif?: number
    isVisible?: boolean
}
export interface Layer {
    public options: IatLayerOptions
    getLatLng(): LatLng
    setRadius(raduis: number): this
}
export function circle(latlng: LatLngExpression, options?: IatCircleMarkerOptions): Circle;
}

declare module 'react-svg-pan-zoom' {
    export interface UncontrolledReactSVGPanZoom {
        fitToViewer(SVGAlignX:'left' | 'center' |'right', SVGAlignY: 'top' | 'center' | 'bottom'): void;
    }
}