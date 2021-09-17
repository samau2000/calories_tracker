import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/pages/home.dart';

class DailyFoodScreen extends StatefulWidget {
  const DailyFoodScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _DailyFoodScreenState createState() => _DailyFoodScreenState();
}

class _DailyFoodScreenState extends State<DailyFoodScreen> {
  late User _user;
  final dbRef = FirebaseDatabase.instance.reference().child("Daily Food");
  List<Map<dynamic, dynamic>> lists = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Daily Intake"),
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
        body: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                Map<dynamic, dynamic> values = snapshot.data!.value;
                values.forEach((key, values) {
                  lists.add(values);
                });
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Name: " + lists[index]["name"]),
                            Text("Calories: " +
                                lists[index]["calories"].toString()),
                            // Text("Type: " + lists[index]["type"]),
                          ],
                        ),
                      );
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}
