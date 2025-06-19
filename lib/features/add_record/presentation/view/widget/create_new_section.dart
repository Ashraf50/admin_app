import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/core/constant/app_styles.dart';
import 'package:admin_app/core/widget/custom_app_bar.dart';
import 'package:admin_app/core/widget/custom_button.dart';
import 'package:admin_app/core/widget/custom_scaffold.dart';
import 'package:admin_app/core/widget/custom_text_field.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_sections_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CreateNewSection extends StatefulWidget {
  final int serviceId;
  const CreateNewSection({super.key, required this.serviceId});

  @override
  State<CreateNewSection> createState() => _CreateNewSectionState();
}

class _CreateNewSectionState extends State<CreateNewSection> {
  final TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      SmartDialog.showToast(S.of(context).enter_name);
      return;
    }
    SmartDialog.showLoading(msg: S.of(context).creating);
    final result = await context
        .read<AllSectionsCubit>()
        .createSection(name, widget.serviceId);
    SmartDialog.dismiss();
    if (result) {
      SmartDialog.showToast(S.of(context).Service_created);
      Navigator.pop(context);
    } else {
      SmartDialog.showToast(S.of(context).someThingWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: S.of(context).createNew),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Text(S.of(context).section_name, style: AppStyles.textStyle18bold),
            CustomTextfield(
              hintText: S.of(context).section_name,
              controller: nameController,
            ),
            CustomButton(
              title: S.of(context).submit,
              onTap: _handleSubmit,
              color: nameController.text.isEmpty
                  ? AppColors.inActiveBlue
                  : AppColors.activeBlue,
            ),
          ],
        ),
      ),
    );
  }
}
