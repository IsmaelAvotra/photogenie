
import 'package:client_photogenie/controllers/sign_up_controller.dart';
import 'package:client_photogenie/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:client_photogenie/widgets/text_button.dart';
import 'package:client_photogenie/widgets/text_field_input.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class EmailForgotPasswordScreen extends StatefulWidget {
  const EmailForgotPasswordScreen({super.key});

  @override
  State<EmailForgotPasswordScreen> createState() =>
      _EmailForgotPasswordScreenState();
}

class _EmailForgotPasswordScreenState extends State<EmailForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final VideoPlayerController _videoPlayerController;
  final ForgetPasswordController f = Get.put(ForgetPasswordController());

  final Authmethods authmethods = Authmethods();

  bool isLoading = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    _videoPlayerController.dispose();
  }

  void forgotPassword() {
    setState(() {
      isLoading = true;
    });
    authmethods.emailForgotPassword(
      context: context,
      email: f.forgetEmailController.text,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0E17),
      resizeToAvoidBottomInset: false,
      body: Stack(children: <Widget>[
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
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: f.forgetEmailController,
                icon: 'email',
              ),

              const SizedBox(
                height: 30,
              ),
              //Login button
              ButtonText(
                function: () {
                  forgotPassword();
                },
                text: 'Confirm email',
                width: 240,
                isLoading: isLoading,
              ),

              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
