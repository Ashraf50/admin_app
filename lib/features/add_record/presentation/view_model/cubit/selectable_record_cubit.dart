import 'package:admin_app/features/add_record/data/repo/record/record_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/record_model.dart';
part 'selectable_record_state.dart';

class SelectableRecordCubit extends Cubit<SelectableRecordState> {
  RecordRepo recordRepo;
  SelectableRecordCubit(this.recordRepo) : super(SelectableRecordInitial());
  Future<void> fetchSelectableRecords({
    int? onlyUnique,
    int? ignoredId,
  }) async {
    emit(FetchSelectableRecordsLoading());
    var result = await recordRepo.fetchSelectableServices(
        onlyUnique: onlyUnique, ignoredId: ignoredId);
    result.fold(
      (failure) {
        emit(
          FetchSelectableRecordsFailure(errMessage: failure.errMessage),
        );
      },
      (records) {
        emit(
          FetchSelectableRecordsSuccess(records: records),
        );
      },
    );
  }
}
