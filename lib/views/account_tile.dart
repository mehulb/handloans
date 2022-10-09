import 'package:flutter/material.dart';
import 'package:handloans/views/common_tile.dart';
import 'package:handloans/models/account.dart';
import 'package:intl/intl.dart';

class AccountTile extends StatelessWidget {

  Account account;
  final callback;
  AccountTile({required this.account, this.callback});

  final formatCurrency = NumberFormat.currency(locale: "en_IN", symbol: "", decimalDigits: 0);

  _callback(ActionType type) {
    callback(type, account);
  }

  @override
  Widget build(BuildContext context) {
    return CommonTile(
      leftTitle: account.name,
      leftSubtitle: account.comments,
      rightTitle: formatCurrency.format(account.balance),
      rightSubtitle: formatCurrency.format(account.total),
      callback: _callback
    );
    // return GestureDetector(
    //   onTap: (){
    //     callback(account);
    //   },
    //   child: Card(
    //     margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
    //     child: Padding(
    //       padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 account.name,
    //                 style: const TextStyle(
    //                   fontSize: 24.0
    //                 ),
    //               ),
    //               Text(
    //                 account.comments,
    //                 style: const TextStyle(
    //                   color: Colors.black26
    //                 ),
    //               )
    //             ]
    //           ),
    //           Text(
    //             "${account.balance}",
    //             style: const TextStyle(
    //                 fontSize: 38.0,
    //                 color: Colors.indigo,
    //                 fontWeight: FontWeight.w200
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
