import 'package:admin_app/core/constant/app_strings.dart';
import 'package:admin_app/core/constant/func/get_token.dart';
import 'package:admin_app/core/error/failure.dart';
import 'package:admin_app/core/helper/api_helper.dart';
import 'package:admin_app/features/add_manager/data/model/manager_model/manager_model.dart';
import 'package:admin_app/features/add_manager/data/repo/manager_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ManagerRepoImpl implements ManagerRepo {
  ApiHelper apiHelper;
  ManagerRepoImpl(this.apiHelper);
  @override
  Future<Either<Failure, Unit>> createManager({
    required String serviceId,
    required String name,
    required String email,
    required String password,
    required String confirmPass,
    required bool autoAssign,
  }) async {
    try {
      final token = await getToken();
      await apiHelper.post(
        '${AppStrings.baseUrl}/api/admin/managers',
        {
          "service_id": serviceId,
          "automatic_assignment": autoAssign,
          "user": {
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": confirmPass,
          }
        },
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
  Future<Either<Failure, Unit>> deleteManager(int id) async {
    try {
      final token = await getToken();
      await apiHelper.delete(
        '${AppStrings.baseUrl}/api/admin/managers/$id',
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
  Future<Either<Failure, Unit>> editManager({
    required String serviceId,
    required int managerId,
    required String name,
    required String email,
    required String password,
    required String confirmPass,
    required bool autoAssign,
  }) async {
    try {
      final token = await getToken();
      final data = {
        "service_id": serviceId,
        "automatic_assignment": autoAssign,
        "user": {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": confirmPass,
        }
      };
      await apiHelper.put(
        '${AppStrings.baseUrl}/api/admin/managers/$managerId',
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
  Future<Either<Failure, List<ManagerModel>>> fetchAllManagers() async {
    try {
      final token = await getToken();
      var response = await apiHelper.get(
        '${AppStrings.baseUrl}/api/admin/managers',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var data = response.data;
      var recordList =
          (data["data"] as List).map((e) => ManagerModel.fromJson(e)).toList();
      return Right(recordList);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ManagerModel>>> searchManager(
      {required String name}) async {
    try {
      final token = await getToken();
      final response = await apiHelper.get(
        '${AppStrings.baseUrl}/api/admin/managers?handle=$name',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var data = response.data;
      var managerList =
          (data["data"] as List).map((e) => ManagerModel.fromJson(e)).toList();
      return Right(managerList);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDiorError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
