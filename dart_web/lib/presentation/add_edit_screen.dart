import 'package:flutter/material.dart';

import '../models/models.dart';

typedef OnSaveCallback = void Function(String task, String note);

class AddEditScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Person? person;

  AddEditScreen(
      {required Key key, required this.onSave, required this.isEditing, required this.person})
      : super(key: key);
  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _name;
  late String _age;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {    
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Person' : 'Add Person',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: isEditing ? widget.person!.name : '',
                key: Key('nameField'),
                autofocus: !isEditing,
                style: textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: 'Name',
                ),
                validator: (val) {
                  return val!.trim().isEmpty
                      ? 'Name is required'
                      : null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: isEditing ? widget.person!.age.toString() : '',
                key: Key('ageField'),                
                style: textTheme.titleMedium,
                decoration: InputDecoration(
                  hintText: 'Age',
                ),
                validator: (val) {
                  return val!.trim().isEmpty
                      ? 'Age is required'
                      : null;
                },
                onSaved: (value) => _age = value!,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: isEditing ? Key('savePersonFab') : Key('saveNewPerson'),
        tooltip: isEditing ? 'Save Changes' : 'Add Person',
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            widget.onSave(_name, _age);

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}