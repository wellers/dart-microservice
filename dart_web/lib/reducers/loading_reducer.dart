import 'package:redux/redux.dart';

import '../actions/actions.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, PeopleLoadedAction>(_setLoaded),
  TypedReducer<bool, PeopleNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}