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

class Person {
  final String id = "";
  final String name;
  final int age;

  const Person({    
    required this.name,
    required this.age, id    
  });
  
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "age": age};
}