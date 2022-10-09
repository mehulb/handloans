import 'package:flutter/material.dart';
import 'package:handloans/models/constants.dart';
import 'package:handloans/models/handloan.dart';

class HandloanForm extends StatefulWidget {

  Handloan? handloan;
  HandloanForm({this.handloan});

  @override
  State<HandloanForm> createState() => _HandloanFormState();
}

class _HandloanFormState extends State<HandloanForm> {

  final _formKey = GlobalKey<FormState>();

  var selectedDate = DateTime.now();

  var _id = UniqueKey().toString();
  var _type = handloanTypeLend;
  var _name = "";
  var _datetime = DateTime.now().microsecondsSinceEpoch.toString();
  var _amount = 0.0;
  var _comments = "";
  var _accountID = "";

  @override
  void initState() {
    super.initState();

    if (widget.handloan != null) {
      _id = widget.handloan?.id;
      _type = widget.handloan?.type;
      _name = widget.handloan?.name;
      _datetime = widget.handloan?.datetime;
      _amount = widget.handloan?.amount;
      _comments = widget.handloan?.comments;
      _accountID = widget.handloan?.accountID;

      var interval = int.tryParse(widget.handloan?.datetime);
      if (interval != null) {
        selectedDate = DateTime.fromMicrosecondsSinceEpoch(interval);
      }
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
        backgroundColor: AppTheme.handloansColor,
        title: const Text("Add/Edit Handloan"),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // InputTextField(
              //     initialValue: _name,
              //     labelText: "Name",
              //     isRequired: true,
              //     onChanged: (value) {
              //       setState(() {
              //         _name = value;
              //       });
              //     }
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: handloanTypeLend,
                    groupValue: _type,
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          _type = value;
                        }
                      });
                    },
                  ),
                  const Text("Lend"),
                  const SizedBox(width: 20.0),
                  Radio<String>(
                    value: handloanTypeBorrow,
                    groupValue: _type,
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          _type = value;
                        }
                      });
                    },
                  ),
                  const Text("Borrow")
                ],
              ),
              const SizedBox(height: 20.0),
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
                    var hl = Handloan(id: _id, type: _type, name: _name, datetime: _datetime, amount: _amount, comments: _comments, accountID: _accountID);
                    Navigator.pop(context, hl);
                  },
                  child: const Text("Save")
              )
            ],
          ),
        ),
      ),
    );
  }
}
