import 'package:shelf_plus/shelf_plus.dart';

import 'customer.dart';

class Insert {
  final List<Customer> customers;

  const Insert({
    required this.customers
  });  

  Map<String, List<Map<String, dynamic>>> toJson() => { 
    'customers': customers.map((customer) => customer.toJson()).toList() 
  };

  factory Insert.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('customers')) {
      return Insert(customers: []);
    }

    return Insert(
      customers: (json['customers'] as Iterable).map((customer) => Customer.fromJson(customer)).toList()
    );
  }
}

extension InsertAccessor on RequestBodyAccessor {
 Future<Insert> get asInsert async => Insert.fromJson(await asJson);
}