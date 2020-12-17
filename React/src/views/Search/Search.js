import React, { Component, createRef } from "react"
import { Container, Card, CardBody, Row, Col, Table } from "reactstrap"
import { withRouter } from "react-router-dom"

import firebase from "../../firebase"
import Header from "../../components/Headers/Header.jsx";
import Img from "../../components/Img/Img"
import { checkLogin } from '../../firebase/login';
import swal from "sweetalert";

const userId = createRef()
const userName = createRef()
const accountNo = createRef()
// define
const mobileNo = createRef()
const pin = createRef()


class Accounts extends Component {
    constructor(props) {
        super(props)
        this.state = {
            accounts: [],
            result: [],
            search: ""
        }
        this.updateAccountsList = this.updateAccountsList.bind(this)
    }
    componentDidMount() {
        if (!checkLogin()) {
            this.props.history.push("/auth/login")
        }
        this.updateAccountsList()
    }
    updateAccountsList() {
        firebase.firestore().collection("accounts").get()
            .then((accounts) => {
                console.log(accounts)
                let temp = []
                accounts.docs.forEach((x) => {
                    temp.push({ ...x.data(), key: x.id })
                })
                this.setState({ accounts: temp,result: temp })
            })
            .catch(() => {

            })
    }
    searchChange(qry) {
        qry = qry.toUpperCase();
        if(qry==""){
            this.setState({result: this.state.accounts});
        }
        else{
            this.setState({result: this.state.accounts.filter(x => {
                return x.name.startsWith(qry) || x.accountNo.toString().startsWith(qry)||x.mobileNo.toString().startsWith(qry)||x.pin.toString().startsWith(qry)||x.amount.toString().startsWith(qry)
            })})
        }
    }
    render() {
        return <>
            <Header />
            <Container className="mt--8" fluid>
                <Card>
                    <CardBody>
                        <input placeholder="Search" className="form-control form-control-alternative" type="text" onChange={({ target: { value } }) => {
                            this.searchChange(value);
                        }}></input>
                        <br /><br />
                        <Table className="align-items-center" responsive>
                            <thead>
                                <tr>
                                    <th>Photo</th>
                                    <th>userName</th>
                                    <th>Account No.</th>
                                    <th>Mobile No.</th>
                                    <th>pin</th>

                                    <th>Actions</th>
                                </tr>
                            </thead>
                            {this.state.result.map((x, key) => {
                                return <tr key={key}>
                                    <td><Img src={x.photo} width="50px" height="50px" style={{ objectFit: "cover", borderRadius: "50%" }} /></td>
                                    <td>{x.name}</td>
                                    <td>{x.accountNo}</td>
                                    <td>{x.mobileNo}</td>
                                    <td>{x.pin}</td>



                                    <td><button onClick={() => {
                                        this.props.history.push("/admin/account/"+x.key)
                                    }} className="btn btn-sm btn-secondary">View</button></td>
                                </tr>
                            })}
                        </Table>
                    </CardBody>
                </Card>
            </Container>
        </>
    }
}

export default withRouter(Accounts);