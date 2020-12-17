import 'package:groovin_widgets/groovin_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';

void showAmount(var context, var pin, var balance) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Amount(pin: pin, balance: balance);
      });
}

class Amount extends StatefulWidget {
  final pin;
  final balance;
  Amount({Key key, this.pin, this.balance});
  @override
  _AmountState createState() => _AmountState();
}

class _AmountState extends State<Amount> {
  bool varified = false;
  String pin = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.varified = false;
  }

  void onSubmit(e) {
    if (e.toString() == widget.pin.toString()) {
      setState(() {
        varified = true;
      });
    } else {
      showAlertDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.varified
        ? Container(
            height: 300,
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ModalDrawerHandle(
                  handleColor: Colors.indigoAccent,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  'Available Balance is.',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  '₹ ' + widget.balance.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                      color: Colors.black),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: IconButton(
                    iconSize: 40,
                    splashColor: Colors.blueAccent,
                    icon: Icon(
                      Icons.replay,
                      color: Colors.blue,
                    ),
                  )),
            ]))
        : Container(
            height: MediaQuery.of(context).size.height / 1.1,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ModalDrawerHandle(
                    handleColor: Colors.indigoAccent,
                  ),
                ),
                SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: TextField(
                          obscureText: true,
                          onSubmitted: onSubmit,
                          onChanged: (v) {
                            setState(() {
                              pin = v;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter your PIN',
                          ),
                        ))),
                SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: NiceButton(
                          width: 120,
                          elevation: 8.0,
                          radius: 52.0,
                          icon: Icons.lock_open,
                          text: "Continue",
                          fontSize: 14.0,
                          background: Colors.blue,
                          onPressed: () {
                            onSubmit(this.pin);
                          },
                        ))),
              ],
            ),
          );
  }
}

showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text("Invalid PIN"),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
