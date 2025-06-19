import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/core/constant/app_styles.dart';
import 'package:admin_app/core/widget/custom_text_field.dart';
import 'package:admin_app/features/add_manager/data/model/manager_model/manager_model.dart';
import 'package:admin_app/features/add_manager/presentation/view_model/cubit/add_manager_cubit.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/selectable_record_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../../../core/widget/custom_toast.dart';
import '../../../../../core/widget/drop_down_text_field.dart';
import '../../../../add_record/data/model/record_model.dart';

class ManagerCard extends StatefulWidget {
  final ManagerModel manager;
  const ManagerCard({super.key, required this.manager});

  @override
  State<ManagerCard> createState() => _ManagerCardState();
}

class _ManagerCardState extends State<ManagerCard> {
  int? selectedServiceId;
  RecordModel? selectedRecord;
  bool autoAssign = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.manager.service?.name ?? S.of(context).null_value,
                    style: AppStyles.textStyle16,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.manager.user!.name!,
                        style: AppStyles.textStyle18black,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .6,
                        child: Text(
                          widget.manager.user!.email!,
                          style: AppStyles.textStyle18black,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              PopupMenuButton(
                color: Colors.white,
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(S.of(context).edit),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      S.of(context).delete,
                    ),
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
          const Divider(),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final nameController =
        TextEditingController(text: widget.manager.user!.name!);
    final emailController =
        TextEditingController(text: widget.manager.user!.email!);
    final passwordController = TextEditingController();
    final confirmPassController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocListener<AddManagerCubit, AddManagerState>(
          listener: (context, state) {
            if (state is EditManagerSuccess) {
              Navigator.pop(context);
              CustomToast.show(
                message: S.of(context).Profile_updated,
                backgroundColor: AppColors.toastColor,
              );
            } else if (state is EditManagerFailure) {
              CustomToast.show(
                message: state.errMessage,
                backgroundColor: Colors.red,
              );
            }
          },
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        S.of(context).edit_manager,
                        style: AppStyles.textStyle18bold,
                        textAlign: TextAlign.center,
                      ),
                      BlocBuilder<SelectableRecordCubit, SelectableRecordState>(
                        builder: (context, state) {
                          if (state is FetchSelectableRecordsLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is FetchSelectableRecordsFailure) {
                            return Text(state.errMessage);
                          } else if (state is FetchSelectableRecordsSuccess) {
                            return DropdownTextField(
                              records: state.records,
                              selectedRecord: selectedRecord,
                              hint: widget.manager.service!.name!,
                              onChanged: (record) {
                                setModalState(() {
                                  selectedRecord = record;
                                  selectedServiceId = record.id;
                                });
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextfield(
                        hintText: S.of(context).name,
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).name;
                          }
                          return null;
                        },
                      ),
                      CustomTextfield(
                        hintText: S.of(context).email,
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).enter_valid_email;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextfield(
                        hintText: S.of(context).password,
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).pass_short;
                          }
                          return null;
                        },
                      ),
                      CustomTextfield(
                        hintText: S.of(context).confirmPassword,
                        controller: confirmPassController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).confirmPassword;
                          }
                          if (value != passwordController.text) {
                            return S.of(context).pass_not_match;
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: autoAssign,
                              onChanged: (bool? value) {
                                setModalState(() {
                                  autoAssign = value ?? false;
                                });
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              S.of(context).automatic_assignment,
                              style: AppStyles.textStyle18bold,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(S.of(context).cancel),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                context.read<AddManagerCubit>().editManager(
                                      serviceId: selectedServiceId.toString(),
                                      managerId: widget.manager.id!,
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      confirmPass: confirmPassController.text,
                                      autoAssign: autoAssign,
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkBlue,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(S.of(context).save),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    SmartDialog.show(
      builder: (_) => AlertDialog(
        title: Text(
          S.of(context).confirm_delete,
        ),
        content: Text(S.of(context).sure_delete_manager),
        actions: [
          TextButton(
            onPressed: () => SmartDialog.dismiss(),
            child: Text(
              S.of(context).cancel,
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AddManagerCubit>().deleteManager(widget.manager.id!);
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
