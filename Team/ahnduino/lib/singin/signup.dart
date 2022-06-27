import 'package:ahnduino/Auto.dart';

import 'package:ahnduino/singin/signin.dart';
import 'package:ahnduino/singin/singupdate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SingUp> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool? Cks;
  bool? Ck = false;
  Map<String, Map<String, dynamic>> Datainfo = {};
  Map<String, dynamic> certificationemail = Map<String, dynamic>();
  DateTime? checkoutday;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordControllerValue = TextEditingController();
  TextEditingController _pnController = TextEditingController();
  TextEditingController _cdController = TextEditingController();

  Widget buildName() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, blurRadius: 3, offset: Offset(0, 3))
              ]),
          child: Form(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        //contentPadding:
                        // EdgeInsets.only(top: layoutInfo.getHeight(1.8)),
                        prefixIcon: Icon(
                          Icons.people,
                          color: Color(0xff5ac18e),
                        ),
                        hintText: 'name',
                        helperStyle:
                            TextStyle(color: Colors.black38, fontSize: 30.sp)),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildID() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        width: layoutInfo.getWidth(62),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black, blurRadius: 3, offset: Offset(0, 3))
            ]),
        child: Form(
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  //contentPadding:
                  //  EdgeInsets.only(top: layoutInfo.getHeight(1.8)),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xff5ac18e),
                  ),
                  hintText: 'email를 입력해주세요...',
                  helperStyle:
                      TextStyle(color: Colors.black38, fontSize: 30.sp)),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildcertificationemail() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        width: layoutInfo.getWidth(20),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // ignore: unnecessary_null_comparison
                if (emailController.text != null &&
                        emailController.text.isEmpty ||
                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(emailController.text)) {
                  try {
                    await firestore
                        .collection('User')
                        .doc(emailController.text)
                        .get()
                        .then((doc) {
                      certificationemail = doc.data()!;
                      Failemail();
                    });
                  } catch (e) {
                    successemail();
                    Ck = true;
                  }
                } else {
                  Failemails();
                }
              },
              child: Text(
                '중복확인',
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
                    top: layoutInfo.getHeight(2),
                    left: layoutInfo.getWidth(2),
                    right: layoutInfo.getWidth(2),
                    bottom: layoutInfo.getHeight(2)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPasswords() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 3))
          ]),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: passwordController,
          obscureText: true,
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              // contentPadding: EdgeInsets.only(top: 10.h),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Passwords(6자리 이상 입력해주세요...)',
              helperStyle: TextStyle(color: Colors.black38, fontSize: 30.sp)),
        ),
      ),
    );
  }

  Widget buildPasswordsValue() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 3))
          ]),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: passwordControllerValue,
          obscureText: true,
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              // contentPadding: EdgeInsets.only(top: 10.h),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xff5ac18e),
              ),
              hintText: 'Passwords(6자리 이상 입력해주세요...)',
              helperStyle: TextStyle(color: Colors.black38, fontSize: 30.sp)),
        ),
      ),
    );
  }

  Widget buildPhoneNumber() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 3))
          ]),
      child: Form(
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            controller: _pnController,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                //contentPadding: EdgeInsets.only(top: 10.h),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Color(0xff5ac18e),
                ),
                hintText: 'PhoneNumber( \'- 제외\')',
                helperStyle: TextStyle(color: Colors.black38, fontSize: 30.sp)),
          ),
        ),
      ),
    );
  }

  Widget buildInRoomOutRoom() {
    return Container(
      child: MySetDayAndTimeWidget(
        settime: checkoutday,
        getDays: (DateTime days) {
          checkoutday = days;
        },
      ),
    );
  }

  Widget buildCode() {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 3))
          ]),
      child: Form(
          child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              controller: _cdController,
              keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  //contentPadding: EdgeInsets.only(top: 10.h),
                  prefixIcon: Icon(
                    Icons.security,
                    color: Color(0xff5ac18e),
                  ),
                  hintText: 'Building Certification Number...',
                  helperStyle:
                      TextStyle(color: Colors.black38, fontSize: 30.sp)),
            ),
          ),
        ],
      )),
    );
  }

  Widget buildSingUp() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Column(
        children: <Widget>[
          ElevatedButton(
              onPressed: () async {
                var info = await firestore.collection('Building').get();
                info.docs.forEach((element) {
                  Datainfo[element.id] = (element.data());
                });
                try {
                  Map<String, dynamic> check = Map<String, dynamic>();
                  for (var element in Datainfo.keys) {
                    if (Datainfo[element]!["인증번호"] == _cdController.text &&
                        Datainfo[element]!["Used"] == false) {
                      check = Datainfo[element]!;
                      Datainfo[element]!["Used"] = true;
                      await firestore
                          .collection('Building')
                          .doc(element)
                          .set(Datainfo[element]!);
                    } else {
                      FailCDS();
                    }
                  }

                  /*
                  Datainfo.forEach((element) {
                    if (element["인증번호"] == _cdController.text) {
                      check = element;
                    }
                  });*/

                  if (Ck == false) {
                    FailCk();
                    return;
                  }
                  if (checkoutday == null) {
                    FailOutRoom();
                    return;
                  }

                  if (nameController.value.text.isEmpty) {
                    FailName();
                    return;
                  }
                  if (emailController.value.text.isEmpty) {
                    FailEmail();
                    return;
                  }

                  var docid = await firestore
                      .collection('User')
                      .doc(emailController.text)
                      .get();
                  if (docid.exists) {
                    FailCks();
                    return;
                  }
                  if (passwordController.value.text.isEmpty) {
                    FailPasswords();
                    return;
                  }
                  if (passwordControllerValue.value.text.isEmpty) {
                    FailPasswordsvalue();
                    return;
                  }
                  if (passwordController.value.text !=
                      passwordControllerValue.value.text) {
                    Fail_Passwords();
                    return;
                  }
                  if (_pnController.value.text.isEmpty) {
                    FailPhoneNumber();
                    return;
                  }
                  if (_cdController.value.text.isEmpty) {
                    FailCode();
                    return;
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(emailController.text)) {
                    FailLoginEmail();
                    return;
                  }
                  if (!RegExp(r'^\d{3}\d{3,4}\d{4}$')
                      .hasMatch(_pnController.text)) {
                    FailLoginPhon();
                    return;
                  }
                  if (passwordController.text.length < 6) {
                    FailLoginPass();
                    return;
                  }
                  if (check.isNotEmpty &&
                      checkoutday != null &&
                      Ck == true &&
                      nameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(emailController.text) &&
                      passwordController.value.text.isNotEmpty &&
                      _pnController.value.text.isNotEmpty &&
                      RegExp(r'^\d{3}\d{3,4}\d{4}$')
                          .hasMatch(_pnController.text) &&
                      passwordController.text.length >= 6) {
                    singUp();
                    firestore.collection('User').doc(emailController.text).set({
                      "이름": nameController.text,
                      "메일": emailController.text,
                      "전화번호": _pnController.text,
                      "인증번호": _cdController.text,
                      "주소": check["주소"].toString(),
                      "계약만료일": checkoutday,
                      "관리비": check["관리비"],
                      "미납": check["미납"],
                      "수리비": check["수리비"],
                      "가입일": DateTime.now(),
                      "건물명": check["건물명"]
                    });

                    firestore
                        .collection('Bill')
                        .doc(emailController.text)
                        .set({});
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: Text(
                'SignUp',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 143, 94),
                  letterSpacing: 1.5,
                  fontSize: 16.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 5.0,
                padding: EdgeInsets.only(
                    top: layoutInfo.getHeight(2),
                    left: layoutInfo.getWidth(33),
                    right: layoutInfo.getWidth(33),
                    bottom: layoutInfo.getHeight(2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ))
        ],
      ),
    );
  }

  Future FailCks() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '중복된 이메일 입니다.',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailCk() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '이메일 중복을 확인해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailCDS() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '이미 사용중인 인증번호입니다.',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailOutRoom() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '계약 만료일을 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailLoginPass() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '비밀번호를 확인해주세요(6자리 이상 입력)',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailLoginPhon() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '전화번호를 확인해주세요\n(-를 제외 입력해주세요)',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailLoginEmail() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '유효한 이메일 주소가 아닙니다.\n 다시입력하여 주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future Failemails() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '이메일을 제대로 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailName() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '이름을 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailEmail() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '이메일을 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailPasswords() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '비밀번호를 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailPasswordsvalue() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '비밀번호 확인을 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future Fail_Passwords() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '비밀번호가 일치하지 않습니다.\n다시 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    passwordController.clear();
                    passwordControllerValue.clear();
                  })
            ],
          ));

  Future FailPhoneNumber() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '전화번호를 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailCode() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '인증번호를 입력해주세요',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future successemail() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '사용가능한 아이디 입니다.',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future Failemail() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '이미 사용중인 아이디 입니다.',
              style: TextStyle(fontSize: 15.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future success() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '(회원가입성공) 이메일 인증 후 \n로그인해주세요',
              style: TextStyle(fontSize: 15.sp),
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

  Future Fail() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '(회원가입 실패)다시 확인해주세요',
              style: TextStyle(fontSize: 13.sp),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future singUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      success();
    } catch (e) {
      Fail();
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
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => SingIn()),
                        (route) => false);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                ),
              ]),
              backgroundColor: Color.fromARGB(255, 230, 235, 238),
              title: Text(
                '도와줘 홈즈! 회원가입',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              centerTitle: true),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(
                  top: layoutInfo.getHeight(2),
                  left: layoutInfo.getWidth(7),
                  right: layoutInfo.getWidth(7),
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      Text(
                        '이름',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      buildName(),
                      SizedBox(
                        height: layoutInfo.getHeight(2.5),
                      ),
                      Text(
                        '이메일',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      Row(
                        children: [
                          buildID(),
                          SizedBox(
                            width: layoutInfo.getWidth(4),
                          ),
                          buildcertificationemail()
                        ],
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      Text(
                        '비밀번호',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      buildPasswords(),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      Text(
                        '비밀번호 확인',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      buildPasswordsValue(),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      Text(
                        '전화번호',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      buildPhoneNumber(),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      Text(
                        '건물 인증 번호',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      buildCode(),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      Text(
                        '계약 만료일',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      buildInRoomOutRoom(),
                      SizedBox(
                        height: layoutInfo.getHeight(1.3),
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(2),
                      ),
                      buildSingUp()
                    ])),
          )),
    );
  }
}
