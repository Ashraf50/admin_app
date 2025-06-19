import 'package:admin_app/core/widget/custom_toast.dart';
import 'package:admin_app/features/add_manager/data/model/manager_model/manager_model.dart';
import 'package:admin_app/features/add_manager/data/repo/manager_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'add_manager_state.dart';

class AddManagerCubit extends Cubit<AddManagerState> {
  ManagerRepo managerRepo;
  AddManagerCubit(this.managerRepo) : super(AddManagerInitial());

  Future<void> fetchManager() async {
    emit(FetchManagerLoading());
    var result = await managerRepo.fetchAllManagers();
    result.fold(
      (failure) {
        emit(
          FetchManagerFailure(errMessage: failure.errMessage),
        );
      },
      (managers) {
        emit(
          FetchManagerSuccess(managers: managers),
        );
      },
    );
  }

  Future<void> searchManager(String name) async {
    emit(FetchManagerLoading());
    var result = await managerRepo.searchManager(name: name);
    result.fold(
      (failure) {
        emit(SearchManagerFailure(errMessage: failure.errMessage));
      },
      (managers) {
        emit(FetchManagerSuccess(managers: managers));
      },
    );
  }

  Future<void> deleteManager(int id) async {
    var result = await managerRepo.deleteManager(id);
    result.fold(
      (failure) {
        CustomToast.show(
            message: failure.errMessage, backgroundColor: Colors.red);
        fetchManager();
      },
      (_) async {
        await fetchManager();
      },
    );
  }

  Future<void> editManager({
    required String serviceId,
    required int managerId,
    required String name,
    required String email,
    required String password,
    required String confirmPass,
    required bool autoAssign,
  }) async {
    emit(FetchManagerLoading());
    var result = await managerRepo.editManager(
      serviceId: serviceId,
      name: name,
      email: email,
      password: password,
      confirmPass: confirmPass,
      managerId: managerId,
      autoAssign: autoAssign,
    );
    result.fold(
      (failure) async {
        emit(EditManagerFailure(errMessage: failure.errMessage));
        await fetchManager();
      },
      (_) async {
        emit(EditManagerSuccess());
        await fetchManager();
      },
    );
  }
}
