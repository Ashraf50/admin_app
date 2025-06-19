import 'package:admin_app/core/constant/app_styles.dart';
import 'package:admin_app/core/widget/custom_app_bar.dart';
import 'package:admin_app/core/widget/custom_scaffold.dart';
import 'package:admin_app/core/widget/custom_search.dart';
import 'package:admin_app/features/add_record/presentation/view/widget/section_list.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_sections_cubit.dart';
import 'package:admin_app/features/all_tickets/presentation/view/widget/add_button.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SectionsView extends StatefulWidget {
  final int serviceId;
  const SectionsView({super.key, required this.serviceId});

  @override
  State<SectionsView> createState() => _SectionsViewState();
}

class _SectionsViewState extends State<SectionsView> {
  @override
  void initState() {
    context.read<AllSectionsCubit>().fetchSections(widget.serviceId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return CustomScaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: S.of(context).service_details),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AllSectionsCubit, AllSectionsState>(
          builder: (context, state) {
            int sectionCount = 0;
            if (state is SectionLoaded) {
              sectionCount = state.sections.length;
            }
            return ListView(
              children: [
                CustomSearch(
                  controller: searchController,
                  hintText: S.of(context).search,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  onChange: (value) {
                    if (value.trim().isEmpty) {
                      context
                          .read<AllSectionsCubit>()
                          .fetchSections(widget.serviceId);
                    } else {
                      context
                          .read<AllSectionsCubit>()
                          .searchSection(value, widget.serviceId);
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        "$sectionCount",
                        style: AppStyles.textStyle18bold,
                      ),
                    ),
                    AddButton(
                      title: S.of(context).createNew,
                      onTap: () {
                        context.push("/create_section",
                            extra: widget.serviceId);
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),
                SectionList(
                  serviceId: widget.serviceId,
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
