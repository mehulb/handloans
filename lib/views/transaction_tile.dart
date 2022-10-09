import 'package:flutter/material.dart';
import 'package:handloans/models/constants.dart';
import 'package:handloans/views/common_tile.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {

  final transaction;
  final callback;

  TransactionTile({this.transaction, this.callback});

  final formatCurrency = NumberFormat.currency(locale: "en_IN", symbol: "", decimalDigits: 0);

  _callback(ActionType type) {
    callback(type, transaction);
  }

  @override
  Widget build(BuildContext context) {
    return CommonTile(
        leftTitle: transaction.type == transactionTypeSend ? "Sent" : "Received",
        leftSubtitle: transaction.comments,
        rightTitle: formatCurrency.format(transaction.amount),
      callback: _callback,
    );
    // return GestureDetector(
    //   onTap: (){
    //     callback(transaction);
    //   },
    //   child: Card(
    //     margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
    //     child: Padding(
    //       padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   transaction.name,
    //                   style: const TextStyle(
    //                       fontSize: 24.0
    //                   ),
    //                 ),
    //                 Text(
    //                   transaction.comments,
    //                   style: const TextStyle(
    //                       color: Colors.black26
    //                   ),
    //                 )
    //               ]
    //           ),
    //           Text(
    //             "${transaction.amount}",
    //             style: const TextStyle(
    //               fontSize: 38.0,
    //               color: Colors.indigo,
    //               // fontWeight: FontWeight.bold
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
