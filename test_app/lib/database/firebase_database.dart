import 'dart:async';

import 'package:firestore_service/firestore_service.dart';
import 'package:test_app/database/recipe_model.dart';
import 'package:test_app/database/firebase_path.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setRecipe(Recipe recipe) => _service.setData(
        path: FirestorePath.recipe(uid, recipe.id),
        data: recipe.toMap(),
      );

  Future<void> deleteJob(Recipe recipe) async {
    await _service.deleteData(path: FirestorePath.recipe(uid, recipe.id));
  }

  Stream<Recipe> recipeStream({required String recipeId}) =>
      _service.documentStream(
        path: FirestorePath.recipe(uid, recipeId),
        builder: (data, documentId) => Recipe.fromMap(data, documentId),
      );

  Stream<List<Recipe>> recipesStream() => _service.collectionStream(
        path: FirestorePath.recipes(uid),
        builder: (data, documentId) => Recipe.fromMap(data, documentId),
      );
}
