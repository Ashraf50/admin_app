import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/core/widget/custom_toast.dart';
import 'package:admin_app/features/add_record/data/model/section_model.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_sections_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class SectionCard extends StatelessWidget {
  final SectionModel section;
  final int serviceId;
  const SectionCard({
    super.key,
    required this.section,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.subdirectory_arrow_right,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                section.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: section.name);
    final formKey = GlobalKey<FormState>();
    SmartDialog.show(
      builder: (_) => AlertDialog(
        title: Text(S.of(context).edit_section),
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
                final originalName = section.name.trim();
                if (newName == originalName) {
                  CustomToast.show(
                    message: S.of(context).no_changes_detected,
                    backgroundColor: AppColors.darkGrey,
                  );
                  return;
                }
                context.read<AllSectionsCubit>().editSection(
                      name: newName,
                      sectionId: section.id,
                      serviceId: serviceId,
                    );
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
        content: Text(S.of(context).sure_delete_section),
        actions: [
          TextButton(
            onPressed: () => SmartDialog.dismiss(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<AllSectionsCubit>().deleteSection(
                    sectionId: section.id,
                    serviceId: serviceId,
                  );
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
