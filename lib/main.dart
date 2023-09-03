// @dart= 3.0
import 'package:flutter/material.dart';
import 'package:powerliftingapp/UI/landingpage.dart';
import 'package:powerliftingapp/UI/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Powerlifting App',
      theme: ThemeData(
        fontFamily: 'FiraSansCondensed',
        primarySwatch: Colors.grey,
        dividerTheme: DividerThemeData(
          color: Colors.brown,
        )
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => const SplashScreen(),
        '/landing' : (context) => const LandingPage(),
      },
      // home: SplashScreen(),
    );
  }
}