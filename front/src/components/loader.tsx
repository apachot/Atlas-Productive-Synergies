import { ReactComponent as Wait } from "../svgs/loader.svg";
const Loader = ({width = 80, height = 80}: {width?: number, height?: number}) => {
    return (
    <Wait width={width}
        height={height}
        style={{
            margin: "auto",
        }}
        />        
    )
}

export default Loader