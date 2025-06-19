import 'package:admin_app/core/constant/app_colors.dart';
import 'package:admin_app/core/constant/app_images.dart';
import 'package:admin_app/core/constant/app_styles.dart';
import 'package:admin_app/core/widget/custom_scaffold.dart';
import 'package:admin_app/features/dashboard/presentation/view/widget/graph.dart';
import 'package:admin_app/features/dashboard/presentation/view_model/cubit/statistics_cubit.dart';
import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../all_tickets/presentation/view/widget/ticket_card.dart';
import 'custom_card.dart';
import 'custom_card_shimmer.dart';

class DashboardViewBody extends StatelessWidget {
  const DashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: constraints.maxWidth < 600 ? 2 : 4,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 0.85,
                    children: List.generate(
                      5,
                      (index) => const CustomCardShimmer(),
                    ),
                  );
                },
              );
            } else if (state is StatisticsError) {
              return Center(child: Text(state.message));
            } else if (state is StatisticsLoaded) {
              final totalTickets = state.statistics.data!.allTickets!;
              final closedTickets = state.statistics.data!.closedTickets!;
              final inProgressTickets =
                  state.statistics.data!.inProcessingTickets!;
              final openTickets = state.statistics.data!.openedTickets!;
              final closedPercentage = totalTickets > 0
                  ? ((closedTickets / totalTickets) * 100).round()
                  : 0;
              final inProgressPercentage = totalTickets > 0
                  ? ((inProgressTickets / totalTickets) * 100).round()
                  : 0;
              final openPercentage = totalTickets > 0
                  ? ((openTickets / totalTickets) * 100).round()
                  : 0;
              var managerCount = state.statistics.data!.managersCount!;
              return Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: constraints.maxWidth < 600 ? 2 : 4,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.85,
                        children: [
                          CustomCard(
                            title: S.of(context).allTickets,
                            value: totalTickets.toString(),
                            percentage: "100%",
                            iconAsset: Assets.ticket,
                            circleColor: AppColors.darkBlue,
                            progress: 1.0,
                          ),
                          CustomCard(
                            title: S.of(context).closedTickets,
                            value: closedTickets.toString(),
                            percentage: "$closedPercentage%",
                            iconAsset: Assets.ticket,
                            circleColor: AppColors.darkBlue,
                            progress: totalTickets > 0
                                ? closedTickets / totalTickets
                                : 0.0,
                          ),
                          CustomCard(
                            title: S.of(context).inProgressTickets,
                            value: inProgressTickets.toString(),
                            percentage: "$inProgressPercentage%",
                            iconAsset: Assets.ticket,
                            circleColor: AppColors.darkBlue,
                            progress: totalTickets > 0
                                ? inProgressTickets / totalTickets
                                : 0.0,
                          ),
                          CustomCard(
                            title: S.of(context).openTickets,
                            value: openTickets.toString(),
                            percentage: "$openPercentage%",
                            iconAsset: Assets.ticket,
                            circleColor: AppColors.darkBlue,
                            progress: totalTickets > 0
                                ? openTickets / totalTickets
                                : 0.0,
                          ),
                          CustomCard(
                            title: S.of(context).manager,
                            value: managerCount.toString(),
                            percentage: "100%",
                            iconAsset: Assets.users,
                            circleColor: AppColors.darkBlue,
                            progress: 1.0,
                          ),
                        ],
                      );
                    },
                  ),
                  ChartsDashboard(
                    annualTickets: state.statistics.data!.annualTicketsAverage!,
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).recentTickets,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (state.statistics.data!.recentTickets == null ||
                            state.statistics.data!.recentTickets!.isEmpty)
                          Center(
                            child: Text(
                              S.of(context).no_tickets,
                              style: AppStyles.textStyle16,
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                state.statistics.data!.recentTickets!.length,
                            itemBuilder: (context, index) {
                              final tickets =
                                  state.statistics.data!.recentTickets![index];
                              return InkWell(
                                onTap: () {
                                  context.push(
                                    "/dashboard_ticket_details",
                                    extra: tickets,
                                  );
                                },
                                child: TicketCard(
                                  ticketName: tickets.title ?? '',
                                  userName: tickets.user?.name ?? '',
                                  status: tickets.status!,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
