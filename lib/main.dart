import 'package:flutter/material.dart';
import 'Screens/FirstScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connectivity Handler',
      home: FirstScreen(),
    );
  }
}