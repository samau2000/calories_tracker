import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_app/database/recipe_model.dart';
import 'package:test_app/database/firebase_service.dart';

class DataForm extends StatefulWidget {
  final FirebaseApp firebaseApp;

  DataForm({Key? key, required this.firebaseApp}) : super(key: key);

  @override
  _DataFormState createState() => _DataFormState(this.firebaseApp);
}

class _DataFormState extends State<DataForm> {
  static final List<String> _operations = [
    'setUserData',
    'updateUserData',
    'pushUserData',
    'setPriority',
    'removeUserData',
    'getUserData',
    'getUsersOrderByPriority',
    'getUsersOrderByKey',
    'getUsersOrderByValue',
    'getUsersOrderByChildName',
  ];

  final GlobalKey _dataFormKey = GlobalKey<FormState>();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _priority = TextEditingController();
  final TextEditingController _startAt = TextEditingController();
  final TextEditingController _status = TextEditingController();

  String _operation = 'setUserData';
  String _result = '';
  late FirebaseRealtimeDatabaseService _realtimeDatabaseService;

  _DataFormState(FirebaseApp firebaseApp) {
    _realtimeDatabaseService = FirebaseRealtimeDatabaseService(
      firebaseApp: firebaseApp,
    );
  }

  Future<void> _handleSetUserData() async {
    await _realtimeDatabaseService.setUserData(
      _id.value.text,
      _name.value.text,
      _status.value.text,
      double.parse(_priority.value.text),
    );

    _result = 'Set data success.';
  }

  Future<void> _handleUpdateUserData() async {
    await _realtimeDatabaseService.updateUserData(
      _id.value.text,
      _name.value.text,
      _status.value.text,
    );

    _result = 'Update data success.';
  }

  Future<void> _handlePushUserData() async {
    await _realtimeDatabaseService.pushUserData(
      _id.value.text,
      _name.value.text,
      _status.value.text,
    );

    _result = 'Push data success.';
  }

  Future<void> _handleSetPriority() async {
    await _realtimeDatabaseService.setPriority(
      _id.value.text,
      double.parse(_priority.value.text),
    );

    _result = 'Update data success.';
  }

  Future<void> _handleRemoveUserData() async {
    await _realtimeDatabaseService.removeUserData(_id.value.text);

    _result = 'Remove data success.';
  }

  Future<void> _handleGetUserData() async {
    final RecipeModel recipeModel =
        await _realtimeDatabaseService.getUserData(_id.value.text);

    _result = recipeModel.toString();
  }

  // Future<void> _handleGetUsersOrderByPriority({ String startAt }) async {
  //   final List<UserData> users = await _realtimeDatabaseService
  //       .getUsersOrderByPriority(startAt: startAt);

  //   _result = users.toString();
  // }

  // Future<void> _handleGetUsersOrderByKey({ String startAt }) async {
  //   final List<UserData> users = await _realtimeDatabaseService
  //       .getUsersOrderByKey(startAt: startAt);

  //   _result = users.toString();
  // }

  // Future<void> _handleGetUsersOrderByValue({ String startAt }) async {
  //   final List<UserData> users = await _realtimeDatabaseService
  //       .getUsersOrderByValue(startAt: startAt);

  //   _result = users.toString();
  // }

  // Future<void> _handleGetUsersOrderByChildName({ String startAt }) async {
  //   final List<UserData> users = await _realtimeDatabaseService
  //       .getUsersOrderByChildName(startAt: startAt);

  //   _result = users.toString();
  // }

  Future<void> _handleSubmit() async {
    try {
      switch (_operation) {
        case 'setUserData':
          await _handleSetUserData();
          break;
        case 'updateUserData':
          await _handleUpdateUserData();
          break;
        case 'pushUserData':
          await _handlePushUserData();
          break;
        case 'setPriority':
          await _handleSetPriority();
          break;
        case 'removeUserData':
          await _handleRemoveUserData();
          break;
        case 'getUserData':
          await _handleGetUserData();
          break;
        // case 'getUsersOrderByPriority':
        //   await _handleGetUsersOrderByPriority(startAt: _startAt.text);
        //   break;
        // case 'getUsersOrderByKey':
        //   await _handleGetUsersOrderByKey(startAt: _startAt.text);
        //   break;
        // case 'getUsersOrderByValue':
        //   await _handleGetUsersOrderByValue(startAt: _startAt.text);
        //   break;
        // case 'getUsersOrderByChildName':
        //   await _handleGetUsersOrderByChildName(startAt: _startAt.text);
        //   break;
      }
    } catch (e) {
      _result = 'Error: ${e.toString()}.';
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _dataFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            items: _operations.map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            value: _operation,
            onChanged: (operation) {
              setState(() {
                _operation = operation.toString();
              });
            },
          ),
          Visibility(
            visible: <String>[
              'setUserData',
              'updateUserData',
              'removeUserData',
              'setPriority'
            ].contains(_operation),
            child: TextFormField(
              key: Key('id'),
              controller: _id,
              decoration: InputDecoration(labelText: 'ID'),
            ),
          ),
          Visibility(
            visible:
                <String>['setUserData', 'updateUserData'].contains(_operation),
            child: TextFormField(
              key: Key('name'),
              controller: _name,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Visibility(
            visible:
                <String>['setUserData', 'updateUserData'].contains(_operation),
            child: TextFormField(
              key: Key('status'),
              controller: _status,
              decoration: InputDecoration(labelText: 'Status'),
            ),
          ),
          Visibility(
            visible:
                <String>['setUserData', 'setPriority'].contains(_operation),
            child: TextFormField(
              key: Key('priority'),
              controller: _priority,
              decoration: InputDecoration(labelText: 'Priority'),
            ),
          ),
          Visibility(
            visible: <String>[
              'getUsersOrderByPriority',
              'getUsersOrderByKey',
              'getUsersOrderByValue',
              'getUsersOrderByChildName',
            ].contains(_operation),
            child: TextFormField(
              key: Key('startAt'),
              controller: _startAt,
              decoration: InputDecoration(labelText: 'Start At'),
            ),
          ),
          OutlinedButton(
            child: Text('Submit'),
            onPressed: _handleSubmit,
          ),
          Text(_result),
        ],
      ),
    );
  }
}
