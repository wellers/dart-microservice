import 'package:redux/redux.dart';
import '../actions/actions.dart';
import '../models/models.dart';
import '../models/app_state.dart';
import '../selectors/selectors.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, LoadPeopleAction>(_loadPeople),
    TypedMiddleware<AppState, AddPersonAction>(_addPerson),        
    TypedMiddleware<AppState, UpdatePersonAction>(_updatePerson),
    TypedMiddleware<AppState, PeopleLoadedAction>(_peopleLoaded),
    TypedMiddleware<AppState, DeletePersonAction>(_deletePerson),
  ];
}

List<Person> people = <Person>[Person(id: '123', name: 'Paul', age: 30)];

_loadPeople(Store<AppState> store, action, NextDispatcher next) {
  // load
  try {
    store.dispatch(PeopleLoadedAction(people));
  } catch (err) {
    store.dispatch(PeopleNotLoadedAction());
  } 
  
  next(action);
}

_addPerson(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  //create
  people = peopleSelector(store.state);
}

_updatePerson(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  //updated
  people = peopleSelector(store.state);
}

_peopleLoaded(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  //loaded
  people = peopleSelector(store.state);
}

_deletePerson(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  //delete
  people = peopleSelector(store.state);
}