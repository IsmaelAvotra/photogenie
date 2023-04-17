import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  Logger().e(response.body);
  switch (jsonDecode(response.body)['status']) {
    case 'PENDING':
      onSuccess();
      break;
    case 'Success':
      onSuccess();
      break;
    case 'Failed':
      Get.snackbar(
        'Error',
        jsonDecode(response.body)['message'],
        backgroundColor: const Color(0xff0F0E17),
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Error occured',
          style: TextStyle(
              color: Color.fromARGB(255, 231, 224, 233),
              fontWeight: FontWeight.bold),
        ),
        colorText: const Color(0xffFFFFFE),
      );
      break;
  }
}
