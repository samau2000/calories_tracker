import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/pages/recipe_details.dart';
import 'package:test_app/pages/home.dart';

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

class listRecipe extends StatefulWidget {
  const listRecipe(
      {Key? key,
      required User user,
      required dynamic calories,
      required dynamic foodname})
      : _user = user,
        _calories = calories,
        _foodname = foodname,
        super(key: key);

  final User _user;
  final dynamic _calories;
  final dynamic _foodname;
  @override
  _listRecipeState createState() => _listRecipeState();
}

class _listRecipeState extends State<listRecipe> {
  late User _user;
  late dynamic _calories;
  late dynamic _foodname;
  List recipe = <String>[];
  String input = "";
  final dbRef = FirebaseDatabase.instance.reference().child("Recipes");
  List<Map<dynamic, dynamic>> lists = [];

  createRecipe(String name) {
    final dbRef = FirebaseDatabase.instance.reference().child("Recipes");
    dbRef.push().set({
      "name": name,
    });
  }

  addIngredient(String key, String name) {
    final dbRef = FirebaseDatabase.instance
        .reference()
        .child("Recipes")
        .child(key)
        .child("ingredients");
    dbRef.push().set({
      "name": _foodname,
      "calories": _calories,
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RecipeDetails(
          user: _user,
          recipe: key,
        ),
      ),
    );
  }

  @override
  void initState() {
    _user = widget._user;
    _foodname = widget._foodname;
    _calories = widget._calories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Recipes"),
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
                            onPressed: () => createRecipe(input),
                            child: Text("Add"))
                      ],
                    );
                  });
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
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
                List keys = values.keys.toList();
                return ListView.builder(
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                          key: Key(lists[index]['name']),
                          child: Card(
                            child: ListTile(
                                title: Text(lists[index]['name']),
                                trailing: Wrap(
                                  spacing: 20,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.chevron_right,
                                        color: Colors.black,
                                      ),
                                      onPressed: () => addIngredient(
                                          keys[index], lists[index]['name']),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          recipe.removeAt(index);
                                        });
                                      },
                                    )
                                  ],
                                )),
                          ));

                      //   new ListView.builder(
                      //       shrinkWrap: true,
                      //       itemCount: lists.length,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return Card(
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: <Widget>[
                      //               Text("Name: " + lists[index]["name"]),
                      //               // Text("Calories: " + lists[index]["calories"].toString()),
                      //               // Text("Type: " + lists[index]["type"]),
                      //             ],
                      //           ),
                      //         );
                      //       });
                      // }
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}
