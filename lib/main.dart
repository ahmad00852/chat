import 'package:chat_app/screens/sign_in_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: _auth.currentUser != null ?ChatScreen.screenRoute :WelcomeScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute:(context)=>WelcomeScreen(),
        RegisterScreen.screenRoute:(context)=>RegisterScreen(),
        SignInScreen.screenRoute:(context)=>SignInScreen(),
        ChatScreen.screenRoute:(context)=>ChatScreen(),
      },
    );
  }
}
