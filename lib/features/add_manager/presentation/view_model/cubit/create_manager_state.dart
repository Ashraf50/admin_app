part of 'create_manager_cubit.dart';

sealed class CreateManagerState {}

final class CreateManagerInitial extends CreateManagerState {}

final class CreateManagerLoading extends CreateManagerState {}

final class CreateManagerFailure extends CreateManagerState {
  final String errMessage;
  CreateManagerFailure({required this.errMessage});
}

final class CreateManagerSuccess extends CreateManagerState {}
