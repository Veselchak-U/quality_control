import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:quality_control/di/di_container.dart';
import 'package:universal_platform/universal_platform.dart';

void main() {
  Fimber.plantTree(DebugTree()); // init logger
  DiContainer.initialize(); // init dependency injector
  _clearWebCache();
  runApp(MyApp());
}

void _clearWebCache() {
  if (UniversalPlatform.isWeb) {
//    var appDir = getTemporaryDirectory();
//    WebV
//    print(appDir);
  }
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
        textTheme: TextTheme(
//            headline2: TextStyle(fontFamily: 'Roboto', fontSize: 18),
            bodyText2: TextStyle(/*fontFamily: 'Roboto', */fontSize: 16)),
      ),
      home: DiContainer.getStartupScreen(),
    );
  }
}
