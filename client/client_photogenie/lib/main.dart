import 'package:client_photogenie/providers/user_provider.dart';
import 'package:client_photogenie/resources/auth_methods.dart';
import 'package:client_photogenie/screens/signin/sign_in_screen.dart';
import 'package:client_photogenie/utils/locator.dart';
import 'package:client_photogenie/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/sign_up_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: MyApp(prefs: prefs),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Authmethods authmethods = Authmethods();

  @override
  void initState() {
    super.initState();
    authmethods.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ForgetPasswordController());
    return GetMaterialApp(
      title: 'Photogenie application',
      home: Provider.of<UserProvider>(context).user.token.isNotEmpty
          ? const BottomBar()
          : const SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
