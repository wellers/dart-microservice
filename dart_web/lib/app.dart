import 'package:dart_web/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'actions/actions.dart';
import 'containers/add_person.dart';
import 'models/models.dart';
import 'models/app_state.dart';
import 'presentation/home_screen.dart';
import 'presentation/people_screen.dart';


class ReduxApp extends StatelessWidget {
  final Store<AppState> store;

  const ReduxApp({required Key key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        onGenerateTitle: (context) => 'People',        
        theme: MyTheme.theme,
        routes: {
          Routes.home: (context) => HomeScreen(),
          Routes.listPeople: (context) => PeopleScreen(              
            onInit: () {              
              StoreProvider.of<AppState>(context).dispatch(LoadPeopleAction());
            }
          ),
          Routes.addPerson:(context) => AddPerson(key: Key('addPerson'))
        }
      )
    );
  }
}