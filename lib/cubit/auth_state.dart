part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loggedIn(User user) = _LoggedIn;
  const factory AuthState.loggedOut() = _LoggedOut;
}
