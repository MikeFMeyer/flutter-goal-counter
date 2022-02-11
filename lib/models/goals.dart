import 'dart:ffi';

class GoalFields {
  static final String date = 'date';
  static final String shots = 'shots';
  static final String goals = 'goals';
  static final String percentage = 'percentage';

  static List<String> getFields() => [date, shots, goals, percentage];
}

class Goal {
  String date;
  final num shots;
  final num goals;
  final num percentage;

  Goal({
    required this.date,
    required this.shots,
    required this.goals,
    required this.percentage,
  });

  static Goal fromJson(Map<String, dynamic> json) => Goal(
    date: json[GoalFields.date],
    shots: double.parse(json[GoalFields.shots]),
    goals: double.parse(json[GoalFields.goals]),
    percentage: double.parse(json[GoalFields.percentage]),
  );
}
