enum AppTab { 
  home, 
  listPeople
}

extension ActiveTabExtensions on AppTab {
  appTabToRoute() {
    switch (this) {      
      case AppTab.listPeople:
        return Routes.listPeople;
      default:
        return Routes.home;        
    }
  }
}

class Routes {
  static final home = '/';  
  static final listPeople = '/listPeople';
  static final addPerson = '/addPerson';  
}

class PersonInput {
  final String name;
  final int age;

  const PersonInput({    
    required this.name,
    required this.age,     
  });
  
  factory PersonInput.fromJson(Map<String, dynamic> json) => PersonInput(      
      name: json['name'],
      age: json['age'],
    );

  factory PersonInput.fromPerson(Person person) => PersonInput(name: person.name, age: person.age);

  Map<String, dynamic> toJson() => {"name": name, "age": age};
}

class Person {
  final String id;
  final String name;
  final int age;

  const Person({    
    required this.name,
    required this.age, 
    required this.id    
  });
  
  factory Person.fromJson(Map<String, dynamic> json) => Person(
      id: json['id'],
      name: json['name'],
      age: json['age'],
    );

  Map<String, dynamic> toJson() => {"name": name, "age": age};
}