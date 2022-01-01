import 'package:flutter/material.dart';
import 'package:shoru_mobile/ui/history.dart';
import 'package:shoru_mobile/ui/home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const HistoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ショル - Shoru",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "A Free Open Source URL Shortener",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFF1e1e1e),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "History",
                backgroundColor: Colors.white)
          ],
          currentIndex: _selectedIndex,
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
        ),
      ),
    );
  }
}
