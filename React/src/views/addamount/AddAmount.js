import React, { Component } from "react"
import { Container, Card, CardBody, Row, Col, Table } from "reactstrap"
import firebase from "../../firebase"
import Header from "../../components/Headers/Header.jsx";
import Img from "../../components/Img/Img"
import { withRouter } from "react-router-dom"
import { checkLogin } from "../../firebase/login"
import swal from "sweetalert";

class AddAmount extends Component {
    constructor(props) {
        super(props)
        this.state = {
            accounts: []
        }
        this.updateAccountsList = this.updateAccountsList.bind(this)
        this.addAmount = this.addAmount.bind(this)
    }
    componentDidMount() {
        if (!checkLogin()) {
            this.props.history.push("/auth/login")
        }
        this.updateAccountsList()
    }
    async updateAccountsList() {
        firebase.firestore().collection("accounts").get()
            .then(async (accounts) => {
                console.log(accounts)
                let temp = []
                console.log(accounts.docs.length)
                for (let i = 0; i < accounts.docs.length; i++) {
                    temp.push({
                        ...accounts.docs[i].data(),
                        key: accounts.docs[i].id
                    })
                }
                console.log(temp)
                this.setState({ accounts: temp })
            })
            .catch(() => {

            })
    }
    addAmount(amount, account) {
        if (isNaN(amount) || amount <= 0) {
            swal("Error", "Invalid amount.", "error")
            return;
        }
        firebase.firestore().collection("accounts").doc(account.key).get()
            .then((snapshot) => {
                let data = snapshot.data()
                if (data) {
                    snapshot.ref.set({
                        ...data,
                        amount: ((data.amount || 0) + amount),
                        transactions: [...(data.transactions ? data.transactions : []), {
                            amount: amount,
                            type: "DEPOSIT",
                            date: new Date(),
                            money: "in",
                            msg: "Amount deposited in Bank."
                        }]
                    }).then(() => {
                        this.updateAccountsList()
                    })
                }
            })

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
                                    <th>Amount</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            {this.state.accounts.map((x, key) => {
                                return <tr key={key}>
                                    <td><Img src={x.photo} width="50px" height="50px" style={{ objectFit: "cover", borderRadius: "50%" }} /></td>
                                    <td>{x.name}</td>
                                    <td>{x.accountNo}</td>
                                    <td>{x.mobileNo}</td>
                                    <td>{x.amount}</td>



                                    <td><button className="btn btn-sm btn-secondary" onClick={() => {
                                        swal({
                                            content: {
                                                element: "input",
                                                attributes: {
                                                    placeholder: "Enter amount",
                                                    type: "number",
                                                    min: 1,
                                                    defaultValue: 1
                                                },
                                            },
                                        }).then((v) => {
                                            console.log(v)
                                            let amount = parseInt(v)
                                            this.addAmount(amount, x)
                                        })
                                    }}>Add</button></td>
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