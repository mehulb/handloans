import 'package:flutter/material.dart';

enum ActionType {
  tap,
  edit,
  delete
}

class CommonTile extends StatelessWidget {

  final leftTitle;
  final leftSubtitle;
  final rightTitle;
  final rightSubtitle;
  final callback;
  CommonTile({required this.leftTitle, this.leftSubtitle, required this.rightTitle, this.rightSubtitle, this.callback});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child: InkWell(
        onTap: () {
          if (callback != null) {
            callback(ActionType.tap);
          } else {
            print("no callback");
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leftTitle,
                    style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                      // padding: const EdgeInsets.all(0.0),
                      alignment: Alignment.centerRight,
                      onPressed: () {
                        if (callback != null) {
                          callback(ActionType.edit);
                        } else {
                          print("no callback");
                        }
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.black45,
                        size: 16.0,
                      )
                  ),
                  IconButton(
                      // padding: const EdgeInsets.all(0.0),
                      alignment: Alignment.centerRight,
                      onPressed: () {
                        if (callback != null) {
                          callback(ActionType.delete);
                        } else {
                          print("no callback");
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 16.0,
                      )
                  ),

                ],
              ),
              const Divider(
                height: 0.0,
                thickness: 0.5,
                color: Colors.black45,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Card(
                    color: Colors.black54,
                    elevation: 0.0,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 4.0),
                      child: Text(
                        "BALANCE",
                        style: TextStyle(
                          fontSize: 8.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.black54,
                    elevation: 0.0,
                    child: Padding(
                      padding: rightSubtitle == null ? EdgeInsets.zero : const EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 4.0),
                      child: Text(
                        rightSubtitle == null ? "" : "TOTAL",
                        style: const TextStyle(
                          fontSize: 8.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rightTitle,
                    style: const TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    rightSubtitle ?? "",
                    style: const TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Divider(
                height: 0.0,
                thickness: 0.5,
                color: Colors.black45,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      leftSubtitle,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 16.0
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
