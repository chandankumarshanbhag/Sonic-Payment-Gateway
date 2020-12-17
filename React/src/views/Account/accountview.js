import React, { createRef } from "react";
import firebase from "firebase"
import Header from "../../components/Headers/Header.jsx";
import { Row, Col, Input, Container, Card, CardBody, CardHeader, CardFooter,Table } from "reactstrap"
import NationalityList from "../createaccount/nationality"
import Document from "../../components/Document/Document"
import {withRouter} from "react-router-dom"
import {checkLogin} from "../../firebase/login"

const photo = createRef()
class AccountView extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            data: {

            }
        }
        this.fetch = this.fetch.bind(this)
        this.snapshot = null;
    }
    componentDidMount() {
        if(!checkLogin()){
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
    render() {
        let date = new Date().toISOString().slice(0, 10)
        try {
            date = new Date(this.state.data.dob).toISOString().slice(0, 10)
        } catch (e) {
            date = new Date().toISOString().slice(0, 10)
        }
        let transactions = this.state.data.transactions ? this.state.data.transactions : []


        return <div className="content">
            <Header />

            <Container className="mt--8" fluid>
                <Card>
                    <CardHeader>
                        <h3>Account</h3>
                    </CardHeader>
                    <CardBody>
                        <Row>
                            {/* <Col md={4}>

                </Col> */}
                            <Col md={12}>
                                <form onSubmit={this.update}>
                                    <Row>
                                        <Col md={10}>
                                            <Row>
                                                <Col md={7}>
                                                    <label>Name </label>
                                                    <input className="form-control" type="text" value={this.state.data.name}></input>
                                                </Col>
                                                <Col md={2}>
                                                    <label>Gender </label>
                                                    <select className="form-control" value={this.state.data.gender}>
                                                        <option value="Male">Male</option>
                                                        <option value="Female">Female</option>
                                                    </select>
                                                </Col>
                                                <Col md={3}>
                                                    <label>Date of birth </label>
                                                    <input className="form-control" max={new Date().toISOString().slice(0, 10)} value={date}></input>
                                                </Col>
                                                <Col md={4}>
                                                    <label>Mobile No. </label>
                                                    <input className="form-control" type="number" value={this.state.data.mobileNo}></input>
                                                </Col>
                                                <Col md={4}>
                                                    <label>Email </label>
                                                    <input className="form-control" value={this.state.data.email}></input>
                                                </Col>
                                                <Col md={4}>
                                                    <label>Aadhar No. </label>
                                                    <input className="form-control" type="number" value={this.state.data.aadharno}></input>
                                                </Col>
                                                <Col md={3}>
                                                    <label>Nationality </label>
                                                    <select className="form-control" type="text" value={this.state.data.nationality}>
                                                        {NationalityList.map((x, key) => {
                                                            return <option value={x} key={key}> {x}</option>
                                                        })}
                                                    </select>
                                                </Col>
                                                <Col md={6}>
                                                    <label>Address </label>
                                                    <input className="form-control" type="text" value={this.state.data.address}></input>
                                                </Col>
                                                <Col md={3}>
                                                    <label>City </label>
                                                    <input className="form-control" type="text" value={this.state.data.city}></input>
                                                </Col>
                                                <Col md={3}>
                                                    <label>Pincode </label>
                                                    <input className="form-control" type="number" value={this.state.data.pincode}></input>
                                                </Col>
                                                <Col md={4}>
                                                    <label>Father Name </label>
                                                    <input className="form-control" type="text" value={this.state.data.fatherName}></input>

                                                </Col>
                                                <Col md={2}>
                                                    <div style={{ marginTop: "20px" }}>
                                                        <label>Maritial Status  &nbsp;&nbsp;
                                     <input type="checkbox" style={{ height: "20px", width: "20px" }} checked={this.state.data.maritialStatus} /> </label>
                                                    </div>
                                                </Col>
                                                <Col md={4}>
                                                    <label>Spouse Name </label>
                                                    <input className="form-control" type="text" checked={this.state.data.spouseName}></input>
                                                </Col>


                                                <Col md={5}>
                                                    <label>Account No </label>
                                                    <input className="form-control" type="number" value={this.state.data.accountNo}></input>
                                                </Col>
                                                {/* <Col md={3}>
                                            <label>UserId </label>
                                            <input className="form-control" type="number" ref={userId} checked={this.state.data.userId}></input>
                                        </Col> */}
                                                <Col md={3}>
                                                    <label>PIN </label>
                                                    <input className="form-control" type="number" value={this.state.data.pin}></input>
                                                </Col>
                                            </Row>

                                        </Col>
                                        <Col md={2}>
                                            <label>Photo </label>
                                            <Document ref={photo} />
                                            <label>Amount </label>
                                            <input className="form-control" type="text" value={this.state.data.amount}></input>


                                        </Col>
                                    </Row>

                                </form>
                            </Col>
                        </Row>
                    </CardBody>
                    <CardFooter>
                        <h3>Transactions</h3>
                        <Table className="align-items-center" responsive>
                            <thead>
                                <th>Sl No.</th>
                                <th>Type</th>
                                <th>Amount</th>
                                <th>Timestamp</th>
                            </thead>
                            <tbody>
                                {transactions.map((x, key) => {
                                    return <tr>
                                        <td>{key+1}</td>
                                        <td>{x.type}</td>
                                        <td>{x.amount}</td>
                                        <td>{x.date.toDate().toLocaleString("en-gb")}</td>
                                    </tr>
                                })}
                            </tbody>
                        </Table>

                    </CardFooter>
                </Card>
            </Container>

        </div>;
    }
}

export default AccountView