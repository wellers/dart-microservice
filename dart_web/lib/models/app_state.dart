import 'package:meta/meta.dart';

import 'models.dart';

@immutable
class AppState {
  final bool isLoading;
  final List<Customer> customers;
  final AppTab activeTab;

  AppState({
    this.isLoading = false,
    this.customers = const [],
    this.activeTab = AppTab.home
  });

  factory AppState.loading() => AppState(isLoading: true);

  AppState copyWith({
    required bool isLoading,
    required List<Customer> customers,
    required AppTab activeTab,
  }) {
    return AppState(
      isLoading: isLoading,
      customers: customers,
      activeTab: activeTab,      
    );
  }

  @override
  int get hashCode =>
      isLoading.hashCode ^
      customers.hashCode ^
      activeTab.hashCode;      

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          customers == other.customers &&
          activeTab == other.activeTab;          

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, customers: $customers, activeTab: $activeTab}';
  }
}