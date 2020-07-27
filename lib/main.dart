import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/di/di_container.dart';

void main() {
  Fimber.plantTree(DebugTree()); // init logger
  DiContainer.initialize(); // init Dependency Injector
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Контроль качества',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme:
            TextTheme(bodyText2: TextStyle(fontFamily: 'Roboto', fontSize: 18)),
      ),
      home: DiContainer.getStartupScreen(),
    );
  }
}
