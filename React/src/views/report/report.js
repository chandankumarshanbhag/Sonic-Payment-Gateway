import React from "react";
import Header from "../../components/Headers/Header.jsx";
import { Row, Col, Input, Container, Card, CardBody, CardHeader, Table } from "reactstrap"
import NationalityList from "../createaccount/nationality"
import firebase from "firebase"
import Img from "../../components/Img/Img"
import { withRouter } from "react-router-dom"
import { checkLogin } from "../../firebase/login"
import swal from "sweetalert";

export default class Report extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            date1: "",
            date2: "",
            nationality: "ALL",
            gender: "ALL",
            frombalance: 1,
            tobalance: 99999999,

            data: []
        }
        this.update = this.update.bind(this)
    }
    componentDidMount() {
        if (!checkLogin()) {
            this.props.history.push("/auth/login")
        }
        this.update()
    }
    update() {
        let qry = firebase.firestore().collection("accounts")

        if (this.state.date1 && this.state.date1 != "") {
            let date = new Date(this.state.date1)
            date.setHours(0, 0, 0, 0, 0)
            qry = qry.where("date", ">=", date)
        }
        if (this.state.date2 && this.state.date2 != "") {
            let date = new Date(this.state.date2)
            date.setHours(23, 59, 59, 999)
            qry = qry.where("date", "<=", date)
            if(new Date(this.state.date1).valueOf() > date.valueOf()){
                swal("Error","Date 2 must be greater than Date 1.","error");
            }
        }
        if (this.state.nationality != "ALL") {
            qry = qry.where("nationality", "==", this.state.nationality)
        }
        if (this.state.gender != "ALL") {
            qry = qry.where("gender", "==", this.state.gender)
        }
        // if (this.state.frombalance&&this.state.frombalance != "") {
        //     let b = parseInt(this.state.frombalance)
        //     if (b) {
        //         console.log(b)
        //         qry = qry.where("amount", ">=", b)
        //     }
        // }
        // if (this.state.tobalance&&this.state.tobalance != "") {
        //     let b = parseInt(this.state.tobalance)
        //     if (b) {
        //         console.log(b)
        //         qry = qry.where("amount", "<=", b)
        //     }
        // }
        qry.get()
            .then((snap) => {
                this.setState({ data: snap.docs })
            })
    }
    render() {
        return <>
            <Header />
            <Container className="mt--8" fluid>
                <Card>
                    <CardHeader>
                        <Row>
                            <Col md={3}>
                                <label>Date 1 </label>
                                <input className="form-control" type="date" onChange={({ target: { value } }) => {
                                    this.setState({ date1: value }, () => {
                                        this.update()
                                    })
                                }}></input>
                            </Col>
                            <Col md={3}>
                                <label>Date 2 </label>
                                <input className="form-control" type="date" onChange={({ target: { value } }) => {
                                    this.setState({ date2: value }, () => {
                                        this.update()
                                    })
                                }}></input>
                            </Col>
                            <Col md={3}>
                                <label>Nationality </label>
                                <select className="form-control" type="text" defaultValue="ALL" onChange={({ target: { value } }) => {
                                    this.setState({ nationality: value }, () => {
                                        this.update()
                                    })
                                }}>
                                    <option value="ALL">All</option>
                                    {NationalityList.map((x, key) => {
                                        return <option value={x} key={key}> {x}</option>
                                    })}
                                </select>
                            </Col>
                            <Col md={3}>
                                <label>Gender</label>
                                <select className="form-control" type="text" defaultValue="ALL" onChange={({ target: { value } }) => {
                                    this.setState({ gender: value }, () => {
                                        this.update()
                                    })
                                }}>
                                    <option value="ALL">All</option>
                                    <option value="Male">MALE</option>
                                    <option value="Female">FEMALE</option>
                                    <option value="not prefer to say">not prefer to say</option>
                                </select>
                            </Col>
                            <Col md={3}>
                                <label>From Account Balance</label>
                                <input className="form-control" type="number" defaultValue="0" onChange={({ target: { value } }) => {
                                    this.setState({ frombalance: value }, () => {
                                        this.update()
                                    })
                                }}></input>
                            </Col>
                            <Col md={3}>
                                <label>To Account Balance</label>
                                <input className="form-control" type="number" defaultValue="99999999" onChange={({ target: { value } }) => {
                                    this.setState({ tobalance: value }, () => {
                                        this.update()
                                    })
                                }}></input>
                            </Col>
                        </Row>
                    </CardHeader>
                    <CardBody>
                        <Table className="align-items-center" responsive>
                            <thead>
                                <tr>
                                    <th>Photo</th>
                                    <th>Name</th>
                                    <th>Gender</th>
                                    <th>Account No.</th>
                                    <th>Amount</th>
                                    <th>Mobile No.</th>
                                    <th>pin</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            {this.state.data.map((x, key) => {
                                let id = x.id
                                x = x.data()
                                let from = parseInt(this.state.frombalance)
                                let to = parseInt(this.state.tobalance)
                                console.log(from,to,x.amount)
                                if (!isNaN(from) && !isNaN(to) && x.amount >= from && x.amount <= to) {
                                    return <tr key={key}>
                                        <td><Img src={x.photo} width="50px" height="50px" style={{ objectFit: "cover", borderRadius: "50%" }} /></td>

                                        <td>{x.name}</td>
                                        <td>{x.gender}</td>
                                        <td>{x.accountNo}</td>
                                        <td>{x.amount}</td>
                                        <td>{x.mobileNo}</td>
                                        <td>{x.pin}</td>
                                        <td>{x.date.toDate().toLocaleString("en-gb")}</td>
                                        <td><button className="btn btn-sm btn-secondary" onClick={() => {
                                            this.props.history.push("/admin/account/"+id)
                                        }}>View</button>
                                        
                                        {/* <button className="btn btn-sm btn-secondary" onClick={() => {
                                            this.props.history.push("/admin/account/"+id)
                                        }}>show</button> */}
                                        
                                        </td>
                                    </tr>
                                }
                                else {
                                    return null;
                                }

                            })}
                        </Table>
                    </CardBody>
                </Card>
            </Container>
        </>
    }
}