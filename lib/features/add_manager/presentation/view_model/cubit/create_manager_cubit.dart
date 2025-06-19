import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/manager_repo.dart';
part 'create_manager_state.dart';

class CreateManagerCubit extends Cubit<CreateManagerState> {
  ManagerRepo managerRepo;
  CreateManagerCubit(this.managerRepo) : super(CreateManagerInitial());

  Future<bool> createManager({
    required String serviceId,
    required String name,
    required String email,
    required String password,
    required String confirmPass,
    required bool autoAssign,
  }) async {
    emit(CreateManagerLoading());
    final result = await managerRepo.createManager(
      name: name,
      email: email,
      password: password,
      confirmPass: confirmPass,
      serviceId: serviceId,
      autoAssign: autoAssign,
    );
    return result.fold(
      (failure) {
        emit(CreateManagerFailure(errMessage: failure.errMessage));
        return false;
      },
      (_) async {
        emit(CreateManagerSuccess());
        return true;
      },
    );
  }
}
