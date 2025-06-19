import 'package:admin_app/features/add_record/presentation/view/widget/record_card.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_record_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepartmentListView extends StatelessWidget {
  const DepartmentListView({super.key});

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
        child: BlocBuilder<AllRecordCubit, AllRecordState>(
          builder: (context, state) {
            if (state is FetchAllRecordsSuccess) {
              if (state.records.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(S.of(context).no_service),
                  ),
                );
              }
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.records.length,
                itemBuilder: (context, index) {
                  return RecordCard(
                    record: state.records[index],
                  );
                },
              );
            } else if (state is FetchAllRecordsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FetchAllRecordsFailure) {
              return Center(
                child: Text(state.errMessage),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
