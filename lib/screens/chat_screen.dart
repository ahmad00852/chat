import 'package:chat_app/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

  final _firestore = FirebaseFirestore.instance;
  late User currentUser;
class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController messageController = TextEditingController();
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

  void messagesStreams() async{
   await for(var snapshot in _firestore.collection('messages').snapshots()){
     for(var message in snapshot.docs){
       
     }
   }
  }
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
            MessageStreamBuilder(),
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
                      'sender': currentUser.email,
                      'time':FieldValue.serverTimestamp()
                    });
                    messageController.clear();
                  }, child: Text('send',style: TextStyle(color: Colors.blue[800],fontWeight: FontWeight.bold,fontSize: 18),))
              ],),
            )
          ],
        ),
      ),
    );
  }
}
class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('time').snapshots(),
        builder: (context,snapshot){
          List<MessageLine> messageWidgets=[];
          if(!snapshot.hasData){
            return Center(child: Text('No Data',style: TextStyle(
              fontSize: 30
            ),),);
          }else {
            final messages = snapshot.data!.docs.reversed;
            for(var message in messages){
              final messageText = message.get('message');
              final messageSender = message.get('sender');
              final signedInUser = currentUser.email;
              final messageWidget =MessageLine(sender: messageSender, text: messageText, isMe: signedInUser == messageSender,);
              messageWidgets.add(messageWidget);
            }
            return Expanded(
              child: ListView(reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                children: messageWidgets,
              ),
            );
          }
        });
  }
}




class MessageLine extends StatelessWidget {
  const MessageLine({super.key, required this.sender, required this.text,required this.isMe});
final String sender;
final String text;
final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(fontSize: 12,color: Colors.yellow[900]),),
          Material(
            borderRadius:isMe? BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)
            ):BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ),
              color:isMe? Colors.blue[800]:Colors.yellow[900],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                child: Text(text,style: TextStyle(
                  fontSize: 15,
                  color: Colors.white
                ),),
              )),
        ],
      ),
    );
  }
}
