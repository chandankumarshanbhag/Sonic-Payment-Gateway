import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import './Ripples.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';

class ChangePin extends StatelessWidget {
  final Map user;
  ChangePin({Key, this.user});
  @override
  Widget build(BuildContext context) {
    return ChangePinView(user: user);
  }
}

class ChangePinView extends StatefulWidget {
  final Map user;
  ChangePinView({Key key, this.user});
  @override
  _ChangePinViewState createState() => _ChangePinViewState();
}

class _ChangePinViewState extends State<ChangePinView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stack(children: <Widget>[
                //Container for top data
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: MediaQuery.of(context).size.height / 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextField(),
                      TextField(),
                      TextField(),
                    ],
                  ),
                ),
              ])),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(20, 136, 220, 1),
                Color.fromRGBO(43, 50, 178, 1)
              ]))),
      backgroundColor: Colors.blue[500],
    );
  }
}
