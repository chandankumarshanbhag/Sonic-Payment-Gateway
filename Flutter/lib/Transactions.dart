import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import "./util/filters.dart";
import "./util/transaction.dart";

var tempBalance = 0;
var tempPhoto = "";
var tempAccountNo = "";
var tempTransactions = [];

class Transactions extends StatefulWidget {
  final DocumentReference dRef;
  final void Function() stateChange;
  Transactions({Key key, this.stateChange, this.dRef});
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  String transactionView = "ALL";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: StreamBuilder(
            stream: widget.dRef.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              var photo = "";
              var name = "";
              var email = "";
              var phone = "";
              var dob = "";
              var accountNo = "";
              var date = "";
              var address = "";
              var transactions = [];
              if (snapshot.hasData) {
                photo = snapshot.data["photo"];
                name = snapshot.data["name"];
                email = snapshot.data["email"];
                accountNo = snapshot.data["accountNo"];
                phone = snapshot.data["mobileNo"];
                address = snapshot.data["address"];
                transactions = snapshot.data["transactions"];
                dob = DateFormat("dd/MM/yyyy")
                    .format(snapshot.data["dob"].toDate());
                date = DateFormat("dd/MM/yyyy hh:mm")
                    .format(snapshot.data["date"].toDate());
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: DraggableScrollableSheet(
                  builder: (context, scrollController) {
                    return Container(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "All Transactions",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 24,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Filter(
                                transactionView: this.transactionView,
                                onViewChange: (String transactionView) {
                                  setState(() {
                                    this.transactionView = transactionView;
                                  });
                                }),
                            SizedBox(
                              height: 24,
                            ),
                            ListView.builder(
                              itemBuilder: (context, index) {
                                if (transactionView != "ALL") {
                                  if (transactionView == "INCOME") {
                                    if (transactions[index]["money"] != "in") {
                                      return Container(
                                        child: null,
                                      );
                                    }
                                  } else if (transactionView == "EXPENSES") {
                                    if (transactions[index]["money"] != "out") {
                                      return Container(
                                        child: null,
                                      );
                                    }
                                  }
                                }
                                return TransactionWidget(
                                    transaction: transactions[index]);
                              },
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: transactions.length,
                              padding: EdgeInsets.all(0),
                              controller:
                                  ScrollController(keepScrollOffset: false),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 245, 248, 1),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40))),
                    );
                  },
                  initialChildSize: 0.95,
                  maxChildSize: 0.95,
                ),
              );
            }));
  }
}
