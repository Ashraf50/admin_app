import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/core/helper/api_helper.dart';
import 'package:admin_app/core/widget/custom_toast.dart';
import 'package:admin_app/features/add_record/data/model/record_model.dart';
import 'package:admin_app/features/add_record/data/repo/section/section_repo_impl.dart';
import 'package:admin_app/features/add_record/presentation/view/widget/section_list.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_record_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../view_model/cubit/all_sections_cubit.dart';

class RecordCard extends StatefulWidget {
  final RecordModel record;
  const RecordCard({super.key, required this.record});

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  bool isExpanded = false;

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
                "#${widget.record.id}",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.record.name ?? '',
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
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                      if (isExpanded) {
                        context
                            .read<AllSectionsCubit>()
                            .fetchSections(widget.record.id!);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isExpanded)
          BlocProvider(
            create: (_) => AllSectionsCubit(SectionRepoImpl(ApiHelper()))
              ..fetchSections(widget.record.id!),
            child: SectionList(
              key: ValueKey(widget.record.id),
              serviceId: widget.record.id!,
            ),
          ),
        const Divider(),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController = TextEditingController(text: widget.record.name);
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
                final originalName = widget.record.name!.trim();
                if (newName == originalName) {
                  CustomToast.show(
                    message: S.of(context).no_changes_detected,
                    backgroundColor: AppColors.darkGrey,
                  );
                  return;
                }
                context
                    .read<AllRecordCubit>()
                    .editRecord(widget.record.id!, newName);
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
              context.read<AllRecordCubit>().deleteRecord(widget.record.id!);
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
