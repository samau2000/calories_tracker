import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/pages/recipes.dart';
import 'package:test_app/pages/daily_food.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:test_app/pages/home.dart';

class FoodInfoScreen extends StatefulWidget {
  const FoodInfoScreen({Key? key, required User user, required String barcode})
      : _user = user,
        _barcode = barcode,
        super(key: key);

  final User _user;
  final String _barcode;

  @override
  _FoodInfoScreenState createState() => _FoodInfoScreenState();
}

class _FoodInfoScreenState extends State<FoodInfoScreen> {
  late User _user;
  String _barcode = 'Unknown';
  dynamic _json = '';
  dynamic _calories = 0;
  dynamic _foodname = '';
  dynamic _ncalories = 0;

  @override
  void initState() {
    _user = widget._user;
    _barcode = widget._barcode;
    listCalories();
    super.initState();
  }

  Future<void> listRecipes() async {}

  Future<void> dailyTracker() async {
    final dbRef = FirebaseDatabase.instance.reference().child("Daily Food");
    dbRef.push().set({
      "name": _foodname,
      "calories": _calories,
    });

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => DailyFoodScreen(
              user: _user,
            )));
  }

  Future<void> listCalories() async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'Content-type': 'application/json',
      'X-Api-Key': 'NGL5F8A54IfSZhLLq0g60jFUZ3IdCLXQVqex7A8h',
    };

    Map<String, String> body = {
      'query': _barcode,
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
    print(responseJson['foods'][0]);
    print(responseJson['foods'][0]['foodNutrients'][3]);
    setState(() {
      _json = responseJson;
      _calories = responseJson['foods'][0]['foodNutrients'][3]['value'];
      _ncalories = _calories;
      _foodname = responseJson['foods'][0]['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Calories Tracker'),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => BarcodeScreen(
                          user: _user,
                        ),
                      ),
                    );
                  },
                )),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("\n Calories per serving : $_ncalories\n",
                            style: TextStyle(fontSize: 18)),
                        ElevatedButton(
                            onPressed: () => dailyTracker(),
                            child: Text('Save to daily tracker')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => listRecipe(
                                    user: _user,
                                    calories: _ncalories,
                                    foodname: _foodname,
                                  ),
                                ),
                              );
                            },
                            child: Text('Add to recipe')),
                        Text("\n Please choose the number of servings: ",
                            style: TextStyle(fontSize: 15)),
                        SizedBox(
                            width: 200,
                            child: SpinBox(
                              min: 1,
                              max: 100,
                              value: 1,
                              onChanged: (value) =>
                                  _ncalories = _ncalories + _calories,
                            ))
                      ]));
            })));
  }
}
