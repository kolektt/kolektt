import 'package:flutter/material.dart';
import 'views/content_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kolektt',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ContentView(),
      routes: {
        '/search': (context) => Scaffold(body: Center(child: Text('Search'))),
        '/notifications': (context) => Scaffold(body: Center(child: Text('Notifications'))),
        '/magazine_detail': (context) => Scaffold(body: Center(child: Text('Magazine Detail'))),
      },
    );
  }
}