import 'package:shelf_plus/shelf_plus.dart';

class Customer {
  final String? name;
  final int? age;

  const Customer({    
    required this.name,
    required this.age,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "age": age};  
}

extension CustomerAccessor on RequestBodyAccessor {
  Future<Customer> get asCustomer async => Customer.fromJson(await asJson); 
}