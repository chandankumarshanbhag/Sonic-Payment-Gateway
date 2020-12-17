import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sonicpayment/Transactions.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import "./Scan.dart";
import "./Receive.dart";
import 'package:nice_button/nice_button.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:easy_dialog/easy_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';
import './util//sendmoney.dart';

import "./util/filters.dart";
import "./util/transaction.dart";
import "./util/amount.dart";

var tempBalance = 0;
var tempPhoto = "";
var tempAccountNo = "";
var tempTransactions = [];
var tempName = "";

class HomeScreen extends StatefulWidget {
  final DocumentReference dRef;
  final void Function() stateChange;
  HomeScreen({Key key, this.stateChange, this.dRef}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String transactionView = "ALL";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: widget.dRef.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var balance = tempBalance;
          var photo = tempPhoto;
          var transactions = [];
          var accountNo = tempAccountNo;
          var name = tempName;
          Map user = {};
          if (snapshot.hasData) {
            name = snapshot.data["name"];
            balance = snapshot.data["amount"];
            accountNo = snapshot.data["accountNo"];
            photo = snapshot.data["photo"];
            transactions = snapshot.data["transactions"].reversed.toList();
            transactions = transactions.sublist(0, transactions.length>3?3:transactions.length);
            tempBalance = balance;
            tempPhoto = photo;
            tempTransactions = transactions;
            tempAccountNo = accountNo;
            user = snapshot.data.data;
            user["id"] = snapshot.data.documentID;
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                //Container for top data
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 22, vertical: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            //"₹ " + balance.toString(),
                            "Hello,",
                            style: TextStyle(
                                color: Colors.blue[100],
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.network(
                                      photo,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      SendAndReceive(
                        user: user,
                        dRef: widget.dRef,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      ScanQr(
                        user: user,
                        dRef: widget.dRef,
                      )
                    ],
                  ),
                ),

                //draggable sheet
                DraggableScrollableSheet(
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 245, 248, 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: SingleChildScrollView(
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
                                  Text(
                                    "Recent Transactions",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 22),
                            ),

                            SizedBox(
                              height: 24,
                            ),
                            // Filter(
                            //     transactionView: this.transactionView,
                            //     onViewChange: (String transactionView) {
                            //       setState(() {
                            //         this.transactionView = transactionView;
                            //       });
                            //     }),
                            SizedBox(
                              height: 24,
                            ),

                            ListView.builder(
                              itemBuilder: (context, index) {
                                if (index < 0) {
                                  return Container(
                                    child: null,
                                  );
                                }
                                return TransactionWidget(
                                    transaction: transactions[index]);
                              },
                              shrinkWrap: true,
                              itemCount: transactions.length,
                              padding: EdgeInsets.all(0),
                              controller:
                                  ScrollController(keepScrollOffset: false),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: <Widget>[
                            //     NiceButton(
                            //       width: 255,
                            //       elevation: 8.0,
                            //       radius: 52.0,
                            //       icon: Icons.receipt,
                            //       text: "All Transactions",
                            //       background: Colors.blue,
                            //       onPressed: () {
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) => Transactions(
                            //                     dRef: widget.dRef,
                            //                   )),
                            //         );
                            //       },
                            //     )
                            //   ],
                            // )

                            //now expense
                          ],
                        ),
                        controller: scrollController,
                      ),
                    );
                  },
                  initialChildSize: 0.50,
                  minChildSize: 0.50,
                  maxChildSize: 1,
                )
              ],
            ),
          );
        });
  }
}

class SendAndReceive extends StatelessWidget {
  final Map user;
  final DocumentReference dRef;
  SendAndReceive({Key key, this.user, this.dRef});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Scan(user: user, dRef: this.dRef)),
              );
            },
            child: Container(
              width: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 245, 248, 1),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Icon(Icons.send, color: Colors.blue[900], size: 30),
                    padding: EdgeInsets.all(12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Send",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.blue[100]),
                  ),
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Receive(user: user)),
              );
            },
            child: Container(
              width: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 245, 248, 1),
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                    child: Icon(
                      Icons.surround_sound,
                      color: Colors.blue[900],
                      size: 30,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Receive",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.blue[100]),
                  ),
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              showAmount(context, this.user['pin'], this.user['amount']);
            },
            child: Container(
              width: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 245, 248, 1),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Icon(Icons.account_balance_wallet,
                        color: Colors.blue[900], size: 30),
                    padding: EdgeInsets.all(12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Balance",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.blue[100]),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

class ScanQr extends StatelessWidget {
  final Map user;
  final DocumentReference dRef;
  ScanQr({Key key, this.user, this.dRef});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              scanner.scan().then((value) {
                sendMoney(context, value, this.user, this.dRef);
                print(value);
              });
            },
            child: Container(
              width: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(243, 245, 248, 1),
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Icon(Icons.camera_alt,
                        color: Colors.blue[900], size: 30),
                    padding: EdgeInsets.all(12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Scan QR",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.blue[100]),
                  ),
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              print(this.user["accountNo"]);
              showQRCode(context, this.user["accountNo"]);
              // EasyDialog(
              //     title: Text("Show your QR Code"),
              //     description: Text(""),
              //     height: 350.0,
              //     contentList: [
              //       QrImage(
              //         data: this.user["accountNo"],
              //         version: QrVersions.auto,
              //         size: 200.0,
              //       )
              //     ]).show(context);
            },
            child: Container(
              width: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 245, 248, 1),
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                    child: Icon(
                      Icons.nfc,
                      color: Colors.blue[900],
                      size: 30,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Show QR",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.blue[100]),
                  ),
                ],
              ),
            )),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Transactions(
                          dRef: this.dRef,
                        )),
              );
            },
            child: Container(
              width: 100.0,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(243, 245, 248, 1),
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                    child: Icon(
                      Icons.receipt,
                      color: Colors.blue[900],
                      size: 30,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Transactions",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.blue[100]),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}

void showQRCode(context, code) {
  showModalBottomSheet(
    context: context,
    builder: (builder) {
      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ModalDrawerHandle(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: QrImage(
                data: code,
                version: QrVersions.auto,
                size: 300.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text("Show This QR Code.")],
              ),
            )
          ],
        ),
      );
    },
  );
}
