import 'package:admin_app/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../model/section_model.dart';

abstract class SectionRepo {
  Future<Either<Failure, List<SectionModel>>> fetchSectionsByServiceId(
      int serviceId);

  Future<Either<Failure, Unit>> deleteSection({
    required int serviceId,
    required int sectionId,
  });
  Future<Either<Failure, Unit>> editSection({
    required int serviceId,
    required int sectionId,
    required String name,
  });
  Future<Either<Failure, Unit>> createSection(
      {required String name, required int serviceId});
  Future<Either<Failure, List<SectionModel>>> searchSection({
    required String name,
    required int serviceId,
  });
}
