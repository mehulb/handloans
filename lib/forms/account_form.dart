import 'package:flutter/material.dart';
import 'package:handloans/models/account.dart';
import 'package:handloans/models/constants.dart';

class AccountForm extends StatefulWidget {

  Account? account;
  AccountForm({this.account});

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {

  final _formKey = GlobalKey<FormState>();

  var _id = UniqueKey().toString();
  var _name = "";
  var _comments = "";

  @override
  void initState() {
    super.initState();

    if (widget.account != null) {
      _id = widget.account?.id;
      _name = widget.account?.name;
      _comments = widget.account?.comments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add/Edit Account",
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w200,
                      fontSize: 42.0
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_outlined,
                      size: 42.0,
                      color: Colors.black54
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              const SizedBox(height: 20.0),
              InputTextField(
                initialValue: _name,
                labelText: "Name",
                isRequired: true,
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
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
              SizedBox(
                height: 48.0,
                child: ElevatedButton(
                  onPressed: (){
                    var acc = Account(id: _id, name: _name, comments: _comments);
                    Navigator.pop(context, acc);
                  },
                  child: const Text("Save"),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 32),
                    primary: const Color(0xFFFD5E58)
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
