import 'package:handloans/database/cloudstore.dart';
import 'package:handloans/database/data_handler.dart';
import 'package:handloans/models/handloan.dart';
import 'package:handloans/models/constants.dart';

class Account {
  var id;
  var name;
  var comments;

  var handloans = [];

  var total = 0.0;
  var balance = 0.0;

  Account({
    this.id,
    this.name,
    this.comments
  });

  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      id: map[colID],
      name: map[colName],
      comments: map[colComments]
    );
  }
  Map<String, dynamic> toMap() {
    return {
      colID: id,
      colName: name,
      colComments: comments
    };
  }


  double calculateBalance() {
    var amount = 0.0;
    var hls = handloans;
    if (hls.length > 0) {
      for (var hl in hls) {
        if (hl.type == handloanTypeBorrow) {
          amount -= hl.balance;
        } else {
          amount += hl.balance;
        }
        print("_BALANCE: ${hl.balance}");
      }
    }
    print("BALANCE: $amount");
    return amount;
  }
  double calculateTotal() {
    var amount = 0.0;
    var hls = handloans;
    if (hls.length > 0) {
      for (var hl in hls) {
        amount += hl.amount;
        print("_TOTAL: ${hl.amount}");
      }
    }
    print("TOTAL: $amount");
    return amount;
  }
}

extension AccountDatabase on Account {
  static Future<List<Account>> all() async {
    final List<Map<String, dynamic>> maps = await DataHandler.shared.fetch(tableName: tblAccounts);
    List<Account> accounts = [];
    for (var map in maps) {
      var acc = Account.fromMap(map);
      acc.handloans = await acc.fetchHandloans();
      acc.balance = acc.calculateBalance();
      acc.total = acc.calculateTotal();
      accounts.add(acc);
    }
    return accounts;
  }
  static Future<Account?> forID(String id) async {
    List<Map<String, dynamic>> maps = await DataHandler.shared.fetch(tableName: tblAccounts, key: colID, value: id);
    if (maps.isNotEmpty) {
      var map = maps[0];
      var acc = Account.fromMap(map);
      print(acc);
      return acc;
    }
    return null;
  }
  Future<List<Handloan>> fetchHandloans() async {
    List<Map<String, dynamic>> maps = await DataHandler.shared.fetch(tableName: tblHandloans, key: colAccountID, value: id);
    List<Handloan> hls = [];
    for (var map in maps) {
      var hl = Handloan.fromMap(map);
      hl.transactions = await hl.fetchTransactions();
      hl.balance = hl.calculateBalance();
      // print(hl);
      hls.add(hl);
    }
    return hls;
  }
  Future save() async {
    await DataHandler.shared.insert(map: toMap(), tableName: tblAccounts);
    await CloudStore.shared.updateAccount(this);
  }
  Future delete() async {
    await DataHandler.shared.delete(tableName: tblAccounts, key: colID, value: id);
    await CloudStore.shared.deleteAccount(this);
  }
  Future deleteHandloans() async {
    await DataHandler.shared.delete(tableName: tblHandloans, key: colAccountID, value: id);
    for (Handloan hl in handloans) {
      await CloudStore.shared.deleteHandloan(hl);
    }
  }
}
extension AccountCloudstore on Account {

}