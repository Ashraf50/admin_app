import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import '../../features/add_record/data/model/record_model.dart';

class DropdownTextField extends StatelessWidget {
  final List<RecordModel> records;
  final ValueChanged<RecordModel> onChanged;
  final RecordModel? selectedRecord;
  const DropdownTextField({
    super.key,
    required this.records,
    required this.onChanged,
    required this.selectedRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RecordModel>(
          isExpanded: true,
          value: selectedRecord,
          dropdownColor: AppColors.white,
          hint: Text(
            S.of(context).selectService,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          items: records.map((record) {
            return DropdownMenuItem<RecordModel>(
              value: record,
              child: Text(record.name!),
            );
          }).toList(),
          onChanged: (record) {
            if (record != null) {
              onChanged(record);
            }
          },
        ),
      ),
    );
  }
}
