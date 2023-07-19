import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:thrifty/pages/pages.dart';
import 'package:thrifty/screens/screens.dart';
import 'firebase_options.dart';
import 'theme.dart';

Future<void> main() async{
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MyApp(appTheme: AppTheme(),));
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
          '/signup': (context) => const SignUpScreen(),
          '/homepage': (context) => const HomePage(),
          '/userpage': (context) => const UserPage(),
        });
  }
}
