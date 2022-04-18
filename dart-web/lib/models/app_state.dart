import 'package:meta/meta.dart';

import 'models.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Person> people;
  final AppTab activeTab;

  AppState({
    this.isLoading = false,
    this.people = const [],
    this.activeTab = AppTab.home
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    required bool isLoading,
    required List<Person> people,
    required AppTab activeTab,
  }) {
    return AppState(
      isLoading: isLoading,
      people: people,
      activeTab: activeTab,      
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      people.hashCode ^
      activeTab.hashCode;      

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          people == other.people &&
          activeTab == other.activeTab;          

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, people: $people, activeTab: $activeTab}';
  }
}