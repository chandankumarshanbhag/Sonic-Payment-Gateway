import React, { Component, createRef } from "react"
import { Container, Card, CardBody, Row, Col, Table, CardHeader } from "reactstrap"
import { withRouter } from "react-router-dom"

import firebase from "../../firebase"
import Header from "../../components/Headers/Header.jsx";

import Document from "../../components/Document/Document"
import Img from "../../components/Img/Img"
import { checkLogin } from "../../firebase/login"

import swal from "sweetalert"

const name = createRef()
const username = createRef()
const password = createRef()
const photo = createRef()

class AddBankStaff extends Component {
    constructor(props) {
        super(props)
        this.state = {
            accounts: []
        }
        this.createAccount = this.createAccount.bind(this)
        this.updateAccountsList = this.updateAccountsList.bind(this)
        this.deleteAccount = this.deleteAccount.bind(this)
        this.changePassword = this.changePassword.bind(this)
    }
    componentDidMount() {
        if (!checkLogin()) {
            this.props.history.push("/auth/login")
        }
        this.updateAccountsList()
    }
    updateAccountsList() {
        firebase.firestore().collection("bankStaffs").get()
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
        let flag = false;
        this.state.accounts.forEach(x => {
            if (x.username == username.current.value) {
                flag = true
                swal("Error", "Username already exist", "error")
            }
        })
        
        if(name.current.value==""){
            swal("Error", "Please enter the name.", "error")
        }
        else if(username.current.value.length<5){
            swal("Error", "Username must contain at least 5 characters", "error")
        }
        else if(password.current.value.length<5){
            swal("Error", "Password must contain at least 5 characters", "error")
        }
        else if(photo.current.getValue()==""){
            swal("Error", "Please select the photo.", "error")
        }
        else if (!flag) {
            firebase.firestore().collection("bankStaffs").add({
                name: name.current.value,
                username: username.current.value,
                password: password.current.value,

                photo: photo.current.getValue(),
                date: new Date()
            })
                .then(() => {
                    this.updateAccountsList()
                    swal("success", "Successfully Added", "success")
                })
                .catch(() => {
                    swal("error", "Error", "error")
                })
        }

    }
    deleteAccount(x) {
        firebase.firestore().collection("bankStaffs").doc(x.key)
            .delete()
            .then(() => {
                swal("success", "deleted", "success")
                this.updateAccountsList()
            })
            .catch(() => {
                swal("error", "Error", "error")
            })
    }
    changePassword(x, password) {
        firebase.firestore().collection("bankStaffs").doc(x.key)
            .get()
            .then((snapshot) => {
                if (snapshot.exists) {
                    snapshot.ref.set({
                        ...snapshot.data(),
                        password
                    }).then(() => {
                        swal("success", "Password changed successfuly", "success")
                    }).catch(() => {
                        swal("error", "Something went wrong", "success")
                    })
                }
            })
            .catch(() => {
                swal("error", "Error", "error")
            })
    }
    render() {
        return <>
            <Header />
            <Container className="mt--8" fluid>
                <Card>
                    <CardHeader>
                        <h3>Create Bank Staff Account</h3>
                    </CardHeader>
                    <CardBody>
                        <form onSubmit={this.createAccount}>
                            <Row>
                                <Col md={4}>
                                    <label>Name </label>
                                    <input className="form-control" type="text" ref={name}></input>
                                </Col>
                                <Col md={3}>
                                    <label>Username </label>
                                    <input className="form-control" type="text" ref={username}></input>
                                </Col>
                                <Col md={3}>
                                    <label>Password </label>
                                    <input className="form-control" type="password" ref={password}></input>
                                </Col>

                                <Col md={2}>
                                    <label>Photo </label>
                                    <Document ref={photo} />
                                </Col>
                            </Row>

                            <input type="submit" className="btn btn-primary mt-2"></input>
                        </form>

                        <br />

                        <Table className="align-items-center" responsive>
                            <thead>
                                <tr>
                                    <th>Photo</th>
                                    <th>Name</th>
                                    <th>Username</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            {this.state.accounts.map((x, key) => {
                                return <tr key={key}>
                                    <td><Img src={x.photo} width="50px" height="50px" style={{ objectFit: "cover", borderRadius: "50%" }} /></td>

                                    <td>{x.name}</td>
                                    <td>{x.username}</td>
                                    <td>{x.date.toDate().toLocaleString("en-gb")}</td>
                                    <td>
                                        {x.username == "admin" ? <></> : <>
                                            <button className="btn btn-secondary btn-sm" onClick={() => {
                                                let v = ""
                                                if (v = window.prompt("Enter new password")) {
                                                    this.changePassword(x, v)
                                                }
                                            }}>Edit password</button>
                                            <button className="btn btn-secondary btn-sm" onClick={() => {
                                                if (window.confirm("Are you sure")) {
                                                    this.deleteAccount(x)
                                                }
                                            }}>Delete</button>
                                        </>}
                                    </td>


                                </tr>
                            })}
                        </Table>
                    </CardBody>
                </Card>
            </Container>
        </>
    }
}

export default AddBankStaff;