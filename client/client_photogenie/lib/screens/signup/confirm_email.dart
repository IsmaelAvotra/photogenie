import 'package:client_photogenie/controllers/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:video_player/video_player.dart';
import 'package:client_photogenie/utils/utils.dart';

import '../../resources/auth_methods.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({super.key});

  @override
  State<ConfirmEmail> createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  late final VideoPlayerController _videoPlayerController;
  final Authmethods authmethods = Authmethods();
  final SignUpController controllerEmail = Get.find();
  final TextEditingController _otpController = TextEditingController();

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

  void verifyEmailOtp() {
    authmethods.confirmEmail(
        context: context,
        email: controllerEmail.emailController.text,
        otp: _otpController.text);
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0E17),
      resizeToAvoidBottomInset: false,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 70,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 170,
                  height: 230,
                ),
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  'Enter confirmation code sent in your email',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffFFFFFE),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter the code we sent to ``****@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff11F9EB),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  validator: (s) {
                    return null;
                  },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  controller: _otpController,
                ),
                const SizedBox(
                  height: 50,
                ),
                //Login button
                SizedBox(
                  width: 240,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      verifyEmailOtp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffAE2A58),
                    ),
                    child: const Text('Confirm code'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
