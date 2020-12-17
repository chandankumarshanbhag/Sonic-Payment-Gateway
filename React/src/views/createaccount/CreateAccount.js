import React, { Component, createRef } from "react"
import { Container, Card, CardBody, Row, Col, Table, CardHeader } from "reactstrap"
import { withRouter } from "react-router-dom"

import firebase from "../../firebase"
import Header from "../../components/Headers/Header.jsx";

import Document from "../../components/Document/Document"
import Img from "../../components/Img/Img"

import NationalityList from "./nationality"
import { checkLogin } from "../../firebase/login"
import swal from "sweetalert";

const userId = createRef()
const name = createRef()
const gender = createRef()
const dob = createRef()
const maritialStatus = createRef()
const fatherName = createRef()
const spouseName = createRef()
const accountNo = createRef()
const address = createRef()
const email = createRef()
const aadharno = createRef()
const photo = createRef()


const city = createRef()
const pincode = createRef()
const nationality = createRef()
// define
const mobileNo = createRef()
const pin = createRef()
//const xyz=createRef()

class AddAmount extends Component {
    constructor(props) {
        super(props)
        this.state = {
            accounts: [],
            accountNo: 0,
            pin: Math.abs(parseInt(Math.random() * 10000))
        }
        this.createAccount = this.createAccount.bind(this)
        this.updateAccountsList = this.updateAccountsList.bind(this)
        this.deleteAccount = this.deleteAccount.bind(this)
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
                let lastAccNo = 0
                accounts.docs.forEach((x) => {
                    temp.push({ ...x.data(), key: x.id })
                    let accno = parseInt(x.data().accountNo)
                    if (lastAccNo < accno) {
                        lastAccNo = accno
                    }
                })
                this.setState({ accounts: temp, accountNo: (lastAccNo + 1).toString().padStart(5, "0") })
            })
            .catch(() => {

            })
    }
    createAccount(e) {
        e.persist()
        e.preventDefault();
        if (name.current.value.length < 3 || name.current.value.match(/\d/ig)) {
            swal("Error", "Invalid Name", "error")
        }
        else if (gender.current.value == "") {
            swal("Error", "Please select the gender", "error")
        }
        else if (dob.current.value == "") {
            swal("Error", "Please select Date Of birth", "error")
        }
        else if (dob.current.value == "") {
            swal("Error", "Please select Date Of birth", "error")
        }
        else if (isNaN(parseInt(mobileNo.current.value)) || mobileNo.current.value.length !=10) {
            swal("Error", "Please enter a valid Mobile No.", "error")
        }
        else if (!email.current.value.match(/^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i)) {
            swal("Error", "Please enter a valid Email Address", "error")
        }
        else if (isNaN(parseInt(aadharno.current.value)) || aadharno.current.value.length != 12) {
            swal("Error", "Please enter a valid Aadhar No.", "error")
        }
        else if (address.current.value.length < 6) {
            swal("Error", "Please enter a valid Address", "error")
        }
        else if (city.current.value.length < 3) {
            swal("Error", "Please enter a valid City", "error")
        }
        else if (pincode.current.value.length!=6) {
            swal("Error", "Please enter a Pincode", "error")
        }
        else if (fatherName.current.value.length < 3 || fatherName.current.value.match(/\d/ig)) {
            swal("Error", "Invalid Father Name", "error")
        }
        else if (maritialStatus.current.checked && (spouseName.current.value.length < 3 || spouseName.current.value.match(/\d/ig))) {
            swal("Error", "Invalid Spouse Name", "error")
        }
        else if (accountNo.current.value.length < 5) {
            swal("Error", "Invalid Account No.", "error")
        }
        else if (pin.current.value.length < 4) {
            swal("Error", "Invalid Account No.", "error")
        }
        else if (photo.current.getValue().length < 5) {
            swal("Error", "Please select the photo.", "error")
        }
        else {
            firebase.firestore().collection("accounts").add({
                name: name.current.value,
                gender: gender.current.value,
                dob: new Date(dob.current.value),
                mobileNo: mobileNo.current.value,
                email: email.current.value,
                aadharno: aadharno.current.value,
                nationality: nationality.current.value,
                address: address.current.value,
                city: city.current.value,
                pincode: pincode.current.value,
                maritialStatus: maritialStatus.current.checked,
                fatherName: fatherName.current.value,
                spouseName: spouseName.current.value,

                accountNo: accountNo.current.value,

                photo: photo.current.getValue(),

                pin: pin.current.value,
                //xyz: xyz.current.value,

                amount: 0,
                date: new Date(),
                transactions: []
            })
                .then(() => {
                    this.updateAccountsList()
                    swal("Success", "Successfully Added", "success")
                })
                .catch(() => {
                    swal("Error", "Something went wrong", "error")
                })
        }
    }
    deleteAccount(x) {
        firebase.firestore().collection("accounts").doc(x.key)
            .delete()
            .then(() => {
                swal("Success", "Account Deleted Successfully.", "success")
                this.updateAccountsList()
            })
            .catch(() => {
                swal("Error", "Something went wrong", "error")
            })
    }
    render() {
        return <>
            <Header />
            <Container className="mt--8" fluid>
                <Card>
                    <CardHeader>
                        <h3>Create Account</h3>
                    </CardHeader>
                    <CardBody>
                        <form onSubmit={this.createAccount}>
                            <Row>
                                <Col md={7}>
                                    <label>Name </label>
                                    <input className="form-control form-control-alternative" type="text" ref={name} onKeyDown={(e) => {
                                        e.persist();
                                        if (e.key.match(/[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]|[0-9]/ig)) {
                                            e.preventDefault();
                                        }
                                    }} onChange={({ target }) => {
                                        target.value = target.value.toUpperCase()
                                    }}></input>
                                </Col>
                                <Col md={2}>
                                    <label>Gender </label>
                                    <select className="form-control form-control-alternative" ref={gender} defaultValue={"Male"}>
                                        <option value="Male">Male</option>
                                        <option value="Female">Female</option>
                                    </select>
                                </Col>
                                <Col md={3}>
                                    <label>Date of birth </label>
                                    <input className="form-control form-control-alternative" type="date" ref={dob} max={new Date().toISOString().slice(0, 10)}></input>
                                </Col>
                                <Col md={4}>
                                    <label>Mobile No. </label>
                                    <input className="form-control form-control-alternative" type="number" onKeyDown={(e) => {
                                        e.persist();
                                        if (e.key.match(/[`!@#$%^&*()_\-=\[\]{};':"\\|,.<>\/?~]|e/ig)) {
                                            e.preventDefault();
                                        }
                                    }} ref={mobileNo}></input>
                                </Col>
                                <Col md={4}>
                                    <label>Email </label>
                                    <input className="form-control form-control-alternative" ref={email}></input>
                                </Col>
                                <Col md={4}>
                                    <label>Aadhar No. </label>
                                    <input className="form-control form-control-alternative" onKeyDown={(e) => {
                                        e.persist();
                                        if (e.key.match(/[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/ig)) {
                                            e.preventDefault();
                                        }
                                    }} type="number" ref={aadharno}></input>
                                </Col>
                                <Col md={3}>
                                    <label>Nationality </label>
                                    <select className="form-control form-control-alternative" type="text" ref={nationality} defaultValue="Indian">
                                        {NationalityList.map((x, key) => {
                                            return <option value={x} key={key}> {x}</option>
                                        })}
                                    </select>
                                </Col>
                                <Col md={6}>
                                    <label>Address </label>
                                    <input className="form-control form-control-alternative" type="text" ref={address}></input>
                                </Col>
                                <Col md={3}>
                                    <label>City </label>
                                    <input className="form-control form-control-alternative" type="text" ref={city}></input>
                                </Col>
                                <Col md={3}>
                                    <label>Pincode </label>
                                    <input className="form-control form-control-alternative" onKeyDown={(e) => {
                                        e.persist();
                                        if (e.key.match(/[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]/ig)) {
                                            e.preventDefault();
                                        }
                                    }} type="number" ref={pincode}></input>
                                </Col>
                                <Col md={4}>
                                    <label>Father Name </label>
                                    <input className="form-control form-control-alternative" type="text" ref={fatherName} onKeyDown={(e) => {
                                        e.persist();
                                        if (e.key.match(/[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]|[0-9]/ig)) {
                                            e.preventDefault();
                                        }
                                    }} onChange={({ target }) => {
                                        target.value = target.value.toUpperCase()
                                    }}></input>

                                </Col>
                                <Col md={2}>
                                    <div class="custom-control custom-checkbox mt-3">
                                        <input class="custom-control-input" id="customCheck2" type="checkbox" type="checkbox" ref={maritialStatus} style={{ height: "20px", width: "20px" }} onChange={({ target: { checked } }) => {
                                            spouseName.current.disabled = !checked
                                        }} />
                                        <label class="custom-control-label" for="customCheck2">Maritial Status</label>
                                    </div>
                                </Col>
                                <Col md={4}>
                                    <label>Spouse Name </label>
                                    <input className="form-control form-control-alternative" type="text" ref={spouseName} disabled onKeyDown={(e) => {
                                        e.persist();
                                        if (e.key.match(/[`!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?~]|[0-9]/ig)) {
                                            e.preventDefault();
                                        }
                                    }} onChange={({ target }) => {
                                        target.value = target.value.toUpperCase()
                                    }}></input>
                                </Col>


                                <Col md={5}>
                                    <label>Account No </label>
                                    <input className="form-control form-control-alternative" type="number" ref={accountNo} disabled value={this.state.accountNo}></input>
                                </Col>
                                {/* <Col md={3}>
                                    <label>UserId </label>
                                    <input className="form-control form-control-alternative" type="number" ref={userId}></input>
                                </Col> */}
                                <Col md={3}>
                                    <label>PIN </label>
                                    <input className="form-control form-control-alternative" type="number" ref={pin} disabled value={this.state.pin}></input>
                                </Col>
                                <Col md={2}>
                                    <label>Photo </label>
                                    <Document ref={photo} />
                                </Col>
                                {/* <Col md={3}>
                                    <label>XYZ</label>
                                    <input className="form-control form-control-alternative" type="text" ref={xyz}  ></input>
                                </Col> */}
                            </Row>

                            <input type="submit" className="btn btn-primary mt-2"></input>
                        </form>

                        <br />

                        <Table className="align-items-center" responsive>
                            <thead>
                                <tr>
                                    <th>Photo</th>
                                    <th>Name</th>
                                    <th>Account No.</th>
                                    <th>Mobile No.</th>
                                    <th>pin</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            {this.state.accounts.map((x, key) => {
                                return <tr key={key}>
                                    <td><Img src={x.photo} width="50px" height="50px" style={{ objectFit: "cover", borderRadius: "50%" }} /></td>

                                    <td>{x.name}</td>
                                    <td>{x.accountNo}</td>
                                    <td>{x.mobileNo}</td>
                                    <td>{x.pin}</td>
                                    <td>{x.date.toDate().toLocaleString("en-gb")}</td>

                                    <td><button className="btn btn-sm btn-secondary" onClick={() => {
                                        this.props.history.push("/admin/account/" + x.key)
                                    }}>View</button></td>


                                </tr>
                            })}
                        </Table>
                    </CardBody>
                </Card>
            </Container>
        </>
    }
}

export default AddAmount;