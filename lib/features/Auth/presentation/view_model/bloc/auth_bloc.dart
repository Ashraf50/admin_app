import 'package:admin_app/core/helper/custom_refresh_token.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repo/auth_repo.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;

  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoginLoading());
        try {
          final result = await authRepo.login(
            email: event.email,
            password: event.password,
          );
          if (result['type'] == 'error') {
            await authRepo.clearTokens();
            emit(LoginFailure(errMessage: result['message']));
          } else if (result['type'] == 'success') {
            final user = result['data']['user'];
            final token = result['data']['token'];
            final refreshToken = result['data']['refresh_token'];
            final userId = user['id'].toString();
            await authRepo.saveTokens(token, refreshToken, userId);
            emit(LoginSuccess(successMessage: result['message'], token: token));
          }
        } catch (e) {
          if (e is RefreshTokenMissingException) {
            await authRepo.clearTokens();
            emit(SessionExpired());
          } else {
            await authRepo.clearTokens();
            emit(LoginFailure(errMessage: _parseError(e)));
          }
        }
      }
    });
  }
  String _parseError(Object e) {
    if (e is RefreshTokenMissingException) {
      return 'Session expired. Please log in again.';
    } else if (e is Exception) {
      return e.toString().replaceAll('Exception:', '').trim();
    }
    return 'Something went wrong';
  }
}
