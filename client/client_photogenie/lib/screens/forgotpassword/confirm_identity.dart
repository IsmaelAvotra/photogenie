import 'package:client_photogenie/controllers/sign_up_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:video_player/video_player.dart';
import 'package:client_photogenie/utils/utils.dart';

import '../../resources/auth_methods.dart';

class ConfirmIdentity extends StatefulWidget {
  const ConfirmIdentity({super.key});

  @override
  State<ConfirmIdentity> createState() => _ConfirmIdentityState();
}

class _ConfirmIdentityState extends State<ConfirmIdentity> {
  late final VideoPlayerController _videoPlayerController;
  final Authmethods authmethods = Authmethods();
  final TextEditingController _otpController = TextEditingController();
  final ForgetPasswordController f = Get.find();

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

  void verifyOtp() {
    authmethods.verifyCode(
        context: context,
        otp: _otpController.text,
        email: f.forgetEmailController.text);
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
                  'Forgot password',
                  style: TextStyle(
                    color: Color(0xfffffffe),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Please enter the email associated with your account to confirm your identity and reset your password',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.25,
                    color: Color(0xccfffffe),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
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
                      verifyOtp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffAE2A58),
                    ),
                    child: const Text('Submit the code'),
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
