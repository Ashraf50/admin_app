import 'package:admin_app/core/constant/app_styles.dart';
import 'package:admin_app/core/widget/custom_app_bar.dart';
import 'package:admin_app/core/widget/custom_scaffold.dart';
import 'package:admin_app/features/all_tickets/data/model/ticket_model/ticket_model/ticket_model.dart';
import 'package:admin_app/features/all_tickets/presentation/view/widget/status_button.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketsDetailsView extends StatelessWidget {
  final TicketModel ticket;
  const TicketsDetailsView({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: S.of(context).ticket_details,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                CustomWidget(
                  title: "${S.of(context).ticket_id}: ",
                  subTitle: ticket.id.toString(),
                ),
                CustomWidget(
                  title: "${S.of(context).title}: ",
                  subTitle: ticket.title ?? "No Title",
                ),
                CustomWidget(
                  title: "${S.of(context).created_at}: ",
                  subTitle: formatDateWithOrdinal(ticket.createdAt) ??
                      S.of(context).no_details,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).status,
                      style: AppStyles.textStyle16,
                    ),
                    StatusButton(
                      status: ticket.status!,
                    ),
                  ],
                ),
                CustomWidget(
                  title: "${S.of(context).manager_name}: ",
                  subTitle: ticket.manager?.user?.name ?? "N/A",
                ),
                CustomWidget(
                  title: "${S.of(context).service_name}: ",
                  subTitle: ticket.service?.name ?? "N/A",
                ),
                CustomWidget(
                  title: "${S.of(context).user_name}: ",
                  subTitle: ticket.user?.name ?? "N/A",
                ),
                CustomWidget(
                  title: "${S.of(context).ticketian_name}: ",
                  subTitle: ticket.technician?.user?.name ?? "N/A",
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${S.of(context).details}: ",
                    style: AppStyles.textStyle18bold,
                  ),
                  SelectableText(
                    ticket.description ?? S.of(context).no_details,
                    style: AppStyles.textStyle18black,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  const CustomWidget({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.textStyle16,
          ),
          SelectableText(
            subTitle,
            style: AppStyles.textStyle16Black,
          ),
        ],
      ),
    );
  }
}

String? formatDateWithOrdinal(String? dateString) {
  if (dateString == null) return null;
  try {
    final date = DateTime.parse(dateString);
    final month = DateFormat('MMMM').format(date);
    final year = DateFormat('y').format(date);
    return '$month ${date.day}${_getOrdinalSuffix(date.day)} $year';
  } catch (e) {
    return null;
  }
}

String _getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) return 'th';
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
