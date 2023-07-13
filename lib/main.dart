import 'package:flutter/material.dart';
import 'package:thrifty/screens/sign_in_screen.dart';
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
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SignInScreen(),
        });
  }
}
