import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './CardScreen.dart';
import './HomeScreen.dart';
import './Login.dart';

var login = false;
var user = new Map();
DocumentReference dRef;
String documentID = null;
SharedPreferences prefs = null;

void start() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  login = prefs.getBool('login') ?? false;
  documentID = prefs.getString("id");
  runApp(MyApp());
}

void main() {
  start();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sonic Payment',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: WalletApp());
  }
}

class WalletApp extends StatefulWidget {
  @override
  _WalletAppState createState() => _WalletAppState();
}

class _WalletAppState extends State<WalletApp> {
  var screens = null; //screens for each tab

  int selectedTab = 0;
  var loginState = login;

  @override
  Widget build(BuildContext context) {
    screens = [
      HomeScreen(
          stateChange: () {
            setState(() {
              login = prefs.getBool('login') ?? false;
              loginState = login;
            });
          },
          dRef: dRef == null
              ? Firestore.instance.collection("accounts").document(documentID)
              : dRef),
      CardScreen(
          stateChange: () {
            setState(() {
              login = prefs.getBool('login') ?? false;
              loginState = login;
            });
          },
          dRef: dRef == null
              ? Firestore.instance.collection("accounts").document(documentID)
              : dRef)
    ];

    if (loginState) {
      return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.offline_bolt), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity), title: Text("Profile")),
          ],
          onTap: (index) {
            setState(() {
              selectedTab = index;
            });
          },
          showUnselectedLabels: true,
          iconSize: 30,
          currentIndex: selectedTab,
        ),
        body: Container(
            child: screens[selectedTab],
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Color.fromRGBO(20, 136, 220, 1),
                  Color.fromRGBO(43, 50, 178, 1)
                ]))),
      );
    } else {
      return Scaffold(
        body: Login(
            primaryColor: Color(0xFF4aa0d5),
            backgroundColor: Colors.white,
            backgroundImage: new AssetImage("assets/sonic-black.png"),
            onSuccess: (DocumentSnapshot d) {
              this.setState(() {
                loginState = true;
                selectedTab = 0;
                prefs.setBool("login", true);
                prefs.setString("id", d.documentID);
                prefs.setString("name", d.data["name"]);
                prefs.setString("photo", d.data["photo"]);
                prefs.setString("accountNo", d.data["accountNo"]);
                user = d.data;
              });
              dRef = Firestore.instance
                  .collection("accounts")
                  .document(d.documentID);
            }),
      );
    }
  }
}
