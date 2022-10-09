import 'package:handloans/database/cloudstore.dart';
import 'package:handloans/database/data_handler.dart';
import 'package:handloans/models/constants.dart';

class Transaction {
  var id;
  var type;
  var datetime;
  var amount;
  var comments;
  var handloanID;

  Transaction({
    this.id,
    this.type,
    this.datetime,
    this.amount,
    this.comments,
    this.handloanID
  });

  static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map[colID],
      type: map[colType],
      datetime: map[colDatetime],
      amount: map[colAmount],
      comments: map[colComments],
      handloanID: map[colHandloanID]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      colID: id,
      colType: type,
      colDatetime: datetime,
      colAmount: amount,
      colComments: comments,
      colHandloanID: handloanID
    };
  }

  static Future<Transaction?> forID(String id) async {
    List<Map<String, dynamic>> maps = await DataHandler.shared.fetch(tableName: tblTransactions, key: colID, value: id);
    if (maps.isNotEmpty) {
      var map = maps[0];
      var ts = Transaction.fromMap(map);
      print(ts);
      return ts;
    }
    return null;
  }
  Future save() async {
    if (handloanID == "") {
      print("Transaction save ERROR: handloanID is empty/invalid");
      return;
    }
    await DataHandler.shared.insert(map: toMap(), tableName: tblTransactions);
    await CloudStore.shared.updateTransaction(this);
  }
  Future delete() async {
    await DataHandler.shared.delete(tableName: tblTransactions, key: colID, value: id);
    await CloudStore.shared.deleteTransaction(this);
  }
}