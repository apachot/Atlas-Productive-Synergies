import { forwardRef, Ref, useImperativeHandle, useRef, useState } from 'react';
import './Utils.scss' ;
/**
 * Gestion du rendu des Tooltips
 */
export type RefTooltip = {
    show: (evt: React.MouseEvent<any>, child: JSX.Element, id?: string) => void ;
    hide : (id?: string) => void ;
}
type Props = {}
export const Tooltip= forwardRef((props: Props , ref:Ref<RefTooltip>) => { 
    const [data, setData] = useState<JSX.Element>() ;
    const [visible, setVisible] = useState<boolean>(false) ;
    const [left, setLeft] = useState<number>(0) ;
    const [top, setTop] = useState<number>(0) ;
    const refTooltip = useRef<HTMLDivElement>(null)

    useImperativeHandle(ref, () => ({
        show: (evt: React.MouseEvent<any>, child: JSX.Element, id?: string) => {
            if (!refTooltip.current) return;
            setData(child) ;
            setVisible(true) ;
            setLeft((evt.target as Element).getBoundingClientRect().x +
            (evt.target as Element).getBoundingClientRect().width / 2 -
            refTooltip.current.clientWidth / 2) ;
            setTop ((evt.target as Element).getBoundingClientRect().y +
            (evt.target as Element).getBoundingClientRect().height / 2 -
            refTooltip.current.clientHeight -
            80);
            if (!id) return ;
            const path = document.getElementById(id);
            if (!path) {
                return
            }
            path.setAttribute("stroke", "#ff0000");
            path.setAttribute("stroke-width", "3");
        },
        hide : (id?: string) => {
            setVisible(false) ;
            if (!id) return ;
            const path = document.getElementById(id);
            if (!path) {
                return;
            }
            path.setAttribute("stroke", "#b1afaf");
            path.setAttribute("stroke-width", "1");
        }
    }))    
    return (
        <div ref={refTooltip} className={`Tooltip ${visible?'show':'hide'}`} style={{left, top}}>
            {data}
        </div>
    )
}) ;
