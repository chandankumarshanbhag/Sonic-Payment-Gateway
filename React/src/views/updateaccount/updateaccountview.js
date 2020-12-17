import React, { createRef } from "react";
import firebase from "firebase"
import Header from "../../components/Headers/Header.jsx";
import { Row, Col, Input, Container, Card, CardBody, CardHeader } from "reactstrap"
import NationalityList from "../createaccount/nationality"
import Document from "../../components/Document/Document"
import { withRouter } from "react-router-dom"
import { checkLogin } from "../../firebase/login"
import swal from "sweetalert"

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

const snap = null

class UpdateAccountView extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            data: {

            }
        }
        this.fetch = this.fetch.bind(this)
        this.update = this.update.bind(this)
        this.snapshot = null;
    }
    componentDidMount() {
        if (!checkLogin()) {
            this.props.history.push("/auth/login")
        }
        this.fetch();
    }
    fetch() {
        firebase.firestore().collection("accounts").doc(this.props.match.params.id).get()
            .then((snapshot) => {
                console.log(snapshot.data())
                this.setState({ data: snapshot.data() }, () => {
                    photo.current.setValue(this.state.data.photo)
                })
            })
    }
    update(e) {
        e.preventDefault()
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
        else if (pincode.current.value.length !=6) {
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
        else if (pin.current.value.length !=4) {
            swal("Error", "Invalid PIN. Pin must contain 4 digits.", "error")
        }
        else if (photo.current.getValue().length < 5) {
            swal("Error", "Please select the photo.", "error")
        }
        else {
            firebase.firestore().collection("accounts").doc(this.props.match.params.id).get()
                .then((snapshot) => {
                    snapshot.ref.set({
                        ...snapshot.data(),
                        name: name.current.value,
                        gender: gender.current.value,
                        dob: new Date(dob.current.value),
                        mobileNo: mobileNo.current.value,
                        email: email.current.value,
                        nationality: nationality.current.value,
                        address: address.current.value,
                        city: city.current.value,
                        pincode: pincode.current.value,
                        maritialStatus: maritialStatus.current.checked,
                        fatherName: fatherName.current.value,
                        spouseName: spouseName.current.value,
                        photo: photo.current.getValue(),
                        pin: pin.current.value
                    }).then(() => {
                        swal("Success", "Update Successful.", "success")
                    })
                        .catch(() => {
                            swal("Error", "Network Error.", "error");
                        })
                })
        }

    }
    render() {
        let date = new Date().toISOString().slice(0, 10)
        try {
            date = new Date(this.state.data.dob).toISOString().slice(0, 10)
        } catch (e) {
            date = new Date().toISOString().slice(0, 10)
        }


        return <div className="content">
            <Header />

            <Container className="mt--8" fluid>
                <Card>
                    <CardHeader>
                        <h3>Profile Update</h3>
                    </CardHeader>
                    <CardBody>
                        <Row>
                            {/* <Col md={4}>

                </Col> */}
                            <Col md={12}>
                                <form onSubmit={this.update}>
                                    <Row>
                                        <Col md={7}>
                                            <label>Name </label>
                                            <input className="form-control form-control-alternative" type="text" ref={name} defaultValue={this.state.data.name}></input>
                                        </Col>
                                        <Col md={2}>
                                            <label>Gender </label>
                                            <select className="form-control form-control-alternative" ref={gender} defaultValue={this.state.data.gender}>
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                            </select>
                                        </Col>
                                        <Col md={3}>
                                            <label>Date of birth </label>
                                            <input className="form-control form-control-alternative" type="date" ref={dob} max={new Date().toISOString().slice(0, 10)} defaultValue={date}></input>
                                        </Col>
                                        <Col md={4}>
                                            <label>Mobile No. </label>
                                            <input className="form-control form-control-alternative" type="number" ref={mobileNo} defaultValue={this.state.data.mobileNo}></input>
                                        </Col>
                                        <Col md={4}>
                                            <label>Email </label>
                                            <input className="form-control form-control-alternative" ref={email} defaultValue={this.state.data.email}></input>
                                        </Col>
                                        <Col md={4}>
                                            <label>Aadhar No. </label>
                                            <input className="form-control form-control-alternative" type="number" ref={aadharno} defaultValue={this.state.data.aadharno}></input>
                                        </Col>
                                        <Col md={3}>
                                            <label>Nationality </label>
                                            <select className="form-control form-control-alternative" type="text" ref={nationality} value={this.state.data.nationality}>
                                                {NationalityList.map((x, key) => {
                                                    return <option value={x} key={key}> {x}</option>
                                                })}
                                            </select>
                                        </Col>
                                        <Col md={6}>
                                            <label>Address </label>
                                            <input className="form-control form-control-alternative" type="text" ref={address} defaultValue={this.state.data.address}></input>
                                        </Col>
                                        <Col md={3}>
                                            <label>City </label>
                                            <input className="form-control form-control-alternative" type="text" ref={city} defaultValue={this.state.data.city}></input>
                                        </Col>
                                        <Col md={3}>
                                            <label>Pincode </label>
                                            <input className="form-control form-control-alternative" type="number" ref={pincode} defaultValue={this.state.data.pincode}></input>
                                        </Col>
                                        <Col md={4}>
                                            <label>Father Name </label>
                                            <input className="form-control form-control-alternative" type="text" ref={fatherName} defaultValue={this.state.data.fatherName}></input>

                                        </Col>
                                        <Col md={2}>
                                            {/* <div style={{ marginTop: "20px" }}>
                                                <label>Maritial Status  &nbsp;&nbsp;
                                     <input type="checkbox" ref={maritialStatus} style={{ height: "20px", width: "20px" }} onChange={({ target: { checked } }) => {
                                                        spouseName.current.disabled = !checked
                                                    }} defaultChecked={this.state.data.maritialStatus} /> </label>
                                                    
                                            </div> */}
                                            <div class="custom-control custom-checkbox mt-3">
                                                <input class="custom-control-input" id="customCheck2" type="checkbox" type="checkbox" ref={maritialStatus} style={{ height: "20px", width: "20px" }} onChange={({ target: { checked } }) => {
                                                    spouseName.current.disabled = !checked
                                                }} />
                                                <label class="custom-control-label" for="customCheck2">Maritial Status</label>
                                            </div>
                                        </Col>
                                        <Col md={4}>
                                            <label>Spouse Name </label>
                                            <input className="form-control form-control-alternative" type="text" ref={spouseName} defaultValue={this.state.data.spouseName}></input>
                                        </Col>


                                        <Col md={5}>
                                            <label>Account No </label>
                                            <input className="form-control form-control-alternative" type="number" ref={accountNo} defaultValue={this.state.data.accountNo}></input>
                                        </Col>
                                        {/* <Col md={3}>
                                            <label>UserId </label>
                                            <input  className="form-control form-control-alternative" type="number" ref={userId} defaultChecked={this.state.data.userId}></input>
                                        </Col> */}
                                        <Col md={3}>
                                            <label>PIN </label>
                                            <input className="form-control form-control-alternative" type="number" ref={pin} defaultValue={this.state.data.pin}></input>
                                        </Col>
                                        <Col md={2}>
                                            <label>Photo </label>
                                            <Document ref={photo} />
                                        </Col>
                                    </Row>

                                    <input type="submit" value="Update" className="btn btn-primary mt-2"></input>
                                </form>
                            </Col>
                        </Row>
                    </CardBody>
                </Card>
            </Container>

        </div>;
    }
}

export default UpdateAccountView