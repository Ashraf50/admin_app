import '../model/statistics_model/statistics_model.dart';

abstract class DashboardRepo {
  Future<StatisticsModel> getStatistics();
}
