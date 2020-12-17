import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import './Ripples.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';

// String _appKey = 'dDEdeeDCB0CEd690a22c1DCF9';
// String _appSecret = 'e441133fAabc1A02fFBb1a85fCeF5D8FB5eFd7CAece2F9C46a';
// String _appConfig = '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';

class Receive extends StatelessWidget {
  final Map user;
  Receive({Key, this.user});
  @override
  Widget build(BuildContext context) {
    return ReceiveView(user: user);
  }
}

class ReceiveView extends StatefulWidget {
  final Map user;
  ReceiveView({Key key, this.user});
  @override
  _ReceiveViewState createState() => _ReceiveViewState();
}

class _ReceiveViewState extends State<ReceiveView> {
  String jsonData = "";
  static const platform = const MethodChannel('com.example.sonicpayment/sonic');
  @override
  void initState() {
    try {
      var data = {
        "accountNo": widget.user["accountNo"],
        "name": widget.user["name"],
        "photo": widget.user["photo"],
        "id": widget.user["id"]
      };
      jsonData = jsonEncode(data);
    } catch (e) {}

    _requestPermissions().then((_) {
      _start();
    });
    super.initState();
  }

  Future<void> _start() async {
    try {
      final String result = await platform.invokeMethod('send_audio',<String, dynamic>{'text': widget.user["accountNo"]});
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.message));
      Scaffold.of(context).showSnackBar(snackBar);

    }
  }
  


  Future<void> _requestPermissions() async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var permissionStatus = await _permissionHandler
        .checkPermissionStatus(PermissionGroup.microphone);
    if (permissionStatus != PermissionStatus.granted) {
      var result = await _permissionHandler
          .requestPermissions([PermissionGroup.microphone]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _start();
        },
        child: Icon(
          Icons.replay,
          color: Colors.blue,
        ),
        backgroundColor: Colors.white,
      ),
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
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: []),
                      Text(
                        "Waiting...",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.blue[100]),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Ripples(child: null),
                        ],
                      ),
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
