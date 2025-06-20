import 'package:admin_app/core/helper/api_helper.dart';
import 'package:admin_app/features/Auth/data/repo/auth_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../../../../core/constant/app_strings.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiHelper apiHelper;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  AuthRepoImpl(this.apiHelper);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiHelper.post(
        '${AppStrings.baseUrl}/auth/login',
        {
          'email': email,
          'password': password,
        },
      );
      final data = response.data;
      if (data['type'] == 'success') {
        final user = data['data']['user'];
        if (user['type'] != 0) {
          return {
            'type': 'error',
            'message': 'This account is not a admin.',
          };
        }
      }
      return data;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await secureStorage.containsKey(key: 'auth_token');
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: 'auth_token');
  }

  @override
  Future<void> saveTokens(
      String token, String refreshToken, String userId) async {
    await secureStorage.write(key: 'auth_token', value: token);
    await secureStorage.write(key: 'refresh_token', value: refreshToken);
    await secureStorage.write(key: 'user_id', value: userId);
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.deleteAll();
  }

  Exception handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final errorData = e.response?.data;
      if (errorData is Map<String, dynamic>) {
        final message = errorData['message'] ?? 'An unexpected error occurred';
        return Exception(message);
      }
    }
    return Exception('Connection error. Please try again.');
  }
}

Exception handleDioError(DioException e) {
  if (e.response != null && e.response?.data != null) {
    final errorData = e.response?.data;

    if (errorData is Map<String, dynamic>) {
      final message = errorData['message'] ?? 'An unexpected error occurred';
      return Exception(message);
    }
  }
  return Exception('Connection error. Please try again.');
}
