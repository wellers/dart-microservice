import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';

final customersReducer = combineReducers<List<Customer>>([  
  TypedReducer<List<Customer>, DeleteCustomerAction>(_deleteCustomer),  
  TypedReducer<List<Customer>, CustomersLoadedAction>(_setLoadedCustomers),
  TypedReducer<List<Customer>, CustomersNotLoadedAction>(_setNoCustomers),
]);

List<Customer> _deleteCustomer(List<Customer> customers, DeleteCustomerAction action) {
  return customers.where((customer) => customer.id != action.id).toList();
}

List<Customer> _setLoadedCustomers(List<Customer> customers, CustomersLoadedAction action) {
  return action.customers;
}

List<Customer> _setNoCustomers(List<Customer> customers, CustomersNotLoadedAction action) {
  return [];
}