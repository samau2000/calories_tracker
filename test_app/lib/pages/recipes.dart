//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app/database/firebase_database.dart';
import 'package:test_app/database/providers.dart';
import 'package:test_app/database/recipe_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  const listRecipe({Key? key, required User user, this.recipe})
      : _user = user,
        super(key: key);

  final User _user;
  final Recipe? recipe;
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
    super.initState();
    if (widget.recipe != null) {
      name = widget.recipe?.name;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final database = ref.read<FirestoreDatabase?>(databaseProvider)!;
        final recipes = await database.jobsStream().first;
        final allLowerCaseNames =
            recipes.map((recipe) => recipe.name.toLowerCase()).toList();
        if (widget.recipe != null) {
          allLowerCaseNames.remove(widget.recipe!.name.toLowerCase());
          // }
          // if (allLowerCaseNames.contains(name?.toLowerCase())) {
          //   unawaited(showAlertDialog(
          //     context: context,
          //     title: 'Name already used',
          //     content: 'Please choose a different job name',
          //     defaultActionText: 'OK',
          //   ));
        } else {
          final id = widget.recipe?.id ?? documentIdFromCurrentDate();
          final recipe = Recipe(id: id, name: name ?? '');
          await database.setJob(recipe);
          Navigator.of(context).pop();
        }
      } catch (e) {
        // unawaited(showExceptionAlertDialog(
        //   context: context,
        //   title: 'Operation failed',
        //   exception: e,
        // ));
        print(e);
      }
    }
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
                          onPressed: () => _submit(),
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
