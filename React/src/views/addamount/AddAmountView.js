import React from "react"
import { withRouter } from "react-router-dom"
import { Container, Card, CardBody, Row, Col, Table } from "reactstrap"
import firebase from "../../firebase"
import Header from "../../components/Headers/Header.jsx";
import {checkLogin} from "../../firebase/login"


class AddAmountView extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            account: {

            },
            amount: 0
        }
    }
    componentDidMount() {
        if(!checkLogin()){
            this.props.history.push("/auth/login")
        }
        let amount = 0
        let account = {}
        firebase.firestore().collection("amount").where('accountId', '==', this.props.match.params.id).get()
        .then((res) => {
            if(res.docs.length >0){
                amount = res.docs[0].data().amount
            }
            else{
                amount = 0
            }
            firebase.firestore().collection("accounts").doc(this.props.match.params.id).get()
            .then((acc) => {
                // console.log(acc)
                // if(acc.docs.length > 0){
                //     account = acc.docs[0].data()

                //     this.setState({account,amount})
                // }
                // else{
                //     console.log("Invalid account")
                // }
            })

        })
    }
    render() {
        return <>
            <Header />
            <Container className="mt--8" fluid>
                <Card>
                    <CardBody>
                        {this.state.amount}
                    </CardBody>
                </Card>
            </Container>
        </>;
    }
}


export default withRouter(AddAmountView);