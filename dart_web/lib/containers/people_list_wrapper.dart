import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../actions/actions.dart';
import '../models/models.dart';
import '../presentation/people_list.dart';
import '../models/app_state.dart';
import 'tab_selector.dart';

class PeopleListWrapper extends StatelessWidget {
  PeopleListWrapper({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: Text('People'),
            leading: BackButton(onPressed: () {
                Navigator.pushNamed(context, Routes.home);
                return viewModel.onBackPressed();
              })
          ),
          body: PeopleList(
            key: Key('peopleList'),
            people: viewModel.people,
            onRemove: viewModel.onRemove,
            onUndoRemove: viewModel.onUndoRemove,
          ),
          floatingActionButton: FloatingActionButton(
            key: Key('addPersonFab'),
            onPressed: () {
              Navigator.pushNamed(context, Routes.addPerson);
            },
            child: Icon(Icons.add),
            tooltip: 'Add Person',
          ),
          bottomNavigationBar: TabSelector(key: Key('tabSelector'))
        );
      },
    );
  }
}

class _ViewModel {
  final List<Person> people;
  final bool loading;  
  final Function(Person) onRemove;
  final Function(Person) onUndoRemove;
  final Function onBackPressed;

  _ViewModel({
    required this.people,
    required this.loading,    
    required this.onRemove,
    required this.onUndoRemove,
    required this.onBackPressed,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      people: store.state.people,
      loading: store.state.isLoading,      
      onRemove: (person) {
        store.dispatch(DeletePersonAction(person.id));
      },
      onUndoRemove: (person) {
        store.dispatch(AddPersonAction(person: PersonInput.fromPerson(person)));
      },
      onBackPressed: () {        
        store.dispatch(UpdateTabAction(AppTab.home));
      }
    );
  }  
}