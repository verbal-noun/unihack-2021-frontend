import 'package:flutter/material.dart';
import 'swipe_feed_page.dart';
import 'firebase_functions.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _init = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Container();
          if (snapshot.connectionState == ConnectionState.done) {
            // Test
            Backend.fetchNearby([-37.80203864952784, 144.9590979411664],
                ['restaurant', 'university']);
            return MaterialApp(
                title: 'Activity Decider',
                theme: ThemeData(primarySwatch: Colors.blue),
                home: SwipeFeedPage());
          }
          return Container(); // TODO: Loading screen
        });
  }
}
