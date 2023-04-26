import 'package:client_photogenie/screens/bottombar/gallery_screen.dart';
import 'package:client_photogenie/screens/camera/camera_fiter.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/camera/camera_deepar.dart';
import '../screens/profile_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

late final SharedPreferences prefs;

class _BottomBarState extends State<BottomBar> {
  int _page = 0;

  final List<Widget> _pages = <Widget>[
    const GalleryPage(),
    const Camera(),
    const CameraFilter(),
    const ProfilePage(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_page],
      bottomNavigationBar: _page != 1
          ? Container(
              color: const Color.fromARGB(255, 3, 1, 15),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: GNav(
                  backgroundColor: const Color.fromARGB(255, 3, 1, 15),
                  color: const Color(0x80fffffe),
                  tabBackgroundColor: const Color(0xffAE2A58),
                  gap: 8,
                  padding: const EdgeInsets.all(12),
                  activeColor: const Color(0xfffffffe),
                  onTabChange: (page) {
                    updatePage(page);
                  },
                  tabs: const [
                    GButton(
                      icon: Icons.photo_library,
                      text: 'Gallery',
                    ),
                    GButton(
                      icon: Icons.camera_alt,
                      text: 'Camera',
                    ),
                    GButton(
                      icon: Icons.photo_filter,
                      text: 'Retouch',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
