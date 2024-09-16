import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_checkin/consts/app_consts.dart';
import 'package:trivia_checkin/controller/checkin_controller.dart';
import 'package:trivia_checkin/pages/spash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedBaseUrl = prefs.getString('baseUrl');
  if (savedBaseUrl != null && savedBaseUrl.isNotEmpty) {
    ConstsApi.updateBaseUrl(savedBaseUrl);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CheckinController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trivia Checkin',
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const SpashScreen(),
    );
  }
}
