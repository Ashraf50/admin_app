import 'package:admin_app/core/widget/custom_scaffold.dart';
import 'package:admin_app/features/add_manager/presentation/view/widget/all_manager_list_view.dart';
import 'package:admin_app/features/add_manager/presentation/view_model/cubit/add_manager_cubit.dart';
import 'package:admin_app/features/all_tickets/presentation/view/widget/add_button.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../core/constant/app_styles.dart';
import '../../../../../../../core/widget/custom_search.dart';

class AddManagerViewBody extends StatelessWidget {
  const AddManagerViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return CustomScaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AddManagerCubit, AddManagerState>(
          builder: (context, state) {
            int managerCount = 0;
            if (state is FetchManagerSuccess) {
              managerCount = state.managers.length;
            }
            return Column(
              children: [
                CustomSearch(
                  controller: searchController,
                  hintText: S.of(context).search,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  onChange: (value) {
                    if (value.trim().isEmpty) {
                      context.read<AddManagerCubit>().fetchManager();
                    } else {
                      context.read<AddManagerCubit>().searchManager(value);
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
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
                        "$managerCount",
                        style: AppStyles.textStyle18bold,
                      ),
                    ),
                    AddButton(
                      title: S.of(context).createNew,
                      onTap: () {
                        context.push("/add_new_manager");
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Expanded(child: AllManageListView()),
                const SizedBox(
                  height: 40,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
