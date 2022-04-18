import 'package:flutter/material.dart';

import '../containers/active_tab.dart';
import '../containers/customers_list_wrapper.dart';
import '../models/models.dart';

class CustomersScreen extends StatefulWidget {
  final void Function() onInit;

  CustomersScreen({required this.onInit}) : super(key: Key('customers'));

  @override
  CustomersScreenState createState() => CustomersScreenState();
}

class CustomersScreenState extends State<CustomersScreen> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ActiveTab(
      key: Key('activeTab'),
      builder: (BuildContext context, AppTab activeTab) 
        => CustomersListWrapper(key: Key('listWrapper'))
    );
  }
}