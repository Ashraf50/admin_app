part of 'add_manager_cubit.dart';

sealed class AddManagerState {}

final class AddManagerInitial extends AddManagerState {}

final class FetchManagerLoading extends AddManagerState {}

final class FetchManagerSuccess extends AddManagerState {
  final List<ManagerModel> managers;
  FetchManagerSuccess({required this.managers});
}

final class FetchManagerFailure extends AddManagerState {
  final String errMessage;
  FetchManagerFailure({required this.errMessage});
}

final class DeleteManagerFailure extends AddManagerState {
  final String errMessage;
  DeleteManagerFailure({required this.errMessage});
}

final class EditManagerFailure extends AddManagerState {
  final String errMessage;
  EditManagerFailure({required this.errMessage});
}

final class EditManagerSuccess extends AddManagerState {}

final class SearchManagerFailure extends AddManagerState {
  final String errMessage;
  SearchManagerFailure({required this.errMessage});
}
