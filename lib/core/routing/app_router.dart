import 'package:admin_app/core/helper/navigator_service.dart';
import 'package:admin_app/core/widget/photo_view.dart';
import 'package:admin_app/features/Auth/presentation/view/sign_in_view.dart';
import 'package:admin_app/features/add_manager/presentation/view/widget/add_new_manager.dart';
import 'package:admin_app/features/add_record/presentation/view/widget/add_section_view_body.dart';
import 'package:admin_app/features/add_record/presentation/view/widget/create_new_section.dart';
import 'package:admin_app/features/all_tickets/data/model/ticket_model/ticket_model/ticket_model.dart';
import 'package:admin_app/features/dashboard/data/model/statistics_model/recent_ticket.dart';
import 'package:admin_app/features/dashboard/presentation/view/widget/ticket_details.dart';
import 'package:admin_app/features/home/data/model/user_model/user_model.dart';
import 'package:admin_app/features/home/presentation/view/admin_home_view.dart';
import 'package:admin_app/features/home/presentation/view/widget/edit_profile_view.dart';
import 'package:go_router/go_router.dart';
import '../../features/add_record/presentation/view/widget/create_new_record.dart';
import '../../features/all_tickets/presentation/view/widget/ticket_details_view.dart';

class AppRouter {
  final bool isLoggedIn;
  AppRouter({required this.isLoggedIn});
  late final GoRouter router = GoRouter(
    navigatorKey: NavigationService.rootNavigatorKey,
    initialLocation: isLoggedIn ? '/admin_home' : '/sign_in',
    routes: [
      GoRoute(
        path: '/sign_in',
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
          path: '/admin_home',
          builder: (context, state) {
            int pageIndex = state.extra is int ? state.extra as int : 0;
            return AdminHomeView(selectedIndex: pageIndex);
          }),
      GoRoute(
          path: '/ticket_details',
          builder: (context, state) {
            var ticket = state.extra as TicketModel;
            return TicketsDetailsView(ticket: ticket);
          }),
      GoRoute(
          path: '/dashboard_ticket_details',
          builder: (context, state) {
            var ticket = state.extra as RecentTicket;
            return DashboardTicketDetails(ticket: ticket);
          }),
      GoRoute(
          path: '/photo_view',
          builder: (context, state) {
            var image = state.extra as String;
            return PhotoViewer(image: image);
          }),
      GoRoute(
          path: '/edit_profile',
          builder: (context, state) {
            var userData = state.extra as UserModel;
            return EditProfileView(user: userData);
          }),
      GoRoute(
        path: '/create_record',
        builder: (context, state) => const CreateNewRecord(),
      ),
      GoRoute(
          path: '/create_section',
          builder: (context, state) {
            var id = state.extra as int;
            return CreateNewSection(
              serviceId: id,
            );
          }),
      GoRoute(
        path: '/section_view',
        builder: (context, state) {
          var id = state.extra as int;
          return SectionsView(
            serviceId: id,
          );
        },
      ),
      GoRoute(
          path: '/create_section',
          builder: (context, state) {
            var id = state.extra as int;
            return CreateNewSection(
              serviceId: id,
            );
          }),
      GoRoute(
        path: '/add_new_manager',
        builder: (context, state) => const AddNewManager(),
      )
    ],
  );
}
