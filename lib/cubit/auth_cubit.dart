import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_cubit.freezed.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription? _authSub;
  AuthCubit() : super(const AuthState.initial()) {
    _authSub = _auth.authStateChanges().listen(_userEventListener);
  }

  _userEventListener(User? user) {
    if (user != null) {
      emit(AuthState.loggedIn(user));
      print('user is authenticated');
    } else {
      emit(const AuthState.loggedOut());
      print('user is not authenticated');
    }
  }

  @override
  Future<void> close() {
    print('closing authcubit...');
    _authSub?.cancel();
    return super.close();
  }

  Future<void> login() async {
    print('trying to login...');
    await _auth.signInAnonymously();
  }

  Future<void> logout() async {
    print('trying to logout...');
    await _auth.signOut();
  }
}
