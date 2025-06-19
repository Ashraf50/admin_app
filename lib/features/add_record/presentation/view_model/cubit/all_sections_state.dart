part of 'all_sections_cubit.dart';

sealed class AllSectionsState {}

final class AllSectionsInitial extends AllSectionsState {}

class SectionLoading extends AllSectionsState {}

class SectionLoaded extends AllSectionsState {
  final List<SectionModel> sections;
  SectionLoaded({required this.sections});
}

class SectionFailure extends AllSectionsState {
  final String message;
  SectionFailure({required this.message});
}
