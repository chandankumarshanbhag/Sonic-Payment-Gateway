import React from "react"
import firebase from "firebase"
import noImg from "../../assets/img/noimg.png"
const input = React.createRef()

class Document extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            img: "",
            url: ""
        }
        this.getValue = this.getValue.bind(this)
        this.setValue = this.setValue.bind(this)
    }
    componentDidMount() {
        if (this.props.img) {
            firebase.app().storage().ref().child(this.props.img).getDownloadURL()
                .then((url) => {
                    this.setState({ url })
                })
                .catch(() => {

                })
        }
    }
    getValue(){
        return this.state.url
    }
    setValue(v){
        this.setState({url: v})
    }
    render() {
        return <div style={{ backgroundColor: "rgba(200,200,200,.05)" }}>
            <img style={{objectFit: "contain"}} src={this.state.url} width="100%" height="200px" onError={({target}) => {
                target.src = noImg
            }} onClick={() => {
                input.current.click()
            }} />
            <input type="file" style={{ display: "none" }} ref={input} accept="image" onChange={({ target }) => {
                if (target.files[0]) {
                    let fileName = (new Date().valueOf()) + target.files[0].name
                    let task = firebase.app().storage().ref().child("/" + fileName).put(target.files[0])
                    task.on('state_changed', () => {

                    }, () => {

                    }, () => {
                        task.snapshot.ref.getDownloadURL().then((url) => {
                            this.setState({ url })
                            if(this.props.onChange){
                                this.props.onChange(url)
                            }
                        });
                    })
                }
            }} />
        </div>
    }
}

export default Document