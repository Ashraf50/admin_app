import 'package:admin_app/features/add_record/data/model/record_model.dart';
import 'package:admin_app/features/add_record/data/repo/record/record_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'all_record_state.dart';

class AllRecordCubit extends Cubit<AllRecordState> {
  RecordRepo recordRepo;
  AllRecordCubit(this.recordRepo) : super(AllRecordInitial());
  Future<void> fetchAllRecord() async {
    emit(FetchAllRecordsLoading());
    var result = await recordRepo.fetchAllRecords();
    result.fold(
      (failure) {
        emit(
          FetchAllRecordsFailure(errMessage: failure.errMessage),
        );
      },
      (records) {
        emit(
          FetchAllRecordsSuccess(records: records),
        );
      },
    );
  }

  Future<bool> createRecord(String name) async {
    final result = await recordRepo.createRecord(name: name);
    return result.fold(
      (failure) {
        emit(FetchAllRecordsFailure(errMessage: failure.errMessage));
        return false;
      },
      (_) async {
        await fetchAllRecord();
        return true;
      },
    );
  }

  Future<void> searchRecord(String name) async {
    emit(FetchAllRecordsLoading());
    var result = await recordRepo.searchRecord(name: name);
    result.fold(
      (failure) {
        emit(FetchAllRecordsFailure(errMessage: failure.errMessage));
      },
      (records) {
        emit(FetchAllRecordsSuccess(records: records));
      },
    );
  }

  Future<void> deleteRecord(int id) async {
    emit(FetchAllRecordsLoading());
    var result = await recordRepo.deleteRecord(id);
    result.fold(
      (failure) {
        emit(FetchAllRecordsFailure(errMessage: failure.errMessage));
      },
      (_) async {
        await fetchAllRecord();
      },
    );
  }

  Future<void> editRecord(int id, String name) async {
    emit(FetchAllRecordsLoading());
    var result = await recordRepo.editRecord(id: id, name: name);
    result.fold(
      (failure) {
        emit(FetchAllRecordsFailure(errMessage: failure.errMessage));
      },
      (_) async {
        await fetchAllRecord();
      },
    );
  }
}
