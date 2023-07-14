import 'package:flutter/material.dart';
import 'package:thrifty/pages/pages.dart';
import 'package:thrifty/screens/screens.dart';
import 'theme.dart';

void main() {
  runApp(MyApp(appTheme: AppTheme(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appTheme});

  final AppTheme appTheme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: appTheme.light,
        darkTheme: appTheme.dark,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SignInScreen(),
          '/homepage': (context) => const HomePage()
        });
  }
}
