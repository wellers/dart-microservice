import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';
import '../presentation/customers_list.dart';
import '../models/app_state.dart';
import 'tab_selector.dart';

class CustomersListWrapper extends StatelessWidget {
  CustomersListWrapper({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Customers'),
            leading: BackButton(onPressed: () {
                Navigator.pushNamed(context, Routes.home);
                return viewModel.onBackPressed();
              })
          ),
          body: CustomersList(
            key: Key('customersList'),
            customers: viewModel.customers,
            onRemove: viewModel.onRemove,
            onUndoRemove: viewModel.onUndoRemove,
          ),
          floatingActionButton: FloatingActionButton(
            key: Key('addCustomerFab'),
            onPressed: () {
              Navigator.pushNamed(context, Routes.addCustomer);
            },
            child: Icon(Icons.add),
            tooltip: 'Add Customer',
          ),
          bottomNavigationBar: TabSelector(key: Key('tabSelector'))
        );
      },
    );
  }
}

class _ViewModel {
  final List<Customer> customers;
  final bool loading;  
  final Function(Customer) onRemove;
  final Function(Customer) onUndoRemove;
  final Function onBackPressed;

  _ViewModel({
    required this.customers,
    required this.loading,    
    required this.onRemove,
    required this.onUndoRemove,
    required this.onBackPressed,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      customers: store.state.customers,
      loading: store.state.isLoading,      
      onRemove: (customer) {
        store.dispatch(DeleteCustomerAction(customer.id));
      },
      onUndoRemove: (customer) {
        store.dispatch(AddCustomerAction(customer: CustomerInput.fromCustomer(customer)));
      },
      onBackPressed: () {        
        store.dispatch(UpdateTabAction(AppTab.home));
      }
    );
  }  
}