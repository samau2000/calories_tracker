//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_app/database/recipe_model.dart';
import 'package:test_app/database/firebase_database.dart';

/*
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.orange),
      home: MyApp(),
    ));
*/
Future<void> listC() async {}

class listRecipe extends StatefulWidget {
  const listRecipe({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  @override
  _listRecipeState createState() => _listRecipeState();
}

class _listRecipeState extends State<listRecipe> {
  late User _user;
  List recipe_old = <String>[];
  String input = "";
  final _formKey = GlobalKey<FormState>();
  String? name;

  // createRecipe() {
  //   DocumentReference documentReference =
  //       Firestore.instance.collection("MyRecipes").document(input);

  //   Map<String, String> recipes = {"recipesTitle": input};

  //   documentReference.setData(recipes).whenComplete(() {
  //     print("$input created");
  //   });
  // }

  // deleteRecipe() {}

  @override
  void initState() {
    // recipe.add("Salad");
    // recipe.add("Burger");
    // recipe.add("Fries");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Add Recipe"),
                    content: TextField(onChanged: (String value) {
                      input = value;
                    }),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => listC(),
                          // {
                          // setState(() {
                          //   recipe.add(input);
                          // });
                          // },
                          child: Text("Add"))
                    ],
                  );
                });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: ListView.builder(
          itemCount: recipe_old.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(recipe_old[index]),
                child: Card(
                  child: ListTile(
                      title: Text(recipe_old[index]),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            recipe_old.removeAt(index);
                          });
                        },
                      )),
                ));
          }),
    );
  }
}
