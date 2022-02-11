import 'dart:ffi';
import 'package:intl/intl.dart';

import 'package:goalcounter/api/goal_tracker.dart';
import 'package:goalcounter/models/goals.dart';
import 'package:flutter/material.dart';

class CountPage extends StatefulWidget {
  const CountPage({Key? key}) : super(key: key);

  @override
  _CountPageState createState() => _CountPageState();
}

class _CountPageState extends State<CountPage> {
  num goals = 0;
  num shots = 0;
  num percentage = 0;
  String history = '';

  @override
  void initState() {
    super.initState();
    goals = PageStorage.of(context)?.readState(
      context,
      identifier: ValueKey("goals_value")
    ) ?? 0;
    shots = PageStorage.of(context)?.readState(
      context,
      identifier: ValueKey("shots_value")
    ) ?? 0;
    percentage = PageStorage.of(context)?.readState(
      context,
      identifier: ValueKey("percentage_value")
    ) ?? 0;
    history = PageStorage.of(context)?.readState(
      context,
      identifier: ValueKey("history_value")
    ) ?? '';
  }

  void goal() {
    setState(() {
      goals++;
      history = history + '+';
    });

    shot();
  }

  void shot() {
    if (shots + 1 != history.length) {
      setState(() {
        history = history + '-';
      });
    }
    setState(() {
      shots++;
    });

    calculatePercentage();
  }

  void calculatePercentage() {
    num calc = goals / shots;
    if (calc.isNaN) {
      calc = 0;
    }

    setState(() {
      percentage = num.parse((calc * 100).toStringAsFixed(2));
    });

    PageStorage.of(context)?.writeState(
      context, 
      goals,
      identifier: ValueKey("goals_value"),
    );
    PageStorage.of(context)?.writeState(
      context, 
      shots,
      identifier: ValueKey("shots_value"),
    );
    PageStorage.of(context)?.writeState(
      context, 
      percentage,
      identifier: ValueKey("percentage_value"),
    );
    PageStorage.of(context)?.writeState(
      context, 
      history,
      identifier: ValueKey("history_value"),
    );
  }

  void reset() {
    setState(() {
      goals = 0;
      shots = 0;
      percentage = 0;
      history = '';
    });
  }

  void save() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    final results = {
      GoalFields.date: formattedDate,
      GoalFields.shots: shots,
      GoalFields.goals: goals,
      GoalFields.percentage: percentage,
    };
    await GoalTrackerApi.insert([results]);

    reset();
  }

  void undo() async {
    if (history.length > 0) {
      final char = history.characters.takeLast(1).toString();
      if (char == '+') {
        setState(() {
          goals--;
        });
      }
      setState(() {
        shots--;
        history = history.substring(0, history.length - 1);
      });
      calculatePercentage();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              '$percentage%',
              style: TextStyle(
                color: Colors.white,
                fontSize: 70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Goals: $goals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Shots: $shots',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(  
                color: Colors.white,
                padding: EdgeInsets.all(20),
                onPressed: goal,
                child: Icon(Icons.add_outlined, size: 70.0, color: Colors.black87),
                shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
              ),
              MaterialButton(  
                color: Colors.white,
                padding: EdgeInsets.all(20),
                onPressed: shot,
                child: Icon(Icons.remove, size: 70.0, color: Colors.black87),
                shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    primary: Colors.white,
                  ),
                  onPressed: save,
                  child: const Text('Save'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10.0, left: 10.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    primary: Colors.white,
                  ),
                  onPressed: undo,
                  child: const Text('Undo'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    primary: Colors.white,
                  ),
                  onPressed: reset,
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
