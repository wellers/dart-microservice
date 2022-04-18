import 'package:dart_web/containers/app_loading.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import 'loading_indicator.dart';
import 'person_item.dart';

class PeopleList extends StatelessWidget {
  final List<Person> people;
  final Function(Person) onRemove;
  final Function(Person) onUndoRemove;

  PeopleList({
    required Key key,
    required this.people,    
    required this.onRemove,
    required this.onUndoRemove
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    return AppLoading(
      key: Key('appLoading'), 
      builder: (context, loading) {
        return loading
          ? LoadingIndicator(key: Key('peopleLoading'))
          : _buildListView();
      }
    );
  }

  _buildListView() {
     return ListView.builder(
      key: Key('peopleList'),
      itemCount: people.length,      
      itemBuilder: (BuildContext context, int index) {
        final person = people[index];

        return PersonItem(
          person: person,
          onDismissed: (direction) {
            _removePerson(context, person);
          }
        );
      },
    );
  }

  void _removePerson(BuildContext context, Person person) {
    onRemove(person);

    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'Deleted',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => onUndoRemove(person),
        )));
  }
}