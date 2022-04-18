
import '../models/models.dart';

class LoadPeopleAction {}

class PeopleNotLoadedAction {}

class PeopleLoadedAction {
  final List<Person> people;

  PeopleLoadedAction(this.people);

  @override
  String toString() {
    return 'PeoplesLoadedAction{people: $people}';
  }
}

class UpdatePersonAction {
  final String id;
  final Person updatedPerson;

  UpdatePersonAction(this.id, this.updatedPerson);

  @override
  String toString() {
    return 'UpdatePersonAction{id: $id, updatedPerson: $updatedPerson}';
  }
}

class DeletePersonAction {
  final String id;

  DeletePersonAction(this.id);

  @override
  String toString() {
    return 'DeletePersonAction{id: $id}';
  }
}

class AddPersonAction {
  final Person person;

  AddPersonAction({required this.person});  

  @override
  String toString() {
    return 'AddPersonAction{person: $person}';
  }
}

class UpdateTabAction {
  final AppTab newTab;

  UpdateTabAction(this.newTab);

  @override
  String toString() {
    return 'UpdateTabAction{newTab: $newTab}';
  }
}