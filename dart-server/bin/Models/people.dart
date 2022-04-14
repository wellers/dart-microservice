import 'package:shelf_plus/shelf_plus.dart';

import 'person.dart';

class People {
  final List<Person> people;

  const People({
    required this.people
  });  

  Map<String, List<Map<String, dynamic>>> toJson() => { 'people': people.map((e) => e.toJson()).toList() };

  factory People.fromJson(Map<String, dynamic> json) {
    return People(people: (json['people'] as Iterable).map((person) => Person.fromJson(person)).toList());
  }
}
extension PeopleAccessor on RequestBodyAccessor {
 Future<People> get asPeople async => People.fromJson(await asJson);
}