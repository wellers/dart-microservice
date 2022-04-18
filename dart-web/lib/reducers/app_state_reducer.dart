import '../models/app_state.dart';
import 'loading_reducer.dart';
import 'people_reducer.dart';
import 'tabs_reducer.dart';

AppState appStateReducer(AppState state, action) {  
  return AppState(
    isLoading: loadingReducer(state.isLoading, action),
    people: peopleReducer(state.people, action),    
    activeTab: tabsReducer(state.activeTab, action),
  );
}