import 'package:admin_app/core/widget/custom_toast.dart';
import 'package:admin_app/features/all_tickets/data/model/ticket_model/ticket_model/ticket_model.dart';
import 'package:admin_app/features/all_tickets/data/repo/ticket_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  TicketRepo ticketRepo;
  List<TicketModel> allTickets = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isFetching = false;

  TicketCubit(this.ticketRepo) : super(TicketInitial());

  Future<void> fetchTickets({bool loadMore = false}) async {
    if (isFetching || !hasMore) return;
    isFetching = true;
    if (!loadMore) {
      emit(FetchTicketLoading());
    }
    try {
      final fetchedTickets =
          await ticketRepo.fetchAllTickets(page: currentPage);
      if (fetchedTickets.isEmpty) {
        hasMore = false;
      } else {
        allTickets = [...allTickets, ...fetchedTickets];
        currentPage++;
      }
      emit(FetchTicketSuccess(tickets: List.from(allTickets)));
    } catch (e) {
      emit(FetchTicketFailure(errMessage: "Failed to load tickets"));
    }
    isFetching = false;
  }

  void loadMoreTickets() {
    fetchTickets(loadMore: true);
  }

  Future<void> fetchSortedTickets({
    required String from,
    required String to,
  }) async {
    emit(FetchTicketLoading());
    final result = await ticketRepo.sortTicket(from: from, to: to);
    result.fold(
      (failure) {
        CustomToast.show(
            message: failure.errMessage, backgroundColor: Colors.red);
        emit(FetchTicketSuccess(tickets: List.from(allTickets)));
      },
      (tickets) => emit(FetchTicketSuccess(tickets: tickets)),
    );
  }

  Future<void> searchTicket(String name) async {
    emit(FetchTicketLoading());
    var result = await ticketRepo.searchTicket(name: name);
    result.fold(
      (failure) {
        emit(FetchTicketFailure(errMessage: failure.errMessage));
      },
      (tickets) {
        emit(FetchTicketSuccess(tickets: tickets));
      },
    );
  }
}
