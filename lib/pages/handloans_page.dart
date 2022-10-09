import 'package:flutter/material.dart';
import 'package:handloans/models/account.dart';
import 'package:handloans/models/handloan.dart';
import 'package:handloans/forms/handloan_form.dart';
import 'package:handloans/views/common_tile.dart';
import 'package:handloans/views/handloan_tile.dart';
import 'package:handloans/pages/transactions_page.dart';
import 'package:handloans/models/constants.dart';

class HandloansPage extends StatefulWidget {

  Account account;
  HandloansPage({Key? key, required this.account}) : super(key: key);

  @override
  State<HandloansPage> createState() => _HandloansPageState();
}

class _HandloansPageState extends State<HandloansPage> {

  var account;

  var handloans = [];

  fetchHandloans() async {
    print("fetching handloans...");
    handloans = await account.fetchHandloans();
    setState(() {});
  }

  Future _presentHandloanForm(BuildContext context, Handloan? handloan) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return HandloanForm(handloan: handloan);
            },
            fullscreenDialog: true
        )
    );

    print(result);

    if (result != null) {
      result.accountID = account.id;
      await result.save();
      fetchHandloans();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text("Handloan updated")));
    }
  }

  Future _presentTransactionsPage(BuildContext context, Handloan handloan) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return TransactionsPage(handloan: handloan);
            }
        )
    );
  }

  Future _deleteHandloan(Handloan handloan) async {
    await handloan.deleteTransactions();
    await handloan.delete();

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Handloan deleted")));

    fetchHandloans();
  }

  _showAlertDialog(BuildContext context, Handloan handloan) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete handloan '${handloan.name}' ?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete?\n'),
                Text('Handloan once deleted cannot be recovered!')
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
                _deleteHandloan(handloan);
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

  @override
  void initState() {
    super.initState();
    account = widget.account;
    fetchHandloans();
  }

  @override
  Widget build(BuildContext context) {

    callback(ActionType type, Handloan handloan) {
      print("ACTION: $type, CALLBACK: $handloan");
      switch(type) {
        case ActionType.tap: {
          _presentTransactionsPage(context, handloan);
        }
        break;

        case ActionType.edit: {
          _presentHandloanForm(context, handloan);
        }
        break;

        case ActionType.delete: {
          _showAlertDialog(context, handloan);
        }
        break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Handloans"),
        backgroundColor: AppTheme.handloansColor,
        actions: [
          TextButton.icon(
            icon: const Icon(
              Icons.add_box_rounded,
              size: 26.0,
            ),
            label: const Text(""),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              _presentHandloanForm(context, null);
            },
          ),
          TextButton.icon(
            icon: const Icon(
              Icons.refresh_rounded,
              size: 22.0
            ),
            label: const Text(""),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () {
              fetchHandloans();
            },
          )
        ]
      ),
      body: ListView.builder(
        itemCount: handloans.length+1,
        itemBuilder: (context, index) {
          if(index == handloans.length) {
            return const SizedBox(height: 20.0);
          }
          return HandloanTile(handloan: handloans[index], callback: callback);
        },
      ),
    );
  }
}
