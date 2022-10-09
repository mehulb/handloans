import 'package:flutter/material.dart';
import 'package:handloans/models/transaction.dart';
import 'package:handloans/models/handloan.dart';
import 'package:handloans/forms/transaction_form.dart';
import 'package:handloans/views/transaction_tile.dart';
import 'package:handloans/views/common_tile.dart';
import 'package:handloans/models/constants.dart';

class TransactionsPage extends StatefulWidget {

  Handloan handloan;
  TransactionsPage({required this.handloan});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {

  var handloan;

  var transactions = [];

  fetchTransactions() async {
    print("fetching transactions...");
    transactions = await handloan.fetchTransactions();
    setState(() {});
  }

  Future _presentTransactionForm(BuildContext context, Transaction? transaction) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return TransactionForm(transaction: transaction, handloanType: handloan.type);
            },
            fullscreenDialog: true
        )
    );

    print(result);

    if (result != null) {
      result.handloanID = handloan.id;
      await result.save();
      fetchTransactions();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text("Transaction updated")));
    }
  }

  Future _deleteTransaction(Transaction transaction) async {
    await transaction.delete();

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Transaction deleted")));

    fetchTransactions();
  }

  _showAlertDialog(BuildContext context, Transaction transaction) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete transaction?"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete?\n'),
                Text('Transaction once deleted cannot be recovered!')
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
                _deleteTransaction(transaction);
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
    handloan = widget.handloan;
    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {

    callback(ActionType type, Transaction transaction) {
      print("ACTION: $type, CALLBACK: $transactions");
      switch(type) {
        case ActionType.tap: {
          print("ignore card tapping");
        }
        break;

        case ActionType.edit: {
          _presentTransactionForm(context, transaction);
        }
        break;

        case ActionType.delete: {
          _showAlertDialog(context, transaction);
        }
        break;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          title: const Text("Transactions"),
          backgroundColor: AppTheme.transactionsColor,
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
                _presentTransactionForm(context, null);
              },
            )
          ]
      ),
      body: ListView.builder(
        itemCount: transactions.length+1,
        itemBuilder: (context, index) {
          if(index == transactions.length) {
            return const SizedBox(height: 20.0);
          }
          return TransactionTile(transaction: transactions[index], callback: callback);
        },
      ),
    );
  }
}
