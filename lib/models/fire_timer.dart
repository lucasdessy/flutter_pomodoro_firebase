// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FireTimer {
  bool isBreakTime;
  int currentTime;
  FireTimer({
    required this.isBreakTime,
    required this.currentTime,
  });

  FireTimer copyWith({
    bool? isBreakTime,
    int? currentTime,
  }) {
    return FireTimer(
      isBreakTime: isBreakTime ?? this.isBreakTime,
      currentTime: currentTime ?? this.currentTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isBreakTime': isBreakTime,
      'currentTime': currentTime,
    };
  }

  factory FireTimer.fromMap(Map<String, dynamic> map) {
    return FireTimer(
      isBreakTime: map['isBreakTime'] as bool,
      currentTime: map['currentTime'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory FireTimer.fromJson(String source) =>
      FireTimer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FireTimer(isBreakTime: $isBreakTime, currentTime: $currentTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FireTimer &&
        other.isBreakTime == isBreakTime &&
        other.currentTime == currentTime;
  }

  @override
  int get hashCode => isBreakTime.hashCode ^ currentTime.hashCode;
}
