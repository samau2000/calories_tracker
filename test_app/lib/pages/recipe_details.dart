import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//stl -->
class RecipeDetails extends StatelessWidget {
  const RecipeDetails({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  MyStaticListView createState() => MyStaticListView();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        appBar: new AppBar(title: Text("Pizza Recipe")),
        body: MyStaticListView(),
      ),
    );
  }
}

class MyStaticListView extends StatelessWidget {
  const MyStaticListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        ListTile(
          title: Text("Mushrooms"),
          subtitle: Text("4 servings | 543 calories"),
        ),
        ListTile(
          title: Text("flour"),
          subtitle: Text("5 servings | 50 calories"),
        ),
      ],
    );
  }
}
