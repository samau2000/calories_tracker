import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:test_app/pages/recipes.dart';

//stl -->
class RecipeDetails extends StatefulWidget {
  const RecipeDetails({Key? key, required User user, required String recipe})
      : _user = user,
        _recipe = recipe,
        super(key: key);

  final User _user;
  final String _recipe;
  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  late User _user;
  late String _recipe;
  List recipe = <String>[];
  String input = "";
  late final dbRef =
      FirebaseDatabase.instance.reference().child("Recipes").child(_recipe);

  List<Map<dynamic, dynamic>> lists = [];

  @override
  void initState() {
    _user = widget._user;
    _recipe = widget._recipe;
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
                    builder: (context) => listRecipe(
                      user: _user,
                      calories: null,
                      foodname: null,
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
                print(values);
                values['ingredients'].forEach((key, values) {
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
                                  spacing: 180,
                                  children: <Widget>[
                                    Text('cals:' +
                                        lists[index]['calories'].toString()),
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
                    });
              }
              return CircularProgressIndicator();
            }));
  }
}
