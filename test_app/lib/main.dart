import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'nav/navigate.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Google Sign In",
      initialRoute: '/sign-in',
      routes: Navigate.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
