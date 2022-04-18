import 'package:dart_web/containers/app_loading.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import 'loading_indicator.dart';
import 'customer_list_item.dart';

class CustomersList extends StatelessWidget {
  final List<Customer> customers;
  final Function(Customer) onRemove;
  final Function(Customer) onUndoRemove;

  CustomersList({
    required Key key,
    required this.customers,    
    required this.onRemove,
    required this.onUndoRemove
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    return AppLoading(
      key: Key('appLoading'), 
      builder: (context, loading) {
        return loading
          ? LoadingIndicator(key: Key('customersLoading'))
          : _buildListView();
      }
    );
  }

  _buildListView() {
     return ListView.builder(
      key: Key('customersList'),
      itemCount: customers.length,      
      itemBuilder: (BuildContext context, int index) {
        final customer = customers[index];

        return CustomerListItem(
          customer: customer,
          onDismissed: (direction) {
            _removeCustomer(context, customer);
          }
        );
      },
    );
  }

  void _removeCustomer(BuildContext context, Customer customer) {
    onRemove(customer);

    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'Deleted',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => onUndoRemove(customer),
        )));
  }
}