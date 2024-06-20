import 'dart:convert';

class Pomodoro {
  String name;
  int period;
  int index;
  Pomodoro({
    required this.name,
    required this.period,
    required this.index,
  });

  Pomodoro copyWith({
    String? name,
    int? period,
    int? index,
  }) {
    return Pomodoro(
      name: name ?? this.name,
      period: period ?? this.period,
      index: index ?? this.index,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'period': period,
      'index': index,
    };
  }

  factory Pomodoro.fromMap(Map<String, dynamic> map) {
    return Pomodoro(
      name: map['name'] as String,
      period: map['period'] as int,
      index: map['index'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pomodoro.fromJson(String source) =>
      Pomodoro.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Pomodoro(name: $name, period: $period, index: $index)';

  @override
  bool operator ==(covariant Pomodoro other) {
    if (identical(this, other)) return true;

    return other.name == name && other.period == period && other.index == index;
  }

  @override
  int get hashCode => name.hashCode ^ period.hashCode ^ index.hashCode;
}
