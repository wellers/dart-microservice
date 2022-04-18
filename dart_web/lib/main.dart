import 'package:dart_web/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'app.dart';
import 'middleware/middleware.dart';
import 'reducers/app_state_reducer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ReduxApp(
    key: Key('reduxApp'),
    store: Store<AppState>(
      appStateReducer,
      initialState: AppState.loading(),
      middleware: createStoreMiddleware()
    ))
  );
}