import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/core/constant/app_styles.dart';
import 'package:admin_app/core/widget/custom_app_bar.dart';
import 'package:admin_app/core/widget/custom_button.dart';
import 'package:admin_app/core/widget/custom_scaffold.dart';
import 'package:admin_app/core/widget/custom_toast.dart';
import 'package:admin_app/features/add_manager/presentation/view_model/cubit/add_manager_cubit.dart';
import 'package:admin_app/features/add_manager/presentation/view_model/cubit/create_manager_cubit.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/selectable_record_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../core/widget/custom_text_field.dart';
import '../../../../../../../core/widget/drop_down_text_field.dart';
import '../../../../add_record/data/model/record_model.dart';

class AddNewManager extends StatefulWidget {
  const AddNewManager({super.key});

  @override
  State<AddNewManager> createState() => _AddNewManagerState();
}

class _AddNewManagerState extends State<AddNewManager> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  bool visibility = true;
  bool autoAssign = false;
  final formKey = GlobalKey<FormState>();
  int? selectedServiceId;
  RecordModel? selectedRecord;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateManagerCubit, CreateManagerState>(
      listener: (context, state) {
        if (state is CreateManagerLoading) {
          SmartDialog.showLoading();
        } else if (state is CreateManagerFailure) {
          SmartDialog.dismiss();
          CustomToast.show(
            message: state.errMessage,
            alignment: Alignment.bottomCenter,
            backgroundColor: Colors.red,
          );
        } else if (state is CreateManagerSuccess) {
          SmartDialog.dismiss();
          context.pop(context);
          context.read<AddManagerCubit>().fetchManager();
          CustomToast.show(
            message: S.of(context).manager_created_successfully,
            alignment: Alignment.topCenter,
            backgroundColor: AppColors.toastColor,
          );
        }
      },
      child: CustomScaffold(
        appBar: CustomAppBar(title: S.of(context).createNew),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  S.of(context).name,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).name,
                  controller: nameController,
                ),
                Text(
                  S.of(context).Email,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).email,
                  controller: emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return value != null && !EmailValidator.validate(value)
                        ? S.of(context).enter_valid_email
                        : null;
                  },
                ),
                Text(
                  S.of(context).service_name,
                  style: AppStyles.textStyle18bold,
                ),
                BlocBuilder<SelectableRecordCubit, SelectableRecordState>(
                  builder: (context, state) {
                    if (state is FetchSelectableRecordsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FetchSelectableRecordsFailure) {
                      return Text(state.errMessage);
                    } else if (state is FetchSelectableRecordsSuccess) {
                      return DropdownTextField(
                        records: state.records,
                        selectedRecord: selectedRecord,
                        onChanged: (record) {
                          setState(() {
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
                const SizedBox(
                  height: 10,
                ),
                Text(
                  S.of(context).Password,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).password,
                  obscureText: visibility,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    icon: visibility
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.grey,
                          ),
                  ),
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.length < 8) {
                      return S.of(context).pass_short;
                    } else {
                      return null;
                    }
                  },
                ),
                Text(
                  S.of(context).confirmPassword,
                  style: AppStyles.textStyle18bold,
                ),
                CustomTextfield(
                  hintText: S.of(context).confirmPassword,
                  obscureText: visibility,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        visibility = !visibility;
                      });
                    },
                    icon: visibility
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.grey,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.grey,
                          ),
                  ),
                  controller: confirmPassController,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: autoAssign,
                        onChanged: (bool? value) {
                          setState(() {
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
                CustomButton(
                  title: S.of(context).submit,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      final cubit = context.read<CreateManagerCubit>();
                      await cubit.createManager(
                        autoAssign: autoAssign,
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        confirmPass: confirmPassController.text,
                        serviceId: selectedServiceId.toString(),
                      );
                    } else {
                      CustomToast.show(
                        message: S.of(context).check_email,
                      );
                    }
                  },
                  color: nameController.text.isEmpty
                      ? AppColors.inActiveBlue
                      : AppColors.activeBlue,
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
