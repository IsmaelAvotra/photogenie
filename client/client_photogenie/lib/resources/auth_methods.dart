import 'dart:convert';
import 'package:client_photogenie/constants/global_variables.dart';
import 'package:client_photogenie/models/user_model.dart';
import 'package:client_photogenie/screens/confirm_identity.dart';
import 'package:client_photogenie/screens/confirm_email.dart';
import 'package:client_photogenie/screens/create_avatar.dart';
import 'package:client_photogenie/screens/sign_in_screen.dart';
import 'package:client_photogenie/screens/update_password_screen.dart';
import 'package:client_photogenie/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/google_signin_api.dart';
import '../constants/error_handling.dart';
import '../providers/user_provider.dart';

class Authmethods {
  //sign up user
  void signUpUser({
    required context,
    required String name,
    required String lastname,
    required String password,
    required String birthday,
    required String email,
    required String username,
    required String number,
    required String country,
  }) async {
    try {
      User user = User(
          token: '',
          name: name,
          lastname: lastname,
          email: email,
          id: '',
          birthday: birthday,
          username: username,
          country: country,
          phone: number,
          password: password);

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          Get.snackbar(
            'About signup',
            "Your account is created",
            backgroundColor: const Color(0xff0F0E17),
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text(
              'Account created',
              style: TextStyle(
                  color: Color.fromARGB(255, 231, 224, 233),
                  fontWeight: FontWeight.bold),
            ),
            colorText: const Color(0xffFFFFFE),
          );
          Get.offAll(() => const ConfirmEmail());
        },
      );
    } catch (e) {
      Get.snackbar(
        'About signup',
        e.toString(),
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'About signup',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    }
  }

  //sign in user
  void signInUser({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Get.offAll(() => const BottomBar());
        },
      );
    } catch (e) {
      Get.snackbar(
        'About signin',
        e.toString(),
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Sign in failed',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    }
  }

  //confirm email
  void confirmEmail({
    required context,
    required String email,
    required String otp,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/verifySignupOtp'),
        body: jsonEncode(<String, String>{'email': email, 'otp': otp}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          Get.snackbar(
            'About confirm email',
            " Your account is confirmed",
            backgroundColor: const Color(0xff0F0E17),
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text(
              "Account is confirmed",
              style: TextStyle(
                  color: Color.fromARGB(255, 231, 224, 233),
                  fontWeight: FontWeight.bold),
            ),
            colorText: const Color(0xffFFFFFE),
          );
          Get.offAll(() => const CreateAvatarScreen());
        },
      );
    } catch (e) {
      Get.snackbar(
        'About confirm email',
        e.toString(),
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'About confirm email',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    }
  }

  //sign in with google
  Future signInGoogle() async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      Get.snackbar(
        'Login',
        "sign in failed",
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Login',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    } else {
      Get.offAll(() => const BottomBar());
    }
  }

  //get user data
  void getUserData({
    required context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        //get user data
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        Provider.of<UserProvider>(context, listen: false).setUser(userRes.body);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Error',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    }
  }

  //forgot password
  void emailForgotPassword({
    required context,
    required String email,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/requestPasswordResetByDigits'),
        body: jsonEncode(<String, String>{
          'email': email,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          Get.snackbar(
            'About forgot password',
            "Check your email",
            backgroundColor: const Color(0xff0F0E17),
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text(
              'Forgot password',
              style: TextStyle(
                  color: Color.fromARGB(255, 231, 224, 233),
                  fontWeight: FontWeight.bold),
            ),
            colorText: const Color(0xffFFFFFE),
          );
          debugPrint(res.body);
          Get.offAll(() => const ConfirmIdentity());
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Error',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    }
  }

  //verify code
  void verifyCode({
    required context,
    required String otp,
    required String email,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/verifyEmailOtp'),
        body: jsonEncode(<String, String>{
          'otp': otp,
          'email': email,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          Get.snackbar(
            'Success',
            jsonDecode(res.body)['message'],
            backgroundColor: const Color(0xff0F0E17),
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text(
              'Success',
              style: TextStyle(
                  color: Color.fromARGB(255, 231, 224, 233),
                  fontWeight: FontWeight.bold),
            ),
            colorText: const Color(0xffFFFFFE),
          );
          Get.offAll(() => const UpdatePasswordScreen());
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Error',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    }
  }

  //update password
  void updatePassword({
    required context,
    required String newPassword,
    required String email,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/resetPasswordByDigits'),
        body: jsonEncode(<String, String>{
          'newPassword': newPassword,
          'email': email,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          Get.snackbar(
            'Success',
            jsonDecode(res.body)['message'],
            backgroundColor: const Color(0xff0F0E17),
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text(
              'Success',
              style: TextStyle(
                  color: Color.fromARGB(255, 231, 224, 233),
                  fontWeight: FontWeight.bold),
            ),
            colorText: const Color(0xffFFFFFE),
          );
          Get.offAll(() => const SignInScreen());
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Error',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    }
  }

  //logout user
  void logoutUser({
    required context,
    required email,
    required refreshToken,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signout'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          Get.snackbar(
            'Success',
            jsonDecode(res.body)['message'],
            backgroundColor: const Color(0xff0F0E17),
            snackPosition: SnackPosition.BOTTOM,
            titleText: const Text(
              'Success',
              style: TextStyle(
                  color: Color.fromARGB(255, 231, 224, 233),
                  fontWeight: FontWeight.bold),
            ),
            colorText: const Color(0xffFFFFFE),
          );
          Get.offAll(() => const SignInScreen());
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Error',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
    }
  }
}
