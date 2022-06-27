import 'package:ahnduino/Auto.dart';
import 'package:ahnduino/singin/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<ForgotPass> {
  final firebaseAuth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();

  Future open() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '이메일 링크를 통해 비밀번호 재설정을 해주세요',
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SingIn()),
                  );
                },
              )
            ],
          ));

  Future Can() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '이메일이 존재하지 않습니다',
              style: TextStyle(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future<void> SendEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      open();
      print('Ok');
    } catch (e) {
      Can();
      print('No');
    }
  }

  Widget email() {
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
        controller: emailController,
        keyboardType: TextInputType.name,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 10.h),
            prefixIcon: Icon(
              Icons.email,
              color: Color(0xff5ac18e),
            ),
            hintText: '가입하신 이메일을 입력해주세요',
            helperStyle: TextStyle(color: Colors.black38, fontSize: 30.sp)),
      ),
    );
  }

  Widget buildPostemail() {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            SendEmail(emailController.text);
          },
          child: Text(
            '메일보내기',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 143, 94),
              letterSpacing: 1.5,
              fontSize: 13.0.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 5.0,
            padding: EdgeInsets.only(
                top: 10.h, left: 120.w, right: 120.w, bottom: 10.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromARGB(255, 0, 143, 94),
          body: Padding(
              padding: EdgeInsets.only(top: 10.h, left: 30, right: 30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: layoutInfo.getHeight(30),
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
                      'Ahnduino',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: layoutInfo.getHeight(3),
                    ),
                    email(),
                    SizedBox(
                      height: layoutInfo.getHeight(3),
                    ),
                    buildPostemail()
                  ]))),
    );
  }
}
