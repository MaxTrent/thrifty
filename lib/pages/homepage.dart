import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thrifty/pages/pages.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const DashboardPage(),
    const FinancesPage(),
    const UserPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[0],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
              icon: Icon(CupertinoIcons.home)),
          BottomNavigationBarItem(
              label: 'Transactions',
              icon: Icon(CupertinoIcons.creditcard)),
          BottomNavigationBarItem(
              label: 'User',
              icon: Icon(CupertinoIcons.profile_circled)),
        ],
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        onTap: (index){
          _selectedIndex = index;
          setState(() {

          });
        },

      ),

    );
  }
}
