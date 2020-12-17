import React,{Component} from "react"
import {Link} from "react-router-dom"
import {withRouter} from "react-router-dom"
import {checkLogin} from "../../firebase/login"

class Dash extends Component{
    render(){
        return <>
        <h1>dashboard</h1>
        <ul>
            <Link to="/createaccount"><li><button>Create account</button></li></Link>
            <Link to="/addamount"><li><button>Add amount</button></li></Link>
        </ul>
        </>
    }
}

export default Dash;