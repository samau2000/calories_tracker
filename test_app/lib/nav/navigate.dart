import 'package:test_app/pages/sign_in.dart';
import 'package:test_app/pages/home.dart';
import 'package:flutter/material.dart';

class Navigate {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/sign-in': (context) => SignInPage(),
    '/home': (context) => HomePage(),
  };
}
