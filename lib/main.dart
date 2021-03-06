import 'package:flutter/material.dart';
import 'swipe_feed_page.dart';
import 'backend_calls.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Decider',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SwipeFeedPage(),
    );
  }
}
