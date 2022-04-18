import 'package:flutter/material.dart';

import '../models/models.dart';

class PersonItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;  
  final Person person;

  PersonItem({
    required this.onDismissed,    
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('person_${person.id}'),
      onDismissed: onDismissed,
      child: (
        ListTile(
          title:Text('${person.name} (${person.age})')          
        )
      )
    );
  }
}