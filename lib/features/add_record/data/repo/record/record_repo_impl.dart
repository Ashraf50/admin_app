import 'package:admin_app/core/constant/app_strings.dart';
import 'package:admin_app/core/constant/func/get_token.dart';
import 'package:admin_app/core/error/failure.dart';
import 'package:admin_app/core/helper/api_helper.dart';
import 'package:admin_app/features/add_record/data/model/record_model.dart';
import 'package:admin_app/features/add_record/data/repo/record/record_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class RecordRepoImpl implements RecordRepo {
  ApiHelper apiHelper;
  RecordRepoImpl(this.apiHelper);
  @override
  Future<Either<Failure, List<RecordModel>>> fetchAllRecords() async {
    try {
      final token = await getToken();
      var response = await apiHelper.get(
        '${AppStrings.baseUrl}/api/admin/services',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var data = response.data;
      var recordList =
          (data["data"] as List).map((e) => RecordModel.fromJson(e)).toList();
      return Right(recordList);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RecordModel>>> fetchSelectableServices({
    int? onlyUnique,
    int? ignoredId,
  }) async {
    try {
      final token = await getToken();
      Map<String, dynamic> queryParams = {};
      if (onlyUnique != null) {
        queryParams['only_unique'] = onlyUnique.toString();
      }
      if (ignoredId != null) {
        queryParams['ignored_id'] = ignoredId.toString();
      }

      var response = await apiHelper.get(
        '${AppStrings.baseUrl}/api/select_menu/services',
        queryParameters: queryParams,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      var data = response.data;
      var recordList =
          (data["data"] as List).map((e) => RecordModel.fromJson(e)).toList();
      return Right(recordList);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createRecord({required String name}) async {
    try {
      final token = await getToken();
      final data = {
        "name": name,
      };
      await apiHelper.post(
        '${AppStrings.baseUrl}/api/admin/services',
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
  Future<Either<Failure, List<RecordModel>>> searchRecord(
      {required String name}) async {
    try {
      final token = await getToken();
      final response = await apiHelper.get(
        '${AppStrings.baseUrl}/api/admin/services?handle=$name',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var data = response.data;
      var recordList =
          (data["data"] as List).map((e) => RecordModel.fromJson(e)).toList();
      return Right(recordList);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRecord(int id) async {
    try {
      final token = await getToken();
      await apiHelper.delete(
        '${AppStrings.baseUrl}/api/admin/services/$id',
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
  Future<Either<Failure, Unit>> editRecord({
    required int id,
    required String name,
  }) async {
    try {
      final token = await getToken();
      final data = {
        'name': name,
      };
      await apiHelper.put(
        '${AppStrings.baseUrl}/api/admin/services/$id',
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
}