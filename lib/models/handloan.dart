import 'package:handloans/database/cloudstore.dart';
import 'package:handloans/database/data_handler.dart';
import 'package:handloans/models/constants.dart';
import 'package:handloans/models/transaction.dart';

class Handloan {
  var id;
  var type;
  var name;
  var datetime;
  var amount;
  var comments;
  var accountID;

  var transactions = [];

  var balance = 0.0;

  Handloan({
    this.id,
    this.type,
    this.name,
    this.datetime,
    this.amount,
    this.comments,
    this.accountID
  });

  static Handloan fromMap(Map<String, dynamic> map) {
    return Handloan(
      id: map[colID],
      type: map[colType],
      name: map[colName],
      datetime: map[colDatetime],
      amount: map[colAmount],
      comments: map[colComments],
      accountID: map[colAccountID]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      colID: id,
      colType: type,
      colName: name,
      colDatetime: datetime,
      colAmount: amount,
      colComments: comments,
      colAccountID: accountID
    };
  }

  static Future<Handloan?> forID(String id) async {
    List<Map<String, dynamic>> maps = await DataHandler.shared.fetch(tableName: tblHandloans, key: colID, value: id);
    if (maps.isNotEmpty) {
      var map = maps[0];
      var hl = Handloan.fromMap(map);
      print(hl);
      return hl;
    }
    return null;
  }
  Future<List<Transaction>> fetchTransactions() async {
    List<Map<String, dynamic>> maps = await DataHandler.shared.fetch(tableName: tblTransactions, key: colHandloanID, value: id);
    return List.generate(maps.length, (index) {
      var ts = Transaction.fromMap(maps[index]);
      print(ts);
      return ts;
    });
  }
  Future save() async {
    if (accountID.length == 0) {
      print("Handloan Save ERROR: accountID is empty");
      return;
    }
    await DataHandler.shared.insert(map: toMap(), tableName: tblHandloans);
    await CloudStore.shared.updateHandloan(this);
  }
  Future delete() async {
    await DataHandler.shared.delete(tableName: tblHandloans, key: colID, value: id);
    await CloudStore.shared.deleteHandloan(this);
  }
  Future deleteTransactions() async {
    await DataHandler.shared.delete(tableName: tblTransactions, key: colHandloanID, value: id);
    for (Transaction tr in transactions) {
      await CloudStore.shared.deleteTransaction(tr);
    }
  }
  // Future<double> calculateBalance() async {
  //   var amount = 0.0;
    // var ts = await transactions();
    // for (var t in ts) {
    //   amount += t.amount;
    // }
    // return this.amount - amount;
  // }
  double calculateBalance() {
    var amount = 0.0;
    var ts = transactions;
    if (ts.length > 0) {
      for (var t in ts) {
        amount += t.amount;
      }
    }
    return this.amount - amount;
  }
}