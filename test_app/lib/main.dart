import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_app/pages/sign_in.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Google Sign In",
      home: SignInScreen(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
