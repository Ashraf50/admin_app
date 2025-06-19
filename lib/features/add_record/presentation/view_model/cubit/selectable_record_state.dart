part of 'selectable_record_cubit.dart';

sealed class SelectableRecordState {}

final class SelectableRecordInitial extends SelectableRecordState {}
final class FetchSelectableRecordsLoading extends SelectableRecordState {}

final class FetchSelectableRecordsSuccess extends SelectableRecordState {
  final List<RecordModel> records;
  FetchSelectableRecordsSuccess({required this.records});
}

final class FetchSelectableRecordsFailure extends SelectableRecordState {
  final String errMessage;
  FetchSelectableRecordsFailure({required this.errMessage});
}
