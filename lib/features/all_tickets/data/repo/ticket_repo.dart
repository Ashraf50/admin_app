import 'package:admin_app/core/error/failure.dart';
import 'package:admin_app/features/all_tickets/data/model/ticket_model/ticket_model/ticket_model.dart';
import 'package:dartz/dartz.dart';

abstract class TicketRepo {
  Future<List<TicketModel>> fetchAllTickets({int page = 1});
  Future<Either<Failure, List<TicketModel>>> sortTicket({
    required String from,
    required String to,
  });
  Future<Either<Failure, List<TicketModel>>> searchTicket(
      {required String name});
}
