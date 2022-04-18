import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../actions/actions.dart';
import '../models/models.dart';
import '../models/app_state.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, LoadCustomersAction>(_loadCustomers),
    TypedMiddleware<AppState, AddCustomerAction>(_addCustomer),
    TypedMiddleware<AppState, CustomersLoadedAction>(_customersLoaded),
    TypedMiddleware<AppState, DeleteCustomerAction>(_deleteCustomer),
  ];
}

final String API_URL = dotenv.env['API_URL']!;

_loadCustomers(Store<AppState> store, LoadCustomersAction action, NextDispatcher next) async {
  try {    
    // load  
    final response = await http.get(Uri.parse('${API_URL}/api/find'));
    final json = jsonDecode(await response.body);
  
    List<Customer> customers = [];
    if (json.containsKey('docs')) {
      customers = (json['docs'] as Iterable).map((customer) => Customer.fromJson(customer)).toList();
    }

    store.dispatch(CustomersLoadedAction(customers));
  } catch (err) {
    store.dispatch(CustomersNotLoadedAction());
  } 
  
  next(action);
}

_addCustomer(Store<AppState> store, AddCustomerAction action, NextDispatcher next) async {    
  next(action);

  //create
  final response = await http.post(Uri.parse('${API_URL}/api/insert'),
    body: jsonEncode({
      'customers': [action.customer.toJson()]
    }));
  
  jsonDecode(await response.body);  
  
  store.dispatch(LoadCustomersAction());  
}

_customersLoaded(Store<AppState> store, action, NextDispatcher next) {
  next(action);
}

_deleteCustomer(Store<AppState> store, DeleteCustomerAction action, NextDispatcher next) async {  
  next(action);  

  //delete
  final response = await http.get(Uri.parse('${API_URL}/api/remove?id="${action.id}"'));
  jsonDecode(await response.body);  
  
  store.dispatch(LoadCustomersAction());
}