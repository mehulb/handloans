import 'package:flutter/material.dart';
import 'package:handloans/models/constants.dart';
import 'package:handloans/models/handloan.dart';
import 'package:handloans/views/common_tile.dart';
import 'package:intl/intl.dart';

class HandloanTile extends StatelessWidget {

  final Handloan handloan;
  final callback;
  
  HandloanTile({required this.handloan, this.callback});

  final formatCurrency = NumberFormat.currency(locale: "en_IN", symbol: "", decimalDigits: 0);

  _callback(ActionType type) {
    callback(type, handloan);
  }

  @override
  Widget build(BuildContext context) {
    return CommonTile(
        leftTitle: handloan.type == handloanTypeBorrow ? "Borrowed" : "Lent",
        leftSubtitle: handloan.comments,
        rightTitle: formatCurrency.format(handloan.balance),
        rightSubtitle: formatCurrency.format(handloan.amount),
        callback: _callback
    );
    // return GestureDetector(
    //   onTap: (){
    //     callback(handloan);
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
    //                   handloan.name,
    //                   style: const TextStyle(
    //                       fontSize: 24.0
    //                   ),
    //                 ),
    //                 Text(
    //                   handloan.comments,
    //                   style: const TextStyle(
    //                       color: Colors.black26
    //                   ),
    //                 )
    //               ]
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               Text(
    //                 "${handloan.balance}",
    //                 style: const TextStyle(
    //                   fontSize: 38.0,
    //                   fontWeight: FontWeight.w200,
    //                   color: Colors.indigo,
    //                   // fontWeight: FontWeight.bold
    //                 ),
    //               ),
    //               Text(
    //                 "${handloan.amount}",
    //                 style: const TextStyle(
    //                   fontSize: 14.0,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.black45,
    //                   // fontWeight: FontWeight.bold
    //                 ),
    //               ),
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
