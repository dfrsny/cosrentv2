import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/login_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit(this.loginUseCase) : super(const AuthState());

  // Menyimpan perubahan email
  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  // Menyimpan perubahan password
  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  // Validasi dan proses login
  Future<void> login() async {
    final email = state.email.trim();
    final password = state.password;

    if (email.isEmpty || password.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Email dan password wajib diisi',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));

    try {
      final user = await loginUseCase(email: email, password: password);

      emit(state.copyWith(status: AuthStatus.success, user: user));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
