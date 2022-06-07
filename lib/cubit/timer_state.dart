part of 'timer_cubit.dart';

class TimerState {
  int currentTime;
  int totalTime;
  bool isActive;
  bool isBreakTime;
  bool isLoading;
  TimerState(this.currentTime, this.totalTime, this.isActive, this.isBreakTime,
      this.isLoading);
  TimerState resetted() => TimerState(0, 1, false, false, isLoading);
  factory TimerState.initial() => TimerState(0, 1, false, false, true);

  TimerState copyWith({
    int? currentTime,
    int? totalTime,
    bool? isActive,
    bool? isBreakTime,
    bool? isLoading,
  }) {
    return TimerState(
      currentTime ?? this.currentTime,
      totalTime ?? this.totalTime,
      isActive ?? this.isActive,
      isBreakTime ?? this.isBreakTime,
      isLoading ?? this.isLoading,
    );
  }
}
