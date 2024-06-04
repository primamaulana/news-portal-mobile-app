import 'package:favorite_meals/screens/bantuan.dart';
import 'package:favorite_meals/screens/dashboard.dart';
import 'package:favorite_meals/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  late SharedPreferences logindata;
  String username = "";

  @override
  void initState() {
    super.initState();
    initial();
  }

  Future initial()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username')!;
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget activePage = const MyHomePage();
    var activePageTitle = 'Beranda';

    if (_selectedPageIndex == 1) {
      activePage = ProfilePage();
      activePageTitle = 'Profile';
    }
    if (_selectedPageIndex == 2) {
      activePage = Setting();
      activePageTitle = 'Settings';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        automaticallyImplyLeading: false,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
