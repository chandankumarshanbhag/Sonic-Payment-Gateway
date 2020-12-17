import React from "react"
import noImg from "../../assets/img/noimg.png"

export default class Img extends React.Component{
    render(){
        return <img {...this.props} onError={({ target }) => {
            target.src = noImg;
        }} />
    }
}