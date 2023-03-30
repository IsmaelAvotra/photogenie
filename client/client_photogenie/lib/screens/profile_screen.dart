import 'package:client_photogenie/resources/auth_methods.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Authmethods authmethods = Authmethods();
    return Scaffold(
        backgroundColor: Color(0xff181345),
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 30),
                ElevatedButton.icon(
                    onPressed: authmethods.logoutUser(context),
                    icon: Icon(Icons.logout),
                    label: Text("Logout")),
              ],
            ),
          ],
        ));
  }
}
