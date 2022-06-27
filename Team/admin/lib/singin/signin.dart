import 'package:ahnduino/mainpage/mainpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'forgotpass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ahnduino/Auto.dart';

class SingIn extends StatefulWidget {
  const SingIn({Key? key}) : super(key: key);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SingIn> {
  Map<String, dynamic> workerck = Map<String, dynamic>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget buildId() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        width: layoutInfo.getWidth(85),
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
                contentPadding: EdgeInsets.only(top: layoutInfo.getHeight(1.5)),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xff5ac18e),
                ),
                hintText: 'Email (Email형식으로 입력하세요...)',
                helperStyle: TextStyle(color: Colors.black38, fontSize: 30.sp)),
          ),
        ),
      ),
    );
  }

  Widget buildPassWords() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        width: layoutInfo.getWidth(85),
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
              contentPadding: EdgeInsets.only(top: layoutInfo.getHeight(1.5)),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Passwords (6자리이상 입력하세요...)',
              helperStyle: TextStyle(color: Colors.black38, fontSize: 30.sp)),
        ),
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

  Widget buildSignIn() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              signIn();
            },
            child: Text(
              'SignIn',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 143, 94),
                letterSpacing: 1.5,
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 5.0,
              padding: EdgeInsets.only(
                  top: layoutInfo.getHeight(1.5),
                  left: layoutInfo.getWidth(33),
                  right: layoutInfo.getWidth(33),
                  bottom: layoutInfo.getHeight(1.5)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
          )
        ],
      ),
    );
  }

  Future signIn() async {
    try {
      final snapShot = await FirebaseFirestore.instance
          .collection('Worker')
          .doc(emailController.text)
          .get();

      if (snapShot.exists) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Mainpage()),
            (route) => false);
      } else {
        Fail();
      }
    } catch (e) {}
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

  Widget buildSignUp() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SingUp()));
            },
            child: Text(
              'SignUp',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 143, 94),
                letterSpacing: 1.5,
                fontSize: 18.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 5.0,
              padding: EdgeInsets.only(
                  top: layoutInfo.getHeight(1.5),
                  left: layoutInfo.getWidth(33),
                  right: layoutInfo.getWidth(33),
                  bottom: layoutInfo.getHeight(1.5)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onBackKey() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xff161619),
            title: Text(
              '끝내시겠습니까?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    //onWillpop에 true가 전달되어 앱이 종료 된다.
                    Navigator.pop(context, true);
                  },
                  child: Text('끝내기')),
              TextButton(
                  onPressed: () {
                    //onWillpop에 false 전달되어 앱이 종료되지 않는다.
                    Navigator.pop(context, false);
                  },
                  child: Text('아니요')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: WillPopScope(
        onWillPop: () {
          return _onBackKey();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromARGB(255, 0, 143, 94),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 130.h,
                  ),
                  Container(
                    color: Color.fromARGB(255, 0, 143, 94),
                    child: Center(
                      child: Image.asset(
                        'assets/home.png',
                        width: 100.w,
                        height: 100.h,
                      ),
                    ),
                  ),
                  Text(
                    'Ahnduino Manager',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  buildId(),
                  SizedBox(
                    height: 20.h,
                  ),
                  buildPassWords(),
                  SizedBox(
                    height: 8.5.h,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  buildSignIn(),
                  SizedBox(
                    height: 20.h,
                  ),
                  buildSignUp(),
                  buildForgotPassBtn(),
                ]),
          ),
        ),
      ),
    );
  }
}
