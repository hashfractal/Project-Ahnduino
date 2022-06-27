import 'package:ahnduino/Auto.dart';
import 'package:ahnduino/mainpage/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
          appBar: AppBar(
            leading: Row(children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
              ),
            ]),
            backgroundColor: Color.fromRGBO(230, 235, 238, 1.0),
            title: Padding(
              padding: const EdgeInsets.only(right: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_outlined, size: 20, color: Colors.black),
                  Text(
                    '관리자 문의',
                  ),
                ],
              ),
            ),
            titleTextStyle: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            actions: [],
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.1), BlendMode.dstATop),
                    image: AssetImage('assets/homegr.png'))),
            child: Column(
              children: [
                Expanded(child: Messages()),
                NewMessage(),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(children: <Widget>[
              SizedBox(
                width: layoutInfo.getWidth(13),
              ),
              Container(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  },
                  icon: Image.asset(
                    'assets/chat.png',
                  ),
                  iconSize: 50,
                ),
              ),
              SizedBox(
                width: layoutInfo.getWidth(14),
              ),
              Container(
                child: IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Mainpage()),
                        (route) => false);
                  },
                  icon: Image.asset(
                    'assets/house.png',
                  ),
                  iconSize: 40,
                ),
              ),
              SizedBox(
                width: layoutInfo.getHeight(7),
              ),
              Container(
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/noti.png',
                  ),
                  iconSize: 40,
                ),
              )
            ]),
          )),
    );
  }
}
