// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TimerModel {
  String name;
  int minutes;
  TimerModel({
    required this.name,
    required this.minutes,
  });

  TimerModel copyWith({
    String? name,
    int? minutes,
  }) {
    return TimerModel(
      name: name ?? this.name,
      minutes: minutes ?? this.minutes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'minutes': minutes,
    };
  }

  factory TimerModel.fromMap(Map<String, dynamic> map) {
    return TimerModel(
      name: map['name'] as String,
      minutes: map['minutes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimerModel.fromJson(String source) => TimerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TimerModel(name: $name, minutes: $minutes)';

  @override
  bool operator ==(covariant TimerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.minutes == minutes;
  }

  @override
  int get hashCode => name.hashCode ^ minutes.hashCode;
}
