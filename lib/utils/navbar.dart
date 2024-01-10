import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodsarv01/screen/donor/create_donation.dart';
import 'package:foodsarv01/screen/donor/profile_screen.dart';
import 'package:foodsarv01/screen/donor/view_donations.dart';
import 'package:foodsarv01/screen/reciever/my_requests.dart';

class NavBar extends StatefulWidget {
  final bool isDonate;

  const NavBar({Key? key, required this.isDonate}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _pageIndex = 0;
  final PageController _pageController = PageController();

  late List<Widget> pagesDonate;

  late List<Widget> pagesRecieve;

  @override
  void initState() {
    super.initState();
    pagesDonate = [
      const ViewDonation(
        isMine: true,
      ),
      CreateDonationScreen(navigatonTapped: navigatonTapped),
      const ProfileScreen()
    ];
    pagesRecieve = [
      const ViewDonation(
        isMine: false,
      ),
      const MyRequests(),
      const ProfileScreen()
    ];
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
        children: widget.isDonate ? pagesDonate : pagesRecieve,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _pageIndex,
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.list_alt_rounded),
              backgroundColor:
                  _pageIndex == 1 ? Colors.blue : Colors.grey[500]),
          BottomNavigationBarItem(
              icon: const Icon(Icons.add_circle_outline_rounded),
              backgroundColor: _pageIndex == 0
                  ? const Color.fromARGB(255, 139, 145, 149)
                  : Colors.grey[500]),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_2_rounded),
              backgroundColor:
                  _pageIndex == 2 ? Colors.blue : Colors.grey[500]),
        ],
        onTap: navigatonTapped,
      ),
    );
  }
}
