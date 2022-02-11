import 'package:flutter/material.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        'Charts',
        style: TextStyle(fontSize: 60, color: Colors.white),
      ),
    ),
  );
}
