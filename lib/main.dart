import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? seen = prefs.getBool('seen');
  Widget screen;
  if (seen == null || seen == false) {
    screen = OnBoarding();
  } else {
    screen = HomeScreen();
  }

  runApp(NewsApp(screen));
}

class NewsApp extends StatelessWidget {
  final Widget screen;
  const NewsApp(this.screen, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: this.screen,
    );
  }
}
