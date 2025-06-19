import 'package:admin_app/core/error/failure.dart';
import 'package:admin_app/features/add_record/data/model/record_model.dart';
import 'package:dartz/dartz.dart';

abstract class RecordRepo {
  Future<Either<Failure, List<RecordModel>>> fetchAllRecords();
  Future<Either<Failure, List<RecordModel>>> fetchSelectableServices({
    int? onlyUnique,
    int? ignoredId,
  });
  Future<Either<Failure, List<RecordModel>>> searchRecord(
      {required String name});
  Future<Either<Failure, Unit>> deleteRecord(int id);
  Future<Either<Failure, Unit>> editRecord({
    required int id,
    required String name,
  });
  Future<Either<Failure, Unit>> createRecord({required String name});
}
