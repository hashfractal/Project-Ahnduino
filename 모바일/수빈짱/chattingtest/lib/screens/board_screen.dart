import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class boardscreen extends StatefulWidget {
  const boardscreen({Key? key}) : super(key: key);

  @override
  _boardscreenState createState() => _boardscreenState();
}


class _boardscreenState extends State<boardscreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color.fromRGBO(0, 143, 94, 1.0),
        ),

        backgroundColor: Color.fromRGBO(230, 235, 238, 1.0),
        title: Text('자유게시판'),
        titleTextStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 143, 94, 1.0)),

        actions: [

        ],
      ),

      body: Container(
            )

        child: Column(
          children: [
            Expanded(
                child: (),
            ),
            (),
          ],

    );
  }
}