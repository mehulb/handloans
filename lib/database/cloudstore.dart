import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handloans/models/account.dart';
import 'package:handloans/models/handloan.dart';
import 'package:handloans/models/transaction.dart' as hl;

class CloudStore {
  CloudStore._();
  static final CloudStore shared = CloudStore._();

  // static const String _collectionsPath = "handloans/b.mehul.p/";
  static const String _collectionsPath = "handloans/dummy/";
  final CollectionReference _accountsRef = FirebaseFirestore.instance.collection(_collectionsPath+"accounts");
  final CollectionReference _handloansRef = FirebaseFirestore.instance.collection(_collectionsPath+"handloans");
  final CollectionReference _transactionsRef = FirebaseFirestore.instance.collection(_collectionsPath+"transactions");

  // setup() {
  //   final docRef = FirebaseFirestore.instance.collection("handloans").doc("b.mehul.p");
  //   docRef.get()
  //       .then((DocumentSnapshot doc) {
  //     final data = doc.data() as Map<String, dynamic>;
  //     print("Data: $data");
  //   })
  //       .catchError((error) {
  //     print("Failed to fetch: $error");
  //   });
  // }

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _accountsRef.get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
  }

  Future syncAccounts(List accounts) async {
    for (Account acc in accounts) {
      updateAccount(acc);
    }
  }
  Future updateAccount(Account acc) async {
    await _accountsRef
        .doc(acc.id)
        .set(acc.toMap())
        .then((value) {
      print("Account Updated: ${acc.name}");
      syncHandloans(acc.handloans);
    })
        .catchError((e) {
      print("Error updating account: $e");
    });
  }
  Future deleteAccount(Account acc) async {
    await _accountsRef
        .doc(acc.id)
        .delete()
        .then((value) {
      print("Account deleted: ${acc.name}");
    })
        .catchError((e) {
      print("Error deleting account: $e");
    });
  }
  
  Future syncHandloans(List handloans) async {
    for (Handloan hl in handloans) {
      updateHandloan(hl);
    }
  }
  Future updateHandloan(Handloan hl) async {
    _handloansRef
        .doc(hl.id)
        .set(hl.toMap())
        .then((value) {
      print("Handloan updated: ${hl.name}");
      syncTransactions(hl.transactions);
    })
        .catchError((error) {
      print("Failed to update handloan: $error");
    });
  }
  Future deleteHandloan(Handloan hl) async {
    await _handloansRef
        .doc(hl.id)
        .delete()
        .then((value) {
      print("Handloan deleted: ${hl.name}");
    })
        .onError((e, _) {
      print("Error deleting handloan: $e");
    });
  }

  Future syncTransactions(List transactions) async {
    for (hl.Transaction tr in transactions) {
      updateTransaction(tr);
    }
  }
  Future updateTransaction(hl.Transaction tr) async {
    _transactionsRef
        .doc(tr.id)
        .set(tr.toMap())
        .then((value) {
      print("Transaction updated: ${tr.amount}");
    })
        .catchError((error) {
      print("Failed to update transaction: $error");
    });
  }
  Future deleteTransaction(hl.Transaction tr) async {
    await _accountsRef
        .doc(tr.id)
        .delete()
        .then((value) {
      print("Transaction deleted: ${tr.amount}");
    })
        .catchError((e) {
      print("Error deleting transaction: $e");
    });
  }

// Future addAccount(Account acc) async {
//   return _accountsRef
//       .add(acc.toMap())
//       .then((value) {
//         print("Account Added");
//       })
//       .catchError((error) {
//         print("Failed to add account: $error");
//       });
// }
// Future addHandloan(Handloan hl) async {
//   return _handloansRef
//       .add(hl.toMap())
//       .then((value) {
//         print("Handloan Added");
//       })
//       .catchError((error) {
//         print("Failed to add handloan: $error");
//       });
// }
// Future addTransaction(hl.Transaction tr) async {
//   return _transactionsRef
//       .add(tr.toMap())
//       .then((value) {
//         print("Transaction Added");
//       })
//       .catchError((error) {
//         print("Failed to add transaction: $error");
//       });
// }
//   Future delete({required var item, required CollectionReference collectionRef}) async {
//     await collectionRef
//         .doc(item.id)
//         .delete()
//         .then((value) {
//       print("Item deleted: ${item.id}");
//     })
//         .onError((e, _) {
//       print("Error deleting item: $e");
//     });
//   }
}