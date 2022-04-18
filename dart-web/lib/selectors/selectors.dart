import '../models/models.dart';
import '../models/app_state.dart';

bool isLoadingSelector(AppState state) => state.isLoading;

List<Person> peopleSelector(AppState state) => state.people;