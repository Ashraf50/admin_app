import 'package:admin_app/features/add_record/data/repo/section/section_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/section_model.dart';
part 'all_sections_state.dart';

class AllSectionsCubit extends Cubit<AllSectionsState> {
  SectionRepo sectionRepo;
  AllSectionsCubit(this.sectionRepo) : super(AllSectionsInitial());

  Future<void> fetchSections(int serviceId) async {
    emit(AllSectionsInitial());
    emit(SectionLoading());
    final result = await sectionRepo.fetchSectionsByServiceId(serviceId);
    result.fold(
      (failure) => emit(SectionFailure(message: failure.errMessage)),
      (sections) => emit(SectionLoaded(sections: sections)),
    );
  }

  Future<bool> createSection(String name, int serviceId) async {
    final result =
        await sectionRepo.createSection(name: name, serviceId: serviceId);
    return result.fold(
      (failure) {
        emit(SectionFailure(message: failure.errMessage));
        return false;
      },
      (_) async {
        await fetchSections(serviceId);
        return true;
      },
    );
  }

  Future<void> deleteSection(
      {required int serviceId, required int sectionId}) async {
    emit(SectionLoading());
    var result = await sectionRepo.deleteSection(
        sectionId: sectionId, serviceId: serviceId);
    result.fold(
      (failure) {
        emit(SectionFailure(message: failure.errMessage));
      },
      (_) async {
        await fetchSections(serviceId);
      },
    );
  }

  Future<void> editSection({
    required int serviceId,
    required int sectionId,
    required String name,
  }) async {
    emit(SectionLoading());
    var result = await sectionRepo.editSection(
      name: name,
      serviceId: serviceId,
      sectionId: sectionId,
    );
    result.fold(
      (failure) {
        emit(SectionFailure(message: failure.errMessage));
      },
      (_) async {
        await fetchSections(serviceId);
      },
    );
  }

  Future<void> searchSection(String name, int serviceId) async {
    emit(SectionLoading());
    var result =
        await sectionRepo.searchSection(name: name, serviceId: serviceId);
    result.fold(
      (failure) {
        emit(SectionFailure(message: failure.errMessage));
      },
      (sections) {
        emit(SectionLoaded(sections: sections));
      },
    );
  }
}
