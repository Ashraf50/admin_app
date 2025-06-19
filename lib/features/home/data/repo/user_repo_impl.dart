import 'dart:io';
import 'package:admin_app/core/constant/app_strings.dart';
import 'package:admin_app/core/error/failure.dart';
import 'package:admin_app/core/helper/api_helper.dart';
import 'package:admin_app/features/home/data/model/user_model/user_model.dart';
import 'package:admin_app/features/home/data/repo/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/constant/func/get_token.dart';

class UserRepoImpl implements UserRepo {
  final ApiHelper apiHelper;
  UserRepoImpl(this.apiHelper);

  @override
  Future<Either<Failure, UserModel>> fetchUserData({
    required String token,
  }) async {
    try {
      final response = await apiHelper.get(
        '${AppStrings.baseUrl}/auth/profile',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      final userData = UserModel.fromJson(response.data);
      return Right(userData);
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch user data: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateData({
    required String name,
    required String email,
    required String phone,
    required File avatar,
  }) async {
    try {
      final token = await getToken();
      final formData = FormData.fromMap({
        'name': name,
        'email': email,
        'phone': phone,
        'avatar':
            await MultipartFile.fromFile(avatar.path, filename: 'avatar.jpg'),
      });

      final response = await apiHelper.post(
        '${AppStrings.baseUrl}/auth/profile',
        formData,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final updatedUser = UserModel.fromJson(response.data);
      return Right(updatedUser);
    } on DioException catch (e) {
      return Left(handleDioFailure(e));
    } catch (e) {
      return Left(ServerFailure('Failed to update user: $e'));
    }
  }
}

Failure handleDioFailure(DioException e) {
  if (e.response != null && e.response?.data != null) {
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return ServerFailure(data['message']);
    }
  }
  return ServerFailure('Unexpected error occurred. Please try again.');
}
