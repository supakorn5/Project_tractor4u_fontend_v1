import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/widget/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './CodeColorscustom.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // chang calendar to thailand local
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('th'),
      ],
      locale: const Locale('th'),
      //End chang calendar to thailand local

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(a, r, g, b)),
        useMaterial3: true,
      ),
      home: const splash_screen(),
    );
  }
}
