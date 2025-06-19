import 'package:admin_app/core/constant/app_strings.dart';
import 'package:admin_app/core/helper/api_helper.dart';
import 'package:admin_app/features/dashboard/data/model/statistics_model/statistics_model.dart';
import 'package:dio/dio.dart';
import 'dashboard_repo.dart';

class DashboardRepoImpl implements DashboardRepo {
  final ApiHelper apiHelper;
  DashboardRepoImpl(this.apiHelper);
  @override
  Future<StatisticsModel> getStatistics() async {
    try {
      final response =
          await apiHelper.get('${AppStrings.baseUrl}/api/admin/statistics');
      return StatisticsModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Unexpected error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}
