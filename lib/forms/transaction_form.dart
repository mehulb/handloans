import 'package:flutter/material.dart';
import 'package:handloans/models/transaction.dart';
import 'package:handloans/models/constants.dart';

class TransactionForm extends StatefulWidget {

  Transaction? transaction;
  String? handloanType;
  TransactionForm({this.transaction, this.handloanType});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {

  final _formKey = GlobalKey<FormState>();

  var selectedDate = DateTime.now();

  var _id = UniqueKey().toString();
  var _type = transactionTypeReceive;
  var _datetime = DateTime.now().microsecondsSinceEpoch.toString();
  var _amount = 0.0;
  var _comments = "";
  var _handloanID = "";

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      _id = widget.transaction?.id;
      _type = widget.transaction?.type;
      _datetime = widget.transaction?.datetime;
      _amount = widget.transaction?.amount;
      _comments = widget.transaction?.comments;
      _handloanID = widget.transaction?.handloanID;

      var interval = int.tryParse(widget.transaction?.datetime);
      if (interval != null) {
        selectedDate = DateTime.fromMicrosecondsSinceEpoch(interval);
      }
    }

    if (widget.handloanType != null) {
      _type = widget.handloanType == handloanTypeBorrow ? transactionTypeSend : transactionTypeReceive;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now()
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.transactionsColor,
        title: const Text("Add/Edit Transaction"),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: transactionTypeReceive,
                    groupValue: _type,
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          _type = value;
                        }
                      });
                    },
                    toggleable: false
                  ),
                  const Text("Receive"),
                  const SizedBox(width: 20.0),
                  Radio<String>(
                    value: transactionTypeSend,
                    groupValue: _type,
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          _type = value;
                        }
                      });
                    },
                    toggleable: false
                  ),
                  const Text("Send")
                ],
              ),
               */
              Text(
                "$_type".toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 36.0
                ),
              ),
              const SizedBox(height: 20.0),
              InputTextField(
                  initialValue: _amount == 0 ? "" : "$_amount",
                  labelText: "Amount",
                  keyboardType: TextInputType.number,
                  isRequired: true,
                  onChanged: (value) {
                    if (double.tryParse(value) != null) {
                      setState(() {
                        _amount = double.tryParse(value) ?? 0.0;
                      });
                    }
                  }
              ),
              SizedBox(
                height: 40.0,
                child: OutlinedButton(
                    onPressed: (){
                      _selectDate(context);
                    },
                    child: Text(
                        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"
                    )
                ),
              ),
              const SizedBox(height: 20.0),
              InputTextField(
                  initialValue: _comments,
                  labelText: "Comments",
                  onChanged: (value) {
                    setState(() {
                      _comments = value;
                    });
                  }
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  onPressed: (){
                    var tr = Transaction(id: _id, type: _type, datetime: _datetime, amount: _amount, comments: _comments, handloanID: _handloanID);
                    Navigator.pop(context, tr);
                  },
                  child: const Text("Save")
              )
            ],
          ),
        )
      ),
    );
  }
}
