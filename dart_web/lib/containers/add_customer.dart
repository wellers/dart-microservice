import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';
import '../presentation/add_edit_screen.dart';
import '../models/app_state.dart';

class AddCustomer extends StatelessWidget {
  AddCustomer({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnSaveCallback>(
      converter: (Store<AppState> store) {        
        return (name, age) {
          store.dispatch(AddCustomerAction(
            customer: CustomerInput(name: name, age: int.parse(age))
          ));
        };        
      },
      builder: (BuildContext context, OnSaveCallback onSave) {
        return AddEditScreen(
          key: Key('addCustomerScreen'),
          onSave: onSave,
          isEditing: false, 
          customer: null,
        );
      }
    );
  }
}