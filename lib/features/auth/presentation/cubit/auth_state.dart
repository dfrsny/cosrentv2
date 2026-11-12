import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus { initial, loading, success, error }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default('') String email,
    @Default('') String password,
    @Default(AuthStatus.initial) AuthStatus status,
    User? user,
    String? errorMessage,
  }) = _AuthState;
}
