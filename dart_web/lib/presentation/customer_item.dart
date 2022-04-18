import 'package:flutter/material.dart';

import '../models/models.dart';

class CustomerItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;  
  final Customer customer;

  CustomerItem({
    required this.onDismissed,    
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('customer_${customer.id}'),
      onDismissed: onDismissed,
      child: (
        ListTile(
          title:Text('${customer.name} (${customer.age})')          
        )
      )
    );
  }
}