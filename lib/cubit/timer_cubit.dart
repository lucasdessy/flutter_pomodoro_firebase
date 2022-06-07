import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pomodoro_firebase/models/fire_timer.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  static const int breakTime = 1 * 60;
  static const int workTime = 2 * 60;
  Timer? _timer;
  Timer? _dbTimer;
  final _db = FirebaseFirestore.instance;

  // A little bad stuff, running out of time.
  final _auth = FirebaseAuth.instance;
  TimerCubit() : super(TimerState.initial()) {
    _setupFirstLoad();
  }
  // DB Stuff
  void _listenDBTimer(Timer t) {
    if (state.isActive) {
      _updateToDb();
    }
  }

  void _updateToDb() async {
    print('uploading to db...');
    final ref = _db.collection('timers').doc(_auth.currentUser!.uid);
    ref.set(FireTimer(
            isBreakTime: state.isBreakTime, currentTime: state.currentTime)
        .toMap());
  }

  Future<void> _setupFirstLoad() async {
    // Try to load from db;
    try {
      final ref = _db.collection('timers').doc(_auth.currentUser!.uid);
      final result = await ref.get();
      if (result.exists) {
        final fireTimer = FireTimer.fromMap(result.data()!);
        emit(
          state.copyWith(
            currentTime: fireTimer.currentTime,
            isBreakTime: fireTimer.isBreakTime,
          ),
        );
      }
    } catch (err) {
      print(err);
    } finally {
      _updateBreakOrWorkTime();
      _dbTimer = Timer.periodic(const Duration(seconds: 5), _listenDBTimer);
      emit(state.copyWith(isLoading: false));
    }
  }

  // Timer Stuff

  void start() {
    print('cancelling current timer...');
    _timer?.cancel();
    print('creating new timer...');
    _createNewTimer();
    print('emiting new state...');
    emit(state.copyWith(isActive: true));
    _updateToDb();
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(isActive: false));
    _updateToDb();
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    emit(state.resetted());
    _updateToDb();
  }

  void _createNewTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), _timerListener);
  }

  void _updateBreakOrWorkTime() {
    emit(state.copyWith(totalTime: state.isBreakTime ? breakTime : workTime));
  }

  void _timerListener(Timer t) {
    _updateBreakOrWorkTime();
    emit(state.copyWith(
      currentTime: state.currentTime + 1,
    ));
    if (state.isBreakTime) {
      if (state.currentTime > breakTime) {
        _switchTimes();
      }
    }
    if (!state.isBreakTime) {
      if (state.currentTime > workTime) {
        _switchTimes();
      }
    }
  }

  void _switchTimes() {
    emit(state.copyWith(isBreakTime: !state.isBreakTime, currentTime: 0));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;
    _dbTimer?.cancel();
    _dbTimer = null;
    return super.close();
  }
}
