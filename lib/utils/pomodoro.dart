// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Pomodoro {
  String name;
  int period;
  Pomodoro({
    required this.name,
    required this.period,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'period': period,
    };
  }

  factory Pomodoro.fromMap(Map<String, dynamic> map) {
    return Pomodoro(
      name: map['name'] as String,
      period: map['period'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pomodoro.fromJson(String source) =>
      Pomodoro.fromMap(json.decode(source) as Map<String, dynamic>);
}
