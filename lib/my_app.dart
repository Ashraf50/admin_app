import 'package:admin_app/core/helper/api_helper.dart';
import 'package:admin_app/core/routing/app_router.dart';
import 'package:admin_app/features/Auth/data/repo/auth_repo_impl.dart';
import 'package:admin_app/features/Auth/presentation/view_model/bloc/auth_bloc.dart';
import 'package:admin_app/features/add_manager/data/repo/manager_repo_impl.dart';
import 'package:admin_app/features/add_manager/presentation/view_model/cubit/add_manager_cubit.dart';
import 'package:admin_app/features/add_record/data/repo/record/record_repo_impl.dart';
import 'package:admin_app/features/add_record/data/repo/section/section_repo_impl.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_record_cubit.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/all_sections_cubit.dart';
import 'package:admin_app/features/add_record/presentation/view_model/cubit/selectable_record_cubit.dart';
import 'package:admin_app/features/all_tickets/data/repo/ticket_repo_impl.dart';
import 'package:admin_app/features/all_tickets/presentation/view_model/cubit/ticket_cubit.dart';
import 'package:admin_app/features/dashboard/data/repo/dashboard_repo_impl.dart';
import 'package:admin_app/features/dashboard/presentation/view_model/cubit/statistics_cubit.dart';
import 'package:admin_app/features/home/data/repo/user_repo_impl.dart';
import 'package:admin_app/features/home/presentation/view_model/cubit/user_data_cubit.dart';
import 'package:admin_app/features/settings/presentation/view_model/language_bloc/language_bloc.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'features/add_manager/presentation/view_model/cubit/create_manager_cubit.dart';

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final String token;
  const MyApp({
    super.key,
    required this.appRouter,
    required this.token,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthRepoImpl(ApiHelper())),
        ),
        BlocProvider(
          create: (context) =>
              UserDataCubit(UserRepoImpl(ApiHelper()))..fetchUserData(token),
        ),
        BlocProvider(
          create: (context) =>
              AllRecordCubit(RecordRepoImpl(ApiHelper()))..fetchAllRecord(),
        ),
        BlocProvider(
          create: (context) =>
              SelectableRecordCubit(RecordRepoImpl(ApiHelper()))
                ..fetchSelectableRecords(onlyUnique: 1),
        ),
        BlocProvider(
          create: (context) =>
              AddManagerCubit(ManagerRepoImpl(ApiHelper()))..fetchManager(),
        ),
        BlocProvider(
          create: (context) =>
              TicketCubit(TicketRepoImpl(ApiHelper()))..fetchTickets(),
        ),
        BlocProvider(
          create: (context) => StatisticsCubit(DashboardRepoImpl(ApiHelper()))
            ..fetchStatistics(),
        ),
        BlocProvider(
          create: (context) => CreateManagerCubit(ManagerRepoImpl(ApiHelper())),
        ),
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider(
          create: (context) => AllSectionsCubit(SectionRepoImpl(ApiHelper())),
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return MaterialApp.router(
              builder: FlutterSmartDialog.init(),
              theme: ThemeData(scaffoldBackgroundColor: Colors.white),
              routerConfig: appRouter.router,
              debugShowCheckedModeBanner: false,
              locale:
                  state is AppChangeLanguage ? Locale(state.langCode) : null,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              localeListResolutionCallback: (deviceLocales, supportedLocales) {
                if (deviceLocales != null) {
                  for (var deviceLocale in deviceLocales) {
                    for (var supportedLocale in supportedLocales) {
                      if (deviceLocale.languageCode ==
                          supportedLocale.languageCode) {
                        return deviceLocale;
                      }
                    }
                  }
                }
                return supportedLocales.first;
              },
            );
          },
        ),
      ),
    );
  }
}
