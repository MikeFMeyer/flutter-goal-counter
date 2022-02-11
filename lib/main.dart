import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:goalcounter/pages/charts_page.dart';
import 'package:goalcounter/pages/history_page.dart';
import 'package:goalcounter/pages/count_page.dart';
import 'package:goalcounter/api/goal_tracker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await GoalTrackerApi.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade600,
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      home: const MainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 1;

  final List<Widget> screens = [
    HistoryPage(
      key: PageStorageKey("History Page"),
    ),
    CountPage(
      key: PageStorageKey("Count Page"),
    ),
    ChartsPage(
      key: PageStorageKey("Charts Page"),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.history_outlined, size: 30),
      Icon(Icons.add_outlined, size: 30),
      Icon(Icons.analytics_outlined, size: 30),
    ];

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.blue.shade600,
          // appBar: AppBar(
          //   actions: [
          //     IconButton(
          //       onPressed: () {},
          //       icon: Icon(Icons.logout_outlined)
          //     ),
          //   ],
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          // ),
          body: PageStorage(
            child: screens[index],
            bucket: bucket,
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: Colors.white,
            buttonBackgroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            height: 60,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 400),
            index: index,
            items: items,
            onTap: (index) => setState(() => this.index = index),
          ),
        ),
      ),
    );
  }
}
