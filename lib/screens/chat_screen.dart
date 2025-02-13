import 'package:chat_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  TextEditingController messageController = TextEditingController();
  late User currentUser;
  void getCurrentUser(){
    try {
      final user=_auth.currentUser;
      if(user != null){
        currentUser = user;
      }
    }catch (e) {
     print(e);
    }
  }

  void getAllMessages(){}
@override
  void initState() {
    getCurrentUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('assets/images/logo.png',width: 25,),
            SizedBox(width: 10,),
            Text('MessageMe',style: TextStyle(color: Colors.white),)
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            _auth.signOut();
            Navigator.pushNamed(context, WelcomeScreen.screenRoute);
          }, icon: Icon(Icons.exit_to_app_outlined,color: Colors.white,))
        ],
      ),
      body:SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Expanded(child: TextFormField(
                  controller: messageController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    hintText: 'Write your message here...',
                    border: InputBorder.none
                  ),
                ),),
                  TextButton(onPressed: (){
                    _firestore.collection('messages').add({
                      'message':messageController.text,
                      'sender': currentUser.email
                    });
                  }, child: Text('send',style: TextStyle(color: Colors.blue[800],fontWeight: FontWeight.bold,fontSize: 18),))
              ],),
            )
          ],
        ),
      ),
    );
  }
}
