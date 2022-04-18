
import '../models/models.dart';

class LoadCustomersAction {}

class CustomersNotLoadedAction {}

class CustomersLoadedAction {
  final List<Customer> customers;

  CustomersLoadedAction(this.customers);

  @override
  String toString() {
    return 'CustomersLoadedAction{customers: $customers}';
  }
}

class DeleteCustomerAction {
  final String id;

  DeleteCustomerAction(this.id);

  @override
  String toString() {
    return 'DeleteCustomerAction{id: $id}';
  }
}

class AddCustomerAction {
  final CustomerInput customer;

  AddCustomerAction({required this.customer});  

  @override
  String toString() {
    return 'AddCustomerAction{customer: $customer}';
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