import 'package:chattingtest/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chatting/message.dart';
import '../chatting/new_message.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     leading: BackButton(
       color: Color.fromRGBO(0, 143, 94, 1.0),
     ),

        backgroundColor: Color.fromRGBO(230, 235, 238, 1.0),
        title: Text('관리자 문의'),
        titleTextStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 143, 94, 1.0)),

        actions: [

        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.1),BlendMode.dstATop),
            image: AssetImage('asset/images.png')
          )
        ),
        child: Column(
          children: [
            Expanded(
                child: Messages()
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}