import 'package:redux/redux.dart';

import '../actions/actions.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, CustomersLoadedAction>(_setLoaded),
  TypedReducer<bool, CustomersNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}