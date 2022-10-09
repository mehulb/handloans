import 'package:flutter/material.dart';
import 'package:handloans/pages/accounts_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: false),
    debugShowCheckedModeBanner: false,
    initialRoute: "/accounts",
    routes: {
      "/accounts": (context) => const AccountsPage(),
    },
  ));
}