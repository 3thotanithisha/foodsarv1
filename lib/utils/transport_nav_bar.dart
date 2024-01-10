import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/screen/transport/dummy.dart';

import 'package:foodsarv01/screen/transport/list_screen.dart';
import 'package:foodsarv01/screen/transport/transport_status.dart';

List<Widget> transportPages = [
  const TransportScreen(),
  const TransporterStatus(),
  const Navi(),
  Center(
    child: TextButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
      },
      child: const Text('Sign Out'),
    ),
  )
];

class TNavBar extends StatefulWidget {
  const TNavBar({Key? key}) : super(key: key);

  @override
  State<TNavBar> createState() => _TNavBarState();
}

class _TNavBarState extends State<TNavBar> {
  int _pageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigatonTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void onpageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: onpageChanged,
        controller: _pageController,
        children: transportPages,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _pageIndex,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_max_rounded),
              backgroundColor: _pageIndex == 0
                  ? const Color.fromARGB(255, 139, 145, 149)
                  : Colors.grey[500]),
          BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              backgroundColor:
                  _pageIndex == 1 ? Colors.blue : Colors.grey[500]),
          BottomNavigationBarItem(
              icon: const Icon(Icons.location_on_rounded),
              backgroundColor:
                  _pageIndex == 2 ? Colors.blue : Colors.grey[500]),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_2_rounded),
              backgroundColor:
                  _pageIndex == 3 ? Colors.blue : Colors.grey[500]),
        ],
        onTap: navigatonTapped,
      ),
    );
  }
}
