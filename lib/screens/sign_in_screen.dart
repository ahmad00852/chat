import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/my_button.dart';

class SignInScreen extends StatefulWidget {
  static const String screenRoute = 'sign_in_screen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth =FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(height: 50,),
            TextFormField(
              controller: emailController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter your Email',
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange,width: 1)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue,width: 2)),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: passwordController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter your Password',
                contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange,width: 1)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue,width: 2)),
              ),
            ),
            SizedBox(height: 10,),
            MyButton(color: Colors.yellow[900]!, title: 'Sign in', onPressed: () async{
              try {
                final user= await _auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                Navigator.pushReplacementNamed(context, ChatScreen.screenRoute);

              }catch (e) {
                print(e);
              }
            })
          ],
        ),
      ),
    );
  }
}
