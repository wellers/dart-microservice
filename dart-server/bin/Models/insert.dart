import 'package:shelf_plus/shelf_plus.dart';

import 'person.dart';

class Insert {
  final List<Person> people;

  const Insert({
    required this.people
  });  

  Map<String, List<Map<String, dynamic>>> toJson() => { 'people': people.map((person) => person.toJson()).toList() };

  factory Insert.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('people')) {
      return Insert(people: []);
    }

    return Insert(people: (json['people'] as Iterable).map((person) => Person.fromJson(person)).toList());
  }
}
extension InsertAccessor on RequestBodyAccessor {
 Future<Insert> get asInsert async => Insert.fromJson(await asJson);
}