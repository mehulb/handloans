import 'package:flutter/material.dart';
import 'package:handloans/database/cloudstore.dart';
import 'package:handloans/database/data_handler.dart';
import 'package:handloans/models/account.dart';
import 'package:handloans/forms/account_form.dart';
import 'package:handloans/models/constants.dart';
import 'package:handloans/models/handloan.dart';
import 'package:handloans/models/transaction.dart' as hl;
import 'package:handloans/pages/drawer_page.dart';
import 'package:handloans/views/account_tile.dart';
import 'package:handloans/pages/handloans_page.dart';
import 'package:handloans/views/common_tile.dart';
import 'package:intl/intl.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {

  var accounts = [];

  final formatCurrency = NumberFormat.currency(locale: "en_IN", symbol: "", decimalDigits: 0);

  fetchAccounts() async {
    accounts = await AccountDatabase.all();
    setState(() {});
  }
  cleanUp() async {
    await DataHandler.shared.cleanUp();
  }

  Future _presentAccountForm(BuildContext context, Account? account) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AccountForm(account: account);
        },
        fullscreenDialog: true
      )
    );

    print(result);

    if (result != null) {
      await result.save();
      fetchAccounts();
      ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text("Account updated")));
    }
  }

  Future _presentHandloansPage(BuildContext context, Account account) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HandloansPage(account: account);
        }
      )
    );
  }

  Future _deleteAccount(Account account) async {
    for (Handloan hl in account.handloans) {
      await hl.deleteTransactions();
    }
    await account.deleteHandloans();
    await account.delete();

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Account deleted")));

    fetchAccounts();
  }

  _showAlertDialog(BuildContext context, Account account) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete account '${account.name}' ?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete?\n'),
                Text('Account once deleted cannot be recovered!')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(account);
              },
            ),
            TextButton(
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double totalBorrowed() {
    var balance = 0.0;
    for (Account acc in accounts) {
      if (acc.balance < 0) {
        balance += acc.balance;
      }
    }
    return balance;
  }
  double totalLent() {
    var balance = 0.0;
    for (Account acc in accounts) {
      if (acc.balance > 0) {
        balance += acc.balance;
      }
    }
    return balance;
  }

  @override
  void initState() {
    super.initState();
    // cleanUp();
    // loadDefaultRecords();
    fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {

    callback(ActionType type, Account account) {
      print("ACTION: $type, CALLBACK: $account");
      switch(type) {
        case ActionType.tap: {
          _presentHandloansPage(context, account);
        }
        break;

        case ActionType.edit: {
          _presentAccountForm(context, account);
        }
        break;

        case ActionType.delete: {
          _showAlertDialog(context, account);
        }
        break;
      }
    }

    drawerTileCallback(DrawerTileTapAction action) {
      print("DrawerAction: $action");
    }

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF3E3D4F),
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Accounts",
          style: TextStyle(
            fontSize: 42.0,
            fontWeight: FontWeight.w200
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color(0x00000000),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_outlined,
              size: 36.0,
              color: Colors.white,
            ),
            onPressed: () {
              _presentAccountForm(context, null);
            },
          ),
          IconButton(
            icon: const Icon(
                Icons.refresh_outlined,
                size: 30.0,
              color: Colors.white,
            ),
            onPressed: () {
              fetchAccounts();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.cloud_upload_outlined,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: () {
              CloudStore.shared.syncAccounts(accounts);
            },
          )
        ]
      ),
      body: ListView.builder(
        itemCount: accounts.length+1,
        itemBuilder: (context, index) {
          if(index == accounts.length) {
            return const SizedBox(height: 0.0);
          }
          return AccountTile(account: accounts[index], callback: callback);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        color: const Color(0x00FD5E58),
        child: Container(
          height: 108.0,
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 5.0,
                  color: Colors.red[300],
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Card(
                          elevation: 0.0,
                          color: Colors.black54,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 4.0),
                            child: Text(
                              "BORROWED",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0
                              ),
                            ),
                          ),
                        ),
                        Text(
                          formatCurrency.format(totalBorrowed()),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 42.0,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    )
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  shadowColor: Colors.black,
                  elevation: 5.0,
                  color: Colors.green[300],
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 8.0, 8.0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Card(
                            elevation: 0.0,
                            color: Colors.black54,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 4.0),
                              child: Text(
                                "LENT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0
                                ),
                              ),
                            ),
                          ),
                          Text(
                            formatCurrency.format(totalLent()),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 42.0,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: DrawerPage(callback: drawerTileCallback),
    );
  }

  loadDefaultRecords() async {
    var acc1 = Account(id: UniqueKey().toString(), name: "Adam", comments: "No comments");
    await acc1.save();
    var hl11 = Handloan(id: UniqueKey().toString(), type: handloanTypeLend, name: "Bike loan", datetime: DateTime.now().microsecondsSinceEpoch.toString(), amount: 80000, comments: "Cash", accountID: acc1.id);
    hl11.save();
    var hl12 = Handloan(id: UniqueKey().toString(), type: handloanTypeLend, name: "misc", datetime: DateTime.now().microsecondsSinceEpoch.toString(), amount: 20000, comments: "phone pe", accountID: acc1.id);
    hl12.save();

    var acc2 = Account(id: UniqueKey().toString(), name: "Sofie", comments: "do we need comments");
    await acc2.save();
    var hl21 = Handloan(id: UniqueKey().toString(), type: handloanTypeLend, name: "", datetime: DateTime.now().microsecondsSinceEpoch.toString(), amount: 8000, comments: "gpay", accountID: acc2.id);
    hl21.save();

    var acc3 = Account(id: UniqueKey().toString(), name: "Harry", comments: "yes we need comments");
    await acc3.save();
    var hl31 = Handloan(id: UniqueKey().toString(), type: handloanTypeBorrow, name: "emergency", datetime: DateTime.now().microsecondsSinceEpoch.toString(), amount: 100000, comments: "transfer", accountID: acc3.id);
    hl31.save();
    var tr311 = hl.Transaction(id: UniqueKey().toString(), type: transactionTypeSend, datetime: DateTime.now().microsecondsSinceEpoch.toString(), amount: 20000, comments: "cash", handloanID: hl31.id);
    tr311.save();
    var tr312 = hl.Transaction(id: UniqueKey().toString(), type: transactionTypeSend, datetime: DateTime.now().microsecondsSinceEpoch.toString(), amount: 35000, comments: "phonepe", handloanID: hl31.id);
    tr312.save();

    setState(() {});
  }
}

