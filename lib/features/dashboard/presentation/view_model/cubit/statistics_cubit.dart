import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/statistics_model/statistics_model.dart';
import '../../../data/repo/dashboard_repo.dart';
part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final DashboardRepo dashboardRepo;
  StatisticsCubit(this.dashboardRepo) : super(StatisticsInitial());
  Future<void> fetchStatistics() async {
    emit(StatisticsLoading());
    try {
      final data = await dashboardRepo.getStatistics();
      emit(StatisticsLoaded(statistics: data));
    } catch (e) {
      emit(StatisticsError(
          message: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
