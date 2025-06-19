import 'package:admin_app/core/constant/app_styles.dart';
import 'package:admin_app/core/widget/custom_scaffold.dart';
import 'package:admin_app/core/widget/custom_search.dart';
import 'package:admin_app/features/add_record/presentation/view/widget/department_list.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_record_cubit.dart';
import 'package:admin_app/features/all_tickets/presentation/view/widget/add_button.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddRecordViewBody extends StatelessWidget {
  const AddRecordViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AllRecordCubit, AllRecordState>(
          builder: (context, state) {
            int recordCount = 0;
            if (state is FetchAllRecordsSuccess) {
              recordCount = state.records.length;
            }
            return ListView(
              children: [
                CustomSearch(
                  controller: searchController,
                  hintText: S.of(context).search,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  onChange: (value) {
                    if (value.trim().isEmpty) {
                      context.read<AllRecordCubit>().fetchAllRecord();
                    } else {
                      context.read<AllRecordCubit>().searchRecord(value);
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
                        "$recordCount",
                        style: AppStyles.textStyle18bold,
                      ),
                    ),
                    AddButton(
                      title: S.of(context).createNew,
                      onTap: () {
                        context.push("/create_record");
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const DepartmentListView(),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
