import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../models/models.dart';
import '../actions/actions.dart';
import '../models/app_state.dart';

class TabSelector extends StatelessWidget {
  TabSelector({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        return BottomNavigationBar(
          key: Key('tabs'),
          currentIndex: AppTab.values.indexOf(viewModel.activeTab),
          onTap: (index) {
            final newTab = AppTab.values[index];
            Navigator.pushNamed(context, newTab.appTabToRoute());

            return viewModel.onTabSelected(index);
          },
          items: AppTab.values.map((tab) {
            return BottomNavigationBarItem(
              icon: Icon(
                tab == AppTab.listCustomers ? Icons.list : Icons.home,
                key: Key(tab.name)
              ),
              label: tab == AppTab.listCustomers ? 'Customers' : 'Home'
            );
          }).toList(),
        );
      },
    );
  }
}

class _ViewModel {
  final AppTab activeTab;
  final Function(int) onTabSelected;

  _ViewModel({
    required this.activeTab,
    required this.onTabSelected,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      activeTab: store.state.activeTab,
      onTabSelected: (index) {   
        final newTab = AppTab.values[index];        
        store.dispatch(UpdateTabAction(newTab));
      },
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          activeTab == other.activeTab;

  @override
  int get hashCode => activeTab.hashCode;
}