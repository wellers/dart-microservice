import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final peopleReducer = combineReducers<List<Person>>([  
  TypedReducer<List<Person>, DeletePersonAction>(_deletePerson),  
  TypedReducer<List<Person>, PeopleLoadedAction>(_setLoadedPeople),
  TypedReducer<List<Person>, PeopleNotLoadedAction>(_setNoPeople),
]);

List<Person> _deletePerson(List<Person> people, DeletePersonAction action) {
  return people.where((person) => person.id != action.id).toList();
}

List<Person> _setLoadedPeople(List<Person> people, PeopleLoadedAction action) {
  return action.people;
}

List<Person> _setNoPeople(List<Person> people, PeopleNotLoadedAction action) {
  return [];
}