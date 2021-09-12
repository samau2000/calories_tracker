import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/auth/authentication.dart';
import 'package:test_app/pages/sign_in.dart';
import 'package:http/http.dart' as http;

class BarcodeScreen extends StatefulWidget {
  const BarcodeScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  late User _user;
  bool _isSigningOut = false;
  String _scanBarcode = 'Unknown';
  String _json = '';

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  Future<void> listRecipes() async {}

  Future<void> listCalories() async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'Content-type': 'application/json',
      'X-Api-Key': 'NGL5F8A54IfSZhLLq0g60jFUZ3IdCLXQVqex7A8h',
    };

    Map<String, String> body = {
      'query': _scanBarcode,
      'sortBy': 'dataType.keyword',
      'sortOrder': 'asc',
    };

    var body_json = json.encode(body);

    final response = await http.post(
      Uri.parse('https://api.nal.usda.gov/fdc/v1/foods/search'),
      headers: headers,
      body: body_json,
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    setState(() {
      _json = responseJson['foods'][0]['foodNutrients'][3]['nutrientNumber'];
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // try/catch PlatfromException is used to account for when platform messages fail.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    listCalories();
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Calories Tracker')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => listRecipes(),
                            child: Text('Find Recipes')),
                        Text('Scan result : $_json\n',
                            style: TextStyle(fontSize: 20)),
                        SizedBox(height: 16.0),
                        _isSigningOut
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.redAccent,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _isSigningOut = true;
                                  });
                                  await Authentication.signOut(
                                      context: context);
                                  setState(() {
                                    _isSigningOut = false;
                                  });
                                  Navigator.of(context)
                                      .pushReplacement(_routeToSignInScreen());
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Text(
                                    'Sign Out',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                      ]));
            })));
  }
}
