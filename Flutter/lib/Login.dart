import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var accNo = "";
var pin = "";

class Login extends StatelessWidget {
  final Color primaryColor;
  final Color backgroundColor;
  final AssetImage backgroundImage;
  final focusNode = new FocusNode();
  final void Function(DocumentSnapshot) onSuccess;

  Login(
      {Key key,
      this.primaryColor,
      this.backgroundColor,
      this.backgroundImage,
      this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: this.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new ClipPath(
            clipper: MyClipper(),
            child: Center(
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: this.backgroundImage,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 100.0, bottom: 100.0),
                child: null,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 40.0,
            ),
            child: Text(
              "Account No.",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                new Expanded(
                  child: TextField(
                    autocorrect: false,
                    autofocus: true,
                    onChanged: (value) {
                      accNo = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your 5 digit Account No.',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Text(
              "Pin",
              style: TextStyle(color: Colors.grey, fontSize: 16.0),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Icon(
                    Icons.lock_open,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: Colors.grey.withOpacity(0.5),
                  margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                ),
                new Expanded(
                  child: TextField(
                    obscureText: true,
                    onChanged: (value) {
                      pin = value;
                    },
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your pin',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              //this.onSuccess();
            },
            child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        splashColor: this.primaryColor,
                        color: this.primaryColor,
                        child: new Row(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "LOGIN",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            new Expanded(
                              child: Container(),
                            ),
                            new Transform.translate(
                                offset: Offset(15.0, 0.0),
                                child: new Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(28.0)),
                                    splashColor: Colors.white,
                                    color: Colors.white,
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: this.primaryColor,
                                    ),
                                    onPressed: () => {
                                      Firestore.instance
                                          .collection("accounts")
                                          .where("accountNo", isEqualTo: accNo)
                                          .where("pin", isEqualTo: pin)
                                          .getDocuments()
                                          .then((docs) {
                                        if (docs.documents.length > 0) {
                                          this.onSuccess(docs.documents[0]);
                                        } else {
                                          final snackBar = SnackBar(
                                              content:
                                                  Text('Invalid credentials'));
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      })
                                    },
                                  ),
                                )),
                          ],
                        ),
                        onPressed: () => {},
                      ),
                    ),
                  ],
                )),
          ),
          // Container(
          //   margin: const EdgeInsets.only(top: 10.0),
          //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          //   child: new Row(
          //     children: <Widget>[
          //       new Expanded(
          //         child: FlatButton(
          //           shape: new RoundedRectangleBorder(
          //               borderRadius: new BorderRadius.circular(30.0)),
          //           splashColor: Color(0xFF3B5998),
          //           color: Colors.redAccent,
          //           child: new Row(
          //             children: <Widget>[
          //               new Padding(
          //                 padding: const EdgeInsets.only(left: 20.0),
          //                 child: Text(
          //                   "Logout",
          //                   style: TextStyle(color: Colors.white),
          //                 ),
          //               ),
          //               new Expanded(
          //                 child: Container(),
          //               ),
          //               new Transform.translate(
          //                 offset: Offset(15.0, 0.0),
          //                 child: new Container(
          //                   padding: const EdgeInsets.all(5.0),
          //                   child: FlatButton(
          //                     shape: new RoundedRectangleBorder(
          //                         borderRadius:
          //                             new BorderRadius.circular(28.0)),
          //                     splashColor: Colors.white,
          //                     color: Colors.white,
          //                     child: Icon(
          //                       Icons.dashboard,
          //                       color: Color(0xff3B5998),
          //                       size: 18,
          //                     ),
          //                     onPressed: () async {},
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //           onPressed: () async {

          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   margin: const EdgeInsets.only(top: 20.0),
          //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          //   child: new Row(
          //     children: <Widget>[
          //       new Expanded(
          //         child: FlatButton(
          //           shape: new RoundedRectangleBorder(
          //               borderRadius: new BorderRadius.circular(30.0)),
          //           color: Colors.transparent,
          //           child: Container(
          //             padding: const EdgeInsets.only(left: 20.0),
          //             alignment: Alignment.center,
          //             child: null,
          //           ),
          //           onPressed: () async {
          //             print("scan");
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
