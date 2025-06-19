import 'package:admin_app/features/add_record/presentation/view/widget/record_card_shimmer.dart';
import 'package:admin_app/features/add_record/presentation/view/widget/section_card.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_sections_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SectionList extends StatelessWidget {
  final int serviceId;
  const SectionList({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.only(top: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(13),
        ),
        child: BlocBuilder<AllSectionsCubit, AllSectionsState>(
          builder: (context, state) {
            if (state is SectionLoading) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: RecordCardShimmer(),
              );
            } else if (state is SectionFailure) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else if (state is SectionLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.sections.length,
                itemBuilder: (context, index) {
                  final section = state.sections[index];
                  return SectionCard(
                    section: section,
                    serviceId: serviceId,
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
