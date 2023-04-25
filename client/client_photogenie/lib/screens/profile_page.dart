import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      backgroundColor: const Color(0xff0F0E17),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  SizedBox(
                    width: 60,
                  ),
                  Icon(
                    Icons.settings,
                    color: Color(0xfffffffe),
                    size: 30,
                  )
                ],
              ),
              const SizedBox(height: 100),
              Text(
                user.username,
                style: const TextStyle(
                    color: Color(0xffAE2A58),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 400,
                child: Center(
                  child: ModelViewer(
                    src: 'assets/images/avatar.glb',
                    autoRotate: true,
                    cameraControls: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
