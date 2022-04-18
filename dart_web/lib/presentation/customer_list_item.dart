import 'package:flutter/material.dart';

import '../models/models.dart';

class CustomerListItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;  
  final Customer customer;

  CustomerListItem({
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
          title: Row(
            children: [              
              Text(customer.name),              
              Text(customer.age.toString())
            ]
          )
        )
      )    
    );
  }
}