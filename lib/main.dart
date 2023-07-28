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

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.appTheme});
  final AppTheme appTheme;

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
ThemeMode _themeMode = ThemeMode.system;
  bool isDark = false;

  @override
  void initState() {
    super.initState();
  }

  void changeTheme(ThemeMode themeMode){
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: widget.appTheme.light,
        darkTheme: widget.appTheme.dark,
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SignInScreen(),
          '/dashboard': (context) => const DashboardPage(),
          '/signup': (context) => const SignUpScreen(),
          '/homepage': (context) => const HomePage(),
          '/userpage': (context) => const UserPage(),
        });
  }
}
