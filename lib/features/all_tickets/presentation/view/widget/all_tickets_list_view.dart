import 'package:admin_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../add_manager/presentation/view/widget/all_manager_list_view.dart';
import '../../view_model/cubit/ticket_cubit.dart';
import 'ticket_card.dart';

class AllTicketsListView extends StatefulWidget {
  const AllTicketsListView({super.key});

  @override
  State<AllTicketsListView> createState() => _AllTicketsListViewState();
}

class _AllTicketsListViewState extends State<AllTicketsListView> {
  late ScrollController _scrollController;
  late TicketCubit ticketCubit;

  @override
  void initState() {
    super.initState();
    ticketCubit = context.read<TicketCubit>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ticketCubit.loadMoreTickets();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.95);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(13),
        ),
        child: BlocBuilder<TicketCubit, TicketState>(
          builder: (context, state) {
            if (state is FetchTicketSuccess) {
              if (state.tickets.isEmpty) {
                return Center(
                  child: Text(S.of(context).no_tickets),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.tickets.length,
                itemBuilder: (context, index) {
                  final tickets = state.tickets[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 500 + (index * 100)),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: InkWell(
                      onTap: () {
                        context.push(
                          "/ticket_details",
                          extra: tickets,
                        );
                      },
                      child: TicketCard(
                        ticketName: tickets.title ?? '',
                        userName: tickets.user?.name ?? '',
                        status: tickets.status!,
                      ),
                    ),
                  );
                },
              );
            } else if (state is FetchTicketLoading) {
              return buildShimmerLoading();
            } else if (state is FetchTicketFailure) {
              return Center(child: Text(state.errMessage));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
