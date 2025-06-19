import 'package:admin_app/core/widget/custom_app_bar.dart';
import 'package:admin_app/features/all_tickets/presentation/view/all_tickets.dart';
import 'package:admin_app/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:admin_app/features/home/presentation/view/widget/admin_drawer.dart';
import 'package:admin_app/features/settings/presentation/view/settings_view.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import '../../../add_manager/presentation/view/add_manager_view.dart';
import '../../../add_record/presentation/view/add_record.dart';

// ignore: must_be_immutable
class AdminHomeView extends StatefulWidget {
  int selectedIndex;
  AdminHomeView({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  final List<Widget> pages = const [
    DashboardView(),
    AllTicketsView(),
    AddManagerView(),
    AddRecordView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: [
          S.of(context).dashboard,
          S.of(context).allTickets,
          S.of(context).addManager,
          S.of(context).add_service,
          S.of(context).setting
        ][widget.selectedIndex],
      ),
      drawer: AdminDrawer(
        activeIndex: widget.selectedIndex,
        onItemSelected: (index) {
          setState(() {
            widget.selectedIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: widget.selectedIndex,
        children: pages,
      ),
    );
  }
}
