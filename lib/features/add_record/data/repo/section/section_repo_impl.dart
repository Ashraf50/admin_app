import 'package:admin_app/core/constant/app_strings.dart';
import 'package:admin_app/core/constant/func/get_token.dart';
import 'package:admin_app/core/error/failure.dart';
import 'package:admin_app/core/helper/api_helper.dart';
import 'package:admin_app/features/add_record/data/repo/section/section_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../model/section_model.dart';

class SectionRepoImpl implements SectionRepo {
  ApiHelper apiHelper;
  SectionRepoImpl(this.apiHelper);

  @override
  Future<Either<Failure, Unit>> createSection(
      {required String name, required int serviceId}) async {
    try {
      final token = await getToken();
      final data = {
        "name": name,
      };
      await apiHelper.post(
        '${AppStrings.baseUrl}/api/admin/services/$serviceId/sections',
        data,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return const Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> editSection({
    required int serviceId,
    required int sectionId,
    required String name,
  }) async {
    try {
      final token = await getToken();
      final data = {
        'name': name,
      };
      await apiHelper.put(
        '${AppStrings.baseUrl}/api/admin/services/$serviceId/sections/$sectionId',
        data,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return const Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SectionModel>>> fetchSectionsByServiceId(
      int serviceId) async {
    try {
      final token = await getToken();
      final response = await apiHelper.get(
        '${AppStrings.baseUrl}/api/admin/services/$serviceId/sections',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      final data = response.data['data'];
      final sections =
          (data as List).map((e) => SectionModel.fromJson(e)).toList();
      return Right(sections);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSection(
      {required int serviceId, required int sectionId}) async {
    try {
      final token = await getToken();
      await apiHelper.delete(
        '${AppStrings.baseUrl}/api/admin/services/$serviceId/sections/$sectionId',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return const Right(unit);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SectionModel>>> searchSection({
    required String name,
    required int serviceId,
  }) async {
    try {
      final token = await getToken();
      final response = await apiHelper.get(
        '${AppStrings.baseUrl}/api/admin/services/$serviceId/sections?handle=$name',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var data = response.data;
      var recordList =
          (data["data"] as List).map((e) => SectionModel.fromJson(e)).toList();
      return Right(recordList);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
