import 'dart:ffi';
import 'package:intl/intl.dart';

import 'package:goalcounter/api/goal_tracker.dart';
import 'package:goalcounter/models/goals.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Goal> goals = [];

  @override
  void initState() {
    super.initState();

    getGoals();
  }

  Future getGoals() async {
    final goals = await GoalTrackerApi.getAll();
    var epoch = new DateTime(1899, 12, 30);

    goals.sort((b, a) => int.parse(a.date).compareTo(int.parse(b.date)));

    for( int i = 0 ; i < goals.length; i++ ) {
      var currentDate = epoch.add(new Duration(days: int.parse(goals[i].date)));
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      goals[i].date = formatter.format(currentDate);
    }

    setState(() {
      this.goals = goals;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded (
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (BuildContext ctx, int index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                goals[index].date,
                                style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Shots: ' + goals[index].shots.toStringAsFixed(0),
                                style: TextStyle(fontSize: 24),
                              ),
                              Text(
                                'Goals: ' +  goals[index].goals.toStringAsFixed(0),
                                style: TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              goals[index].percentage.toStringAsFixed(2) + '%',
                              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )
    ),
  );
}


// Center(
//   child: Text(goals[index].shots.toStringAsFixed(0)),
// ),
// Center(
//   child: Text(goals[index].goals.toStringAsFixed(0)),
// ),
// Center(
//   child: Text(goals[index].percentage.toStringAsFixed(2) + '%'),
// ),
// Center(
//   child: Text(goals[index].date),
// ),
