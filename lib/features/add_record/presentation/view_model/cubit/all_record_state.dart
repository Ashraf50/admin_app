part of 'all_record_cubit.dart';

sealed class AllRecordState {}

final class AllRecordInitial extends AllRecordState {}

final class FetchAllRecordsLoading extends AllRecordState {}

final class FetchAllRecordsSuccess extends AllRecordState {
  final List<RecordModel> records;
  FetchAllRecordsSuccess({required this.records});
}

final class FetchAllRecordsFailure extends AllRecordState {
  final String errMessage;
  FetchAllRecordsFailure({required this.errMessage});
}


