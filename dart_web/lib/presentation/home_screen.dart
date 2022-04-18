import 'package:flutter/material.dart';

import '../containers/active_tab.dart';
import '../containers/tab_selector.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen() : super(key: Key('home'));

  @override  
  Widget build(BuildContext context) {
    return ActiveTab(
      key: Key('activeTab'),
      builder: (BuildContext context, AppTab activeTab) {
        return Scaffold(
          appBar: AppBar(            
            title: Text('People'),
            automaticallyImplyLeading: false,                                 
          ),
          body: Center(child: Text('Hello, World!')),          
          bottomNavigationBar: TabSelector(key: Key('tabSelector')),
        );
      }
    );
  }
}