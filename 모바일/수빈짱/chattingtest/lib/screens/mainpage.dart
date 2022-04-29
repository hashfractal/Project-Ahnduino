import 'package:chattingtest/singin/singin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);
  @override
  _MainpageState createState() => _MainpageState();
}

Widget buildSingOut(BuildContext context) {
  return Column(
    children: <Widget>[
      ElevatedButton(
        onPressed: () {
          try {
            FirebaseAuth.instance.signOut().whenComplete(() => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SingIn())));
          } catch (e) {
            print(e.toString());
          }
        },
        child: Text(
          '로그아웃',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 143, 94),
            letterSpacing: 1.5,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 5.0,
          padding: EdgeInsets.only(top: 10, left: 140, right: 140, bottom: 10),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
      )
    ],
  );
}

class _MainpageState extends State<Mainpage> {
  Map<String, dynamic> cert = Map<String, dynamic>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 0, 143, 94),
        body: Padding(
            padding: EdgeInsets.only(top: 10, left: 30, right: 30),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                    color: Color.fromARGB(255, 0, 143, 94),
                    child: Center(
                      child: Image.asset(
                        'assets/home.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Text(
                    'Ahnduino',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  buildSingOut(context)
                ])));
  }
}
