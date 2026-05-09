import 'package:vinaluma_admin/constants.dart';
import 'package:vinaluma_admin/screens/login/login_screen.dart';
import 'package:vinaluma_admin/screens/main/main_screen.dart';
import 'package:vinaluma_admin/services/api_service.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.loadToken();
  runApp(const VinalumaAdminApp());
}

class VinalumaAdminApp extends StatefulWidget {
  const VinalumaAdminApp({Key? key}) : super(key: key);

  @override
  State<VinalumaAdminApp> createState() => _VinalumaAdminAppState();
}

class _VinalumaAdminAppState extends State<VinalumaAdminApp> {
  bool _isLoggedIn = ApiService.isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vinaluma ERP',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins', bodyColor: Colors.white),
        canvasColor: secondaryColor,
        colorScheme: ColorScheme.dark(primary: primaryColor, secondary: accentColor),
      ),
      home: _isLoggedIn
          ? const MainScreen()
          : LoginScreen(onLoginSuccess: () => setState(() => _isLoggedIn = true)),
    );
  }
}
