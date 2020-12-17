import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatelessWidget {
  final Map transaction;
  TransactionWidget({this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(Radius.circular(18))),
            child: Icon(
              this.transaction["money"] == "in"
                  ? Icons.call_received
                  : Icons.call_made,
              color: Colors.lightBlue[900],
            ),
            padding: EdgeInsets.all(12),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.transaction["type"],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900]),
                ),
                Text(
                  this.transaction["msg"],
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "\₹" + this.transaction["amount"].toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: this.transaction["money"] == "in"
                        ? Colors.green
                        : Colors.red),
              ),
              Text(
                DateFormat("hh:mm:ss")
                    .format(this.transaction["date"].toDate()),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[500]),
              ),
              Text(
                DateFormat("dd/MM/yyyy")
                    .format(this.transaction["date"].toDate()),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
