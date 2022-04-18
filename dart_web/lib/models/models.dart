enum AppTab { 
  home, 
  listCustomers
}

extension ActiveTabExtensions on AppTab {
  appTabToRoute() {
    switch (this) {      
      case AppTab.listCustomers:
        return Routes.listCustomers;
      default:
        return Routes.home;        
    }
  }
}

class Routes {
  static final home = '/';  
  static final listCustomers = '/listCustomers';
  static final addCustomer = '/addCustomer';  
}

class CustomerInput {
  final String name;
  final int age;

  const CustomerInput({    
    required this.name,
    required this.age,     
  });
  
  factory CustomerInput.fromJson(Map<String, dynamic> json) => CustomerInput(      
      name: json['name'],
      age: json['age'],
    );

  factory CustomerInput.fromCustomer(Customer customer) => CustomerInput(name: customer.name, age: customer.age);

  Map<String, dynamic> toJson() => {"name": name, "age": age};
}

class Customer {
  final String id;
  final String name;
  final int age;

  const Customer({    
    required this.name,
    required this.age, 
    required this.id    
  });
  
  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      id: json['id'],
      name: json['name'],
      age: json['age'],
    );

  Map<String, dynamic> toJson() => {"name": name, "age": age};
}