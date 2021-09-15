import 'dart:collection';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_app/database/recipe_model.dart';

class FirebaseRealtimeDatabaseService {
  late DatabaseReference _db;
  late String _userId;
  late Future<dynamic> _userDetailChangedEvent;
  late Function(List<DataSnapshot> dataSnapshots) _userDetailChangedCallback;

  FirebaseRealtimeDatabaseService({
    required FirebaseApp firebaseApp,
    // void Function(List<DataSnapshot> dataSnapshots) onUserDetailChanged,
  }) {
    _db = FirebaseDatabase(
            app: firebaseApp,
            databaseURL:
                'https://calories-tracker-c5520-default-rtdb.firebaseio.com/')
        .reference();
    // _userDetailChangedCallback = onUserDetailChanged;
  }

  // Future<void> setUserId(String userId) {
  //   if (userId == null || _userId == userId) {
  //     // return null;
  //   }

  //   _userId = userId;

  //   if (_userDetailChangedEvent != null) {
  //     _userDetailChangedEvent.then((value) => null);
  //   }

  //   if (_userDetailChangedCallback != null) {
  //     _userDetailChangedEvent = _db
  //         .child('users/GZhPWru2Mhfb0UYzZze2TW5B7hA3')
  //         .onChildChanged
  //         .map((event) => event.snapshot)
  //         .toList()
  //         .then((dataSnapshots) {
  //       _userDetailChangedCallback(dataSnapshots);
  //     });
  //   }
  //   return null;
  // }

  Future<void> setUserData(
      String userId, String name, String status, double priority) async {
    final RecipeModel userData = RecipeModel(userId, name, status);
    await _db.child('users/$userId').set(userData.toMap(), priority: priority);
  }

  Future<void> updateUserData(String userId, String name, String status) async {
    final RecipeModel recipeData = RecipeModel(userId, name, status);
    await _db.child('users/$userId').update(recipeData.toMap());
  }

  Future<void> pushUserData(String userId, String name, String status) async {
    final RecipeModel recipeData = RecipeModel(userId, name, status);
    await _db.child('users/$userId').push().set(recipeData.toMap());
  }

  Future<void> setPriority(String userId, double priority) async {
    await _db.child('users/$userId').setPriority(priority);
  }

  Future<void> removeUserData(String userId) async {
    await _db.child('users/$userId').remove();
  }

  Future<RecipeModel> getUserData(String userId) async {
    return await _db.child('users/$userId').once().then((result) {
      final LinkedHashMap value = result.value;

      return RecipeModel(value['id'], value['name'], value['desc'])
          .fromMap(value);
    });
  }

//   Future<List<RecipeModel>> getUsersOrderByPriority({String startAt}) async {
//     final List<RecipeModel> orderedResult = [];
//     final Query query =
//         _db.child('users').limitToFirst(100).startAt(startAt).orderByPriority();

//     query.onChildAdded.forEach((event) {
//       orderedResult.add(RecipeModel.fromMap(event.snapshot.value));
//     });

//     return await query.once().then((ignored) => orderedResult);
//   }

//   Future<List<UserData>> getUsersOrderByKey({String startAt}) async {
//     final List<UserData> orderedResult = [];
//     final Query query =
//         _db.child('users').limitToFirst(100).startAt(startAt).orderByKey();

//     query.onChildAdded.forEach((event) {
//       orderedResult.add(UserData.fromMap(event.snapshot.value));
//     });

//     return await query.once().then((ignored) => orderedResult);
//   }

//   Future<List<UserData>> getUsersOrderByValue({String startAt}) async {
//     final List<UserData> orderedResult = [];
//     final Query query =
//         _db.child('users').limitToFirst(100).startAt(startAt).orderByValue();

//     query.onChildAdded.forEach((event) {
//       orderedResult.add(UserData.fromMap(event.snapshot.value));
//     });

//     return await query.once().then((ignored) => orderedResult);
//   }

//   Future<List<UserData>> getUsersOrderByChildName({String startAt}) async {
//     final List<UserData> orderedResult = [];
//     final Query query = _db
//         .child('users')
//         .limitToFirst(100)
//         .startAt(startAt)
//         .orderByChild('name');

//     query.onChildAdded.forEach((event) {
//       orderedResult.add(UserData.fromMap(event.snapshot.value));
//     });

//     return await query.once().then((ignored) => orderedResult);
//   }
}
