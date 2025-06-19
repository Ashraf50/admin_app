import 'package:admin_app/features/all_tickets/presentation/view_model/cubit/ticket_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../add_record/data/model/record_model.dart';

class SortDialog extends StatefulWidget {
  const SortDialog({super.key});

  @override
  SortDialogState createState() => SortDialogState();
}

class SortDialogState extends State<SortDialog> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  int? selectedServiceId;
  RecordModel? selectedRecord;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd', 'en').format(picked);
      });
    }
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).filterTickets,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _selectDate(context, fromController),
            child: AbsorbPointer(
              child: TextField(
                controller: fromController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: S.of(context).from,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _selectDate(context, toController),
            child: AbsorbPointer(
              child: TextField(
                controller: toController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  labelText: S.of(context).to,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            String from = fromController.text;
            String to = toController.text;
            context.read<TicketCubit>().fetchSortedTickets(
                  from: from,
                  to: to,
                );
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).apply),
        ),
        TextButton(
          onPressed: () {
            context.read<TicketCubit>()
              ..currentPage = 1
              ..hasMore = true
              ..allTickets.clear()
              ..fetchTickets();
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).showAll),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            S.of(context).cancel,
          ),
        ),
      ],
    );
  }
}
