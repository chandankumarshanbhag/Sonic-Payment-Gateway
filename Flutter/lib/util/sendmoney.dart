import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:sonicpayment/Ripples.dart';

Future sendMoney(var context, var accountNo, var user, var dRef) {
  if (accountNo == user['accountNo']) {
    return Future.value(null);
  } else {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SendMoney(user: user, accountNo: accountNo, dRef: dRef);
        });
  }
}

class SendMoney extends StatefulWidget {
  final user;
  final accountNo;
  final dRef;
  SendMoney({Key key, this.user, this.accountNo, this.dRef});
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  String amount;
  String pin;
  bool loading;
  bool complete;
  @override
  void initState() {
    // TODO: implement initState
    amount = "";
    pin = "";
    loading = false;
    complete = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
          padding: EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height / 1.1,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator()]));
    } else if (complete) {
      return Container(
          padding: EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height / 1.1,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Transaction Successfull.",
                  style: TextStyle(fontSize: 20.0),
                )
              ]));
    }
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("/accounts")
                .where("accountNo", isEqualTo: widget.accountNo)
                .limit(1)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.documents.length == 0) {
                  return Container(
                      padding: EdgeInsets.all(20.0),
                      height: MediaQuery.of(context).size.height / 1.1,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[Text("Invalid Account.")]));
                }
                var name = snapshot.data.documents[0].data['name'];
                var raccountNo = snapshot.data.documents[0].data['accountNo'];
                var photo = snapshot.data.documents[0].data['photo'];
                var reciever = snapshot.data.documents[0];
                return Container(
                  height: 800,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ModalDrawerHandle(
                          handleColor: Colors.indigoAccent,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(name)
                        ],
                      ),
                      SafeArea(
                          child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  setState(() {
                                    amount = v;
                                  });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Amount',
                                ),
                              ))),
                      SafeArea(
                          child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (v) {
                                  setState(() {
                                    pin = v;
                                  });
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'PIN',
                                ),
                              ))),
                      SafeArea(
                          child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: NiceButton(                                
                                width: 200,
                                elevation: 8.0,
                                radius: 52.0,
                                icon: Icons.send,
                                text: "Send",
                                background: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (widget.user['pin'].toString() ==
                                      pin.toString()) {
                                    int balance = widget.user['amount'];
                                    int amount = int.parse(this.amount);
                                    if (amount > balance) {
                                      showAlertDialog(context, "Error",
                                          "Insuffient Balance");
                                    } else if (amount <= 0) {
                                      showAlertDialog(
                                          context, "Error", "Invalid Amount.");
                                    } else if (widget.accountNo
                                            .toString()
                                            .length <
                                        4) {
                                      showAlertDialog(
                                          context, "Error", "Invalid Account.");
                                    } else {
                                      Firestore.instance
                                          .collection("/accounts")
                                          .where("accountNo",
                                              isEqualTo:
                                                  widget.user['accountNo'])
                                          .limit(1)
                                          .getDocuments()
                                          .then((snap) {
                                        if (snap.documents.length == 0) {
                                          showAlertDialog(context, "Error",
                                              "Invalid Account.");
                                        } else {
                                          var temp = snap.documents[0].data;
                                          temp['transactions'].add({
                                            "amount": amount,
                                            "date": DateTime.now(),
                                            "money": "out",
                                            "msg": "Sent to " +
                                                name +
                                                " (" +
                                                raccountNo +
                                                ")",
                                            "type": "DEBIT"
                                          });
                                          temp['amount'] -= amount;
                                          snap.documents[0].reference
                                              .setData(temp)
                                              .then((a) {
                                            var rec = reciever.data;
                                            rec['amount'] += amount;
                                            rec['transactions'].add({
                                              "amount": amount,
                                              "date": DateTime.now(),
                                              "money": "in",
                                              "msg": "Recieved from " +
                                                  temp['name'] +
                                                  " (" +
                                                  temp['accountNo'] +
                                                  ")",
                                              "type": "CREDIT"
                                            });

                                            reciever.reference
                                                .setData(rec)
                                                .then((v) {
                                              setState(() {
                                                loading = false;
                                                complete = true;
                                              });
                                            });
                                          });
                                        }
                                      });
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  } else {
                                    showAlertDialog(
                                        context, "Error", "Invalid PIN.");
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                },
                              ))),
                    ],
                  ),
                );
              } else {
                return Container(
                    padding: EdgeInsets.all(20.0),
                    height: MediaQuery.of(context).size.height / 1.1,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[CircularProgressIndicator()]));
              }
            }));
  }
}

showAlertDialog(BuildContext context, String title, String msg) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(msg),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
