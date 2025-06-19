import 'package:admin_app/core/constant/app_images.dart';
import 'package:admin_app/features/add_record/presentation/view/widget/section_card.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_sections_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SectionList extends StatelessWidget {
  final int serviceId;
  const SectionList({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllSectionsCubit, AllSectionsState>(
      builder: (context, state) {
        if (state is SectionLoading) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          );
        } else if (state is SectionFailure) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is SectionLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.sections.length + 1,
            itemBuilder: (context, index) {
              if (index < state.sections.length) {
                final section = state.sections[index];
                return SectionCard(
                  section: section,
                  serviceId: serviceId,
                );
              } else {
                return ListTile(
                  onTap: () {
                    context.push('/create_section', extra: serviceId);
                  },
                  title: Text(
                    S.of(context).add_Section,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  leading: SvgPicture.asset(
                    Assets.addRecord,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                    height: 25,
                  ),
                );
              }
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
