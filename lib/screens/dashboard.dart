import 'dart:async';
import 'package:favorite_meals/screens/newspage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

enum DashboardItemType {
  Site1,
  Site2,
  Site3,
  Site4,
  Site5,
  Site6,
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState(){
    return _MyHomePageState();
  }
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  SharedPreferences? logindata;
  String username = "";

  String selectedTimeZone = 'WIB';
  late Timer timer;
  DateTime currentTime = DateTime.now();

  Future initial()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username')!;
    });
  }

  @override
  void initState() {
    super.initState();
    initial();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      currentTime = DateTime.now();
    });
  }

  void _showTimeZonePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: 250,
            child: Column(
              children: [
                ListTile(
                  title: Text('WIB'),
                  onTap: () {
                    setState(() {
                      selectedTimeZone = 'WIB';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('WITA'),
                  onTap: () {
                    setState(() {
                      selectedTimeZone = 'WITA';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('WIT'),
                  onTap: () {
                    setState(() {
                      selectedTimeZone = 'WIT';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('London'),
                  onTap: () {
                    setState(() {
                      selectedTimeZone = 'London';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatCurrentTime(String timeZone) {
    DateTime now = currentTime;
    switch (timeZone) {
      case 'WITA':
        now = now.add(Duration(hours: 1));
        break;
      case 'WIT':
        now = now.add(Duration(hours: 2));
        break;
      case 'London':
        now = now.subtract(Duration(hours: 6));
        break;
    }
    return DateFormat('HH:mm').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  _formatCurrentTime(selectedTimeZone),
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _showTimeZonePicker(context);
                  },
                  child: Text(
                    selectedTimeZone,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                      'Selamat Datang, ' + username,
                      style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                      'Portal berita terpercaya dan teraktual ada disini!',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white54, fontSize: 20),
                      textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200)
                  )
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard('Berita Nasional', CupertinoIcons.news, Colors.blue, DashboardItemType.Site1),
                  itemDashboard('Berita Ekonomi', CupertinoIcons.chart_bar_alt_fill, Colors.deepOrange, DashboardItemType.Site2),
                  itemDashboard('Berita Olahraga', CupertinoIcons.sportscourt, Colors.deepPurple, DashboardItemType.Site3),
                  itemDashboard('Berita Teknologi', CupertinoIcons.keyboard_chevron_compact_down, Colors.brown, DashboardItemType.Site4),
                  itemDashboard('Berita Hiburan', CupertinoIcons.smiley, Colors.red, DashboardItemType.Site5),
                  itemDashboard('Berita Gaya Hidup', CupertinoIcons.airplane, Colors.amber, DashboardItemType.Site6),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background, DashboardItemType type) => GestureDetector(
    onTap: () {
      // Navigasi ke halaman yang sesuai berdasarkan jenis item dashboard
      switch (type) {
        case DashboardItemType.Site1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsPage(Category: 'nasional',)),
          );
          break;
        case DashboardItemType.Site2:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsPage(Category: 'ekonomi',)),
          );
          break;
        case DashboardItemType.Site3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsPage(Category: 'olahraga',)),
          );
          break;
        case DashboardItemType.Site4:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsPage(Category: 'teknologi',)),
          );
          break;
        case DashboardItemType.Site5:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsPage(Category: 'hiburan',)),
          );
          break;
        case DashboardItemType.Site6:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewsPage(Category: 'gaya-hidup',)),
          );
          break;
        default:
        // Do nothing
          break;
      }
    },
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)
          ),
          const SizedBox(height: 8),
          Text(title.toUpperCase(), style: Theme.of(context).textTheme.subtitle1)
        ],
      ),
    ),
  );
}
