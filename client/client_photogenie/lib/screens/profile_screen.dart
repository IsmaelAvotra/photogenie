import 'package:client_photogenie/resources/auth_methods.dart';
import 'package:client_photogenie/widgets/text_button.dart';
import 'package:client_photogenie/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../controllers/sign_up_controller.dart';
import '../providers/user_provider.dart';
import "package:client_photogenie/constants/string_extension.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final VideoPlayerController _videoPlayerController;
  final SignUpController c = Get.put(SignUpController());
  late bool isEditing = false;
  late bool isEditingUsername = false;

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.asset('assets/video/bgvideo.mp4')
          ..initialize().then((context) {
            _videoPlayerController.play();
            _videoPlayerController.setLooping(true);
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    Authmethods authmethods = Authmethods();
    return Scaffold(
      backgroundColor: const Color(0xff0F0E17),
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _videoPlayerController.value.size.height,
                width: _videoPlayerController.value.size.width,
                child: VideoPlayer(_videoPlayerController),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 60,
                      ),
                      SizedBox(
                        width: 110,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: !isEditing
                                ? const Color(0xffAE2A58)
                                : const Color(0xFFFFFFFE),
                            backgroundColor: !isEditing
                                ? const Color(0xccFFFFFE)
                                : const Color(0xff2BA021),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                          child: !isEditing
                              ? const Text('Edit profile')
                              : const Text('Save profile'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  !isEditing
                      ? Stack(
                          children: [
                            CircleAvatar(
                              maxRadius: 45,
                              child: Image.asset(
                                'assets/images/profile.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            isEditing
                                ? const Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Color(0xffAE2A58),
                                      size: 18,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 16,
                  ),
                  !isEditing
                      ? Stack(
                          children: [
                            Text(
                              c.usernameController.text.isEmpty
                                  ? user.username
                                  : c.usernameController.text,
                              style: const TextStyle(
                                  color: Color(0xff3CF0DB),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            isEditing
                                ? Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isEditingUsername =
                                              !isEditingUsername;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Color(0xffAE2A58),
                                        size: 18,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            isEditingUsername
                                ? SizedBox(
                                    height: 40,
                                    child: TextFieldInput(
                                        textEditingController:
                                            c.usernameController,
                                        hintText: 'Enter your new username',
                                        textInputType: TextInputType.text,
                                        icon: 'Person'),
                                  )
                                : const SizedBox()
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 50,
                  ),
                  !isEditing
                      ? SizedBox(
                          width: double.infinity,
                          height: 360,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.transparent,
                            elevation: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Icon(
                                      Icons.person,
                                      color: Colors.white.withOpacity(.8),
                                      size: 28,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      '${user.name.capitalizeString()} ${user.lastname.capitalizeString()}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Icon(
                                      Icons.email_outlined,
                                      color: Colors.white.withOpacity(.8),
                                      size: 28,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      user.email,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Icon(
                                      Icons.calendar_month_rounded,
                                      color: Colors.white.withOpacity(.8),
                                      size: 28,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      user.birthday,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 32,
                                    ),
                                    Icon(
                                      Icons.phone,
                                      color: Colors.white.withOpacity(.8),
                                      size: 28,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      user.phone,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isEditing = !isEditing;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 167, 145, 153),
                                          width: 0.6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      authmethods.logoutUser(
                                          context: context,
                                          email: user.email,
                                          refreshToken: user.token);
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          isEditing ? 'Save' : 'Edit Profile',
                                          style: TextStyle(
                                              color: isEditing
                                                  ? const Color(0xff3CF0DB)
                                                  : const Color(0xffAE2A58),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          isEditing
                                              ? Icons.download_done_outlined
                                              : Icons.edit_note_outlined,
                                          color: isEditing
                                              ? const Color(0xff3CF0DB)
                                              : const Color(0xffAE2A58),
                                          size: 24.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            TextFieldInput(
                                textEditingController: c.firstnameController,
                                hintText: 'Firstname',
                                textInputType: TextInputType.text,
                                icon: 'Person'),
                            const SizedBox(height: 16),
                            TextFieldInput(
                                textEditingController: c.lastnameController,
                                hintText: 'Lastname',
                                textInputType: TextInputType.text,
                                icon: 'Person'),
                            const SizedBox(height: 16),
                            TextFieldInput(
                                textEditingController: c.emailController,
                                hintText: 'Your email',
                                textInputType: TextInputType.text,
                                icon: 'email'),
                            const SizedBox(height: 16),
                            TextFieldInput(
                                textEditingController: c.birthdayController,
                                hintText: 'Your birthday',
                                textInputType: TextInputType.text,
                                icon: 'calendar'),
                            const SizedBox(height: 16),
                            TextFieldInput(
                                textEditingController: c.passwordController,
                                hintText: 'Your password',
                                textInputType: TextInputType.text,
                                icon: 'password'),
                            const SizedBox(height: 32),
                            ButtonText(
                                function: () {
                                  // Get.to(() =>  ReadyPlayerMe());
                                  // authmethods.logoutUser(context);
                                },
                                text: 'Edit avatar',
                                isLoading: false,
                                width: 240)
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
