import 'package:client_photogenie/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    Authmethods authmethods = Authmethods();
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user.name} ${user.lastname}'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authmethods.logoutUser(context);
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
