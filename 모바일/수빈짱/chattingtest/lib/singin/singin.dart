import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';
import '../screens/mainpage.dart';
import 'singup.dart';
import 'forgotpass.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key? key}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SingIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget buildId() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
          ]),
      child: Form(
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Email (Email형식으로 입력하세요...)',
              helperStyle: TextStyle(color: Colors.black38, fontSize: 30)),
        ),
      ),
    );
  }

  Widget buildPassWords() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
          ]),
      child: TextFormField(
        controller: passwordController,
        obscureText: true,
        keyboardType: TextInputType.name,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 10),
            prefixIcon: Icon(
              Icons.lock,
              color: Color(0xff5ac18e),
            ),
            hintText: 'Passwords (6자리이상 입력하세요...)',
            helperStyle: TextStyle(color: Colors.black38, fontSize: 30)),
      ),
    );
  }

  Widget buildForgotPassBtn() {
    return Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPass()),
            );
          },
          child: Text(
            '비밀번호를 잃어버리셨습니까?',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget buildSingIn() {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            signIn();
          },
          child: Text(
            'SingIn',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 143, 94),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 5.0,
            padding:
            EdgeInsets.only(top: 10, left: 140, right: 140, bottom: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
        )
      ],
    );
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatScreen()));
      print('Ok');
    } catch (e) {
      Fail();
    }
  }

  Future Fail() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '아이디와 비밀번호를 확인해주세요',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            child: Text('확인'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ));

  Widget buildSingUp() {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SingUp()),
            );
          },
          child: Text(
            'SingUp',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 143, 94),
              letterSpacing: 1.5,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 5.0,
            padding:
            EdgeInsets.only(top: 10, left: 135, right: 135, bottom: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 0, 143, 94),
        body: Padding(
          padding: EdgeInsets.only(top: 10, left: 30, right: 30),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: 100,
            ),
            Container(
              color: Color.fromARGB(255, 0, 143, 94),

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
            buildId(),
            SizedBox(
              height: 20,
            ),
            buildPassWords(),
            SizedBox(
              height: 8.5,
            ),
            SizedBox(
              height: 30,
            ),
            buildSingIn(),
            SizedBox(
              height: 20,
            ),
            buildSingUp(),
            buildForgotPassBtn(),
          ]),
        ));
  }
}
