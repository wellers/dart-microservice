import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';
import '../presentation/people_list.dart';
import '../models/app_state.dart';

class PeopleListWrapper extends StatelessWidget {
  PeopleListWrapper({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        return PeopleList(
          key: Key('peopleList'),
          people: viewModel.people,
          onCheckboxChanged: viewModel.onCheckboxChanged,
          onRemove: viewModel.onRemove,
          onUndoRemove: viewModel.onUndoRemove,
        );
      },
    );
  }
}

class _ViewModel {
  final List<Person> people;
  final bool loading;
  final Function(Person, bool) onCheckboxChanged;
  final Function(Person) onRemove;
  final Function(Person) onUndoRemove;

  _ViewModel({
    required this.people,
    required this.loading,
    required this.onCheckboxChanged,
    required this.onRemove,
    required this.onUndoRemove,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      people: store.state.people,
      loading: store.state.isLoading,
      onCheckboxChanged: (person, complete) {
        store.dispatch(UpdatePersonAction(
          person.id,
          person,
        ));
      },
      onRemove: (person) {
        store.dispatch(DeletePersonAction(person.id));
      },
      onUndoRemove: (person) {
        store.dispatch(AddPersonAction(person: person));
      },
    );
  }
}