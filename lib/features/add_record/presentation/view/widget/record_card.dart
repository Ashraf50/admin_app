import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/core/widget/custom_toast.dart';
import 'package:admin_app/features/add_record/data/model/record_model.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_record_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class RecordCard extends StatelessWidget {
  final RecordModel record;
  const RecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "#${record.id}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                record.name ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(S.of(context).edit),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(S.of(context).delete),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(context);
                      } else if (value == 'delete') {
                        _showDeleteDialog(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: record.name);
    final formKey = GlobalKey<FormState>();
    SmartDialog.show(
      builder: (_) => AlertDialog(
        title: Text(S.of(context).edit_service),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(labelText: S.of(context).name),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).name;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => SmartDialog.dismiss(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newName = nameController.text.trim();
                final originalName = record.name!.trim();
                if (newName == originalName) {
                  CustomToast.show(
                    message: S.of(context).no_changes_detected,
                    backgroundColor: AppColors.darkGrey,
                  );
                  return;
                }
                context.read<AllRecordCubit>().editRecord(record.id!, newName);
                SmartDialog.dismiss();
              }
            },
            child: Text(S.of(context).save),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    SmartDialog.show(
      builder: (_) => AlertDialog(
        title: Text(S.of(context).confirm_delete),
        content: Text(S.of(context).sure_delete_service),
        actions: [
          TextButton(
            onPressed: () => SmartDialog.dismiss(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<AllRecordCubit>().deleteRecord(record.id!);
              SmartDialog.dismiss();
            },
            child: Text(S.of(context).delete,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
