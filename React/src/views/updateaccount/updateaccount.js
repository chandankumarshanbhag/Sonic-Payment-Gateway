import React, { Component, createRef } from "react"
import { Container, Card, CardBody, Row,Col,Table } from "reactstrap"
import {withRouter} from "react-router-dom"

import firebase from "../../firebase"
import Header from "../../components/Headers/Header.jsx";
import Img from "../../components/Img/Img"
import {checkLogin} from "../../firebase/login"
import swal from "sweetalert"

const userId = createRef()
const userName=createRef()
const accountNo = createRef()
// define
const mobileNo = createRef()
const pin=createRef()


class AddAmount extends Component {
    constructor(props) {
        super(props)
        this.state = {
            accounts: []
        }
        this.createAccount = this.createAccount.bind(this)
        this.updateAccountsList = this.updateAccountsList.bind(this)
        this.updateAccount = this.updateAccount.bind(this)
    }
    componentDidMount() {
        if(!checkLogin()){
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
                this.setState({ accounts: temp })
            })
            .catch(() => {

            })
    }
    createAccount(e) {
        e.persist()
        e.preventDefault();
        firebase.firestore().collection("accounts").add({
            userId: userId.current.value,
            userName:userName.current.value,
            accountNo: accountNo.current.value,

            mobileNo: mobileNo.current.value,
            pin: pin.current.value
        })
            .then(() => {
                this.updateAccountsList()
                swal("Success","Saved Successfully","success")
            })
            .catch(() => {
                swal("Error","Something went wrong","error")
            })
    }
    updateAccount(x) {
        console.log(x.key)
        this.props.history.push("/admin/updateaccountview/"+x.key)
    }
    render() {
        return <>
            <Header />
            <Container className="mt--8" fluid>
                <Card>
                    <CardBody>
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
                            {this.state.accounts.map((x, key) => {
                                return <tr key={key}>
                                     <td><Img src={x.photo} width="50px" height="50px" style={{ objectFit: "cover", borderRadius: "50%" }} /></td>
                                    <td>{x.name}</td>
                                    <td>{x.accountNo}</td>
                                    <td>{x.mobileNo}</td>
                                    <td>{x.pin}</td>



                                    <td><button onClick={() => {
                                        this.updateAccount(x)
                                    }} className="btn btn-sm btn-secondary">Update</button></td>
                                </tr>
                            })}
                        </Table>
                    </CardBody>
                </Card>
            </Container>
        </>
    }
}

export default withRouter(AddAmount);