import 'package:chattingtest/screens/board_screen.dart';
import 'package:chattingtest/screens/board_write.dart';
import 'package:chattingtest/screens/chat_screen.dart';
import 'package:chattingtest/screens/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'singin/singin.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(370, 690),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context) => MaterialApp(
    title: 'Ahnduino',
    home: Login(),
    )
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    if (auth.currentUser != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => boardscreen()));
    } else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SingIn()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 143, 94),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: 300,
        ),
        Text(
          'Ahnduino',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ]),
    );
  }
}
