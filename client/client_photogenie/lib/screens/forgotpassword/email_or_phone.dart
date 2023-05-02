import 'package:client_photogenie/resources/auth_methods.dart';
import 'package:client_photogenie/widgets/text_button.dart';
import 'package:client_photogenie/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/sign_up_controller.dart';

class EmailOrPhone extends StatefulWidget {
  const EmailOrPhone({super.key});

  @override
  State<EmailOrPhone> createState() => _EmailOrPhoneState();
}

class _EmailOrPhoneState extends State<EmailOrPhone> {
  late final VideoPlayerController _videoPlayerController;
  final ForgetPasswordController f = Get.put(ForgetPasswordController());
  final TextEditingController _phoneController = TextEditingController();
  int mode = 0;
  bool isLoading = false;
  final Authmethods authmethods = Authmethods();

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
    f.forgetEmailController.dispose();
    _phoneController.dispose();
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
      body: Stack(
        children: [
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    height: 70,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 350,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xffB4CDED),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      mode = 1;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                        ),
                                        border: mode == 1
                                            ? Border.all(
                                                color: const Color(0xffB4CDED),
                                                width: 1,
                                              )
                                            : null,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'With phone',
                                          style: TextStyle(
                                            color: Color(0xfffffffe),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      mode = 0;
                                    });
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(12),
                                        ),
                                        border: mode == 0
                                            ? Border.all(
                                                color: const Color(0xffB4CDED),
                                                width: 1,
                                              )
                                            : null,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'With email',
                                          style: TextStyle(
                                            color: Color(0xfffffffe),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Text(
                              'Please enter the ${mode == 0 ? 'email' : 'phone number'} associated with your account to confirm your identity.',
                              style: const TextStyle(
                                  color: Color(0xf2fffffe), fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            height: 40,
                            width: 290,
                            child: TextFieldInput(
                              hintText: mode == 0
                                  ? 'Enter your email'
                                  : 'Enter your phone number',
                              icon: mode == 0 ? 'email' : 'Phone',
                              textEditingController: mode == 0
                                  ? f.forgetEmailController
                                  : _phoneController,
                              textInputType: mode == 0
                                  ? TextInputType.emailAddress
                                  : TextInputType.phone,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ButtonText(
                              function: () {
                                forgotPassword();
                              },
                              text: mode == 0
                                  ? 'Confirm email'
                                  : 'Confirm phone number',
                              isLoading: false,
                              width: 240)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
