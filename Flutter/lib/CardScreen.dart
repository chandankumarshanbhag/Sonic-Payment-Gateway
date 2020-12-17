import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import './ChangePin.dart';

class CardScreen extends StatefulWidget {
  final DocumentReference dRef;
  final void Function() stateChange;
  CardScreen({Key key, this.stateChange, this.dRef});
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.dRef.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var photo = "";
          var name = "";
          var email = "";
          var phone = "";
          var dob = "";
          var accountNo = "";
          var date = "";
          var address = "";
          var pin = "";
          if (snapshot.hasData) {
            photo = snapshot.data["photo"];
            name = snapshot.data["name"];
            email = snapshot.data["email"];
            accountNo = snapshot.data["accountNo"];
            phone = snapshot.data["mobileNo"];
            address = snapshot.data["address"];
            pin = snapshot.data["pin"];
            dob =
                DateFormat("dd/MM/yyyy").format(snapshot.data["dob"].toDate());
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Profile",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 60,
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
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              accountNo,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Profile Information"),
                                  ),
                                  Divider(),
                                  ListTile(
                                    title: Text("Name"),
                                    subtitle: Text(name),
                                    leading: Icon(Icons.person),
                                  ),
                                  ListTile(
                                    title: Text("Date of birth"),
                                    subtitle: Text(dob),
                                    leading: Icon(Icons.calendar_today),
                                  ),
                                  ListTile(
                                    title: Text("Address"),
                                    subtitle: Text(address),
                                    leading: Icon(Icons.map),
                                  ),
                                  ListTile(
                                    title: Text("Email"),
                                    subtitle: Text(email),
                                    leading: Icon(Icons.email),
                                  ),
                                  ListTile(
                                    title: Text("Phone"),
                                    subtitle: Text(phone),
                                    leading: Icon(Icons.phone),
                                  ),
                                  ListTile(
                                    title: Text("Joined Date"),
                                    subtitle: Text(date),
                                    leading: Icon(Icons.calendar_view_day),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[100],
                                    spreadRadius: 10.0,
                                    blurRadius: 4.5)
                              ]),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.lock,
                                    color: Colors.lightBlue[900],
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "Change Pin",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.grey[700]),
                                  )
                                ],
                              ),
                              RaisedButton(
                                color: Colors.pink,
                                child: Text(
                                  "Change",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  final prevpin = TextEditingController();
                                  final newpin = TextEditingController();
                                  final repin = TextEditingController();
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text('Change PIN'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                TextField(
                                                  controller: prevpin,
                                                  obscureText: true,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText: "Previous PIN"),
                                                ),
                                                SizedBox(
                                                  height: 16,
                                                ),
                                                TextField(
                                                  controller: newpin,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText: "New PIN"),
                                                ),
                                                TextField(
                                                  controller: repin,
                                                  obscureText: true,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "Repeat New PIN"),
                                                )
                                              ],
                                            ),
                                            actions: <Widget>[
                                              new FlatButton(
                                                child: new Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              new FlatButton(
                                                child: new Text('Change'),
                                                onPressed: () {
                                                  if (prevpin.text == pin) {
                                                    if (newpin.text.length !=
                                                        4) {
                                                      final snackBar = SnackBar(
                                                          content: Text(
                                                              'PIN should be 4 digit long.'));
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    } else if (newpin.text ==
                                                        repin.text) {
                                                      var data =
                                                          snapshot.data.data;
                                                      data['pin'] = newpin.text;
                                                      snapshot.data.reference
                                                          .setData(data)
                                                          .then((v) async {
                                                            final snackBar = SnackBar(
                                                        content: Text(
                                                            'PIN successfully changed.'));
                                                    Scaffold.of(context)
                                                        .showSnackBar(snackBar);
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        prefs.setBool(
                                                            'login', false);
                                                        widget.stateChange();
                                                      }).catchError((e){
                                                        final snackBar = SnackBar(
                                                        content: Text(
                                                            'Something went wrong.'));
                                                    Scaffold.of(context)
                                                        .showSnackBar(snackBar);
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    } else {
                                                      final snackBar = SnackBar(
                                                          content: Text(
                                                              'New PIN doesn\'t match'));
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                  } else {
                                                    Navigator.of(context).pop();
                                                    final snackBar = SnackBar(
                                                        content: Text(
                                                            'Invalid PIN'));
                                                    Scaffold.of(context)
                                                        .showSnackBar(snackBar);
                                                  }
                                                },
                                              )
                                            ],
                                          ));
                                  // SharedPreferences prefs =
                                  //     await SharedPreferences.getInstance();
                                  // prefs.setBool('login', false);
                                  // widget.stateChange();
                                },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[100],
                                    spreadRadius: 10.0,
                                    blurRadius: 4.5)
                              ]),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.power_settings_new,
                                    color: Colors.lightBlue[900],
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.grey[700]),
                                  )
                                ],
                              ),
                              RaisedButton(
                                child: Text(
                                  "logout",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Color.fromRGBO(50, 172, 121, 1),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool('login', false);
                                  widget.stateChange();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
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
        });
  }
}
