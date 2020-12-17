import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  final String transactionView;
  final void Function(String) onViewChange;

  Filter({Key key, this.transactionView,this.onViewChange}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: <Widget>[
          GestureDetector(
              onTap: () {
                widget.onViewChange("ALL");
              },
              child: Container(
                child: Text(
                  "All",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.grey[900]),
                ),
                decoration: BoxDecoration(
                    color: widget.transactionView == "ALL"
                        ? Colors.blue[200]
                        : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 10.0,
                          spreadRadius: 4.5)
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              )),
          SizedBox(
            width: 16,
          ),
          GestureDetector(
              onTap: () {
                widget.onViewChange("INCOME");
              },
              child: Container(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.green,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Income",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.grey[900]),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: widget.transactionView == "INCOME"
                        ? Colors.green[200]
                        : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 10.0,
                          spreadRadius: 4.5)
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              )),
          SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
                widget.onViewChange("EXPENSES");
            },
            child: Container(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Expenses",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.grey[900]),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: widget.transactionView == "EXPENSES"
                      ? Colors.red[200]
                      : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 10.0,
                        spreadRadius: 4.5)
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          )
        ],
      ),
    );
  }
}
