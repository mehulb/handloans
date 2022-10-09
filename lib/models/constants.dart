import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

// database table and column names
const String tblAccounts = "accounts";
const String tblHandloans = "handloans";
const String tblTransactions = "transactions";
const String colID = "id";
const String colName = "name";
const String colComments = "comments";
const String colType = "type";
const String colDatetime = "datetime";
const String colAmount = "amount";
const String colAccountID = "accountId";
const String colHandloanID = "handloanId";

const String handloanTypeBorrow = "borrow";
const String handloanTypeLend = "lend";

const String transactionTypeSend = "send";
const String transactionTypeReceive = "receive";

Widget InputTextField({
  String initialValue = "",
  String labelText = "",
  TextInputType keyboardType = TextInputType.name,
  bool isRequired = false,
  ValueChanged? onChanged
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
    child: TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.black.withOpacity(0.05),
        labelText: labelText,
        floatingLabelStyle: const TextStyle(
          fontSize: 14.0,
          // color: Colors.black45,
        ),
        focusedBorder: const UnderlineInputBorder(
            // borderSide: BorderSide(color: Colors.teal)
        ),
        helperText: isRequired ? "required": null,
      ),
      onChanged: onChanged,
    ),
  );
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}

class AppTheme {
  static const accountsColor = Colors.blue;
  static const handloansColor = Colors.red;
  static const transactionsColor = Colors.green;
}


var logger = Logger(
  // printer: PrettyPrinter(
  //     methodCount: 1, // number of method calls to be displayed
  //     errorMethodCount: 8, // number of method calls if stacktrace is provided
  //     lineLength: 120, // width of the output
  //     colors: false, // Colorful log messages
  //     printEmojis: true, // Print an emoji for each log message
  //     printTime: false, // Should each log print contain a timestamp
  // ),
  printer: SimplePrinter()
);
