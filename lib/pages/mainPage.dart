import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';

import '../widgets/addTenantPage/add_tenant_page.dart';
import 'tenant_list_page.dart';
import 'user_profile_page.dart';

class MainPage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const MainPage({super.key, required this.token, required this.user});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      _navigateToAddTenantPage();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateToAddTenantPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTenantPage(
          onTenantAdded: (tenant) {
          },
          token: widget.token,
          tenant: null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _selectedIndex == 0
            ? TenantListPage(token: widget.token, user: widget.user)
            : UserProfilePage(user: widget.user),
        bottomNavigationBar: CircleNavBar(
          activeIndex: _selectedIndex,
          onTap: _onItemTapped,
          activeIcons:const  [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.add, color: Colors.white, size: 32),
            Icon(Icons.person, color: Colors.white),
          ],
          inactiveIcons:const  [
            Icon(Icons.home, color: Colors.grey),
            Icon(Icons.add, color: Colors.grey, size: 32),
            Icon(Icons.person, color: Colors.grey),
          ],
          color: Colors.teal,
          circleWidth: 60,
          height: 75,
          circleColor: Colors.teal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';

import 'tenant_list_page.dart';
import 'user_profile_page.dart';


class MainPage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const MainPage({Key? key, required this.token, required this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _selectedIndex == 0
            ? TenantListPage(token: widget.token , user: widget.user)
            : UserProfilePage(user: widget.user),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Kiracılar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
*/