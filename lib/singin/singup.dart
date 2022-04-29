import 'package:ahnduino/singin/singin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SingUp> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Map<String, dynamic> Datainfo = Map<String, dynamic>();
  Map<String, dynamic> certificationemail = Map<String, dynamic>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController _pnController = TextEditingController();
  TextEditingController _cdController = TextEditingController();

  Widget buildName() {
    return Container(
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
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 15),
                    prefixIcon: Icon(
                      Icons.people,
                      color: Color(0xff5ac18e),
                    ),
                    hintText: 'name',
                    helperStyle:
                        TextStyle(color: Colors.black38, fontSize: 30)),
              ),
            ],
          ),
        ));
  }

  Widget buildID() {
    return Container(
      width: 260,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 3, offset: Offset(0, 3))
          ]),
      child: Form(
        child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 15),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xff5ac18e),
              ),
              hintText: 'email를 입력해주세요...',
              helperStyle: TextStyle(color: Colors.black38, fontSize: 30)),
        ),
      ),
    );
  }

  Widget buildcertificationemail() {
    return Container(
      width: 80,
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
                    print(certificationemail);
                    Failemail();
                  });
                } catch (e) {
                  successemail();
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
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 5.0,
              padding:
                  EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          )
        ],
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
      child: TextField(
        controller: passwordController,
        obscureText: true,
        keyboardType: TextInputType.name,
        style: TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 15),
            prefixIcon: Icon(
              Icons.lock,
              color: Color(0xff5ac18e),
            ),
            hintText: 'Passwords(6자리 이상 입력해주세요...)',
            helperStyle: TextStyle(color: Colors.black38, fontSize: 30)),
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
        child: TextFormField(
          controller: _pnController,
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.black87),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 15),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xff5ac18e),
              ),
              hintText: 'PhoneNumber( \'- 제외\')',
              helperStyle: TextStyle(color: Colors.black38, fontSize: 30)),
        ),
      ),
    );
  }

  Widget buildCode() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
            children: [
              TextFormField(
                controller: _cdController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 15),
                    prefixIcon: Icon(
                      Icons.security,
                      color: Color(0xff5ac18e),
                    ),
                    hintText: 'Building Certification Number...',
                    helperStyle:
                        TextStyle(color: Colors.black38, fontSize: 30)),
              ),
            ],
          )),
        ));
  }

  Widget buildSingUp() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          ElevatedButton(
              onPressed: () async {
                await firestore
                    .collection('Building')
                    .doc('Ahnduino')
                    .get()
                    .then((value) {
                  Datainfo = value.data()!;
                });
                try {
                  if (Datainfo["${_cdController.text}"] != null &&
                      nameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(emailController.text) &&
                      passwordController.value.text.isNotEmpty &&
                      _pnController.value.text.isNotEmpty &&
                      RegExp(r'^\d{3}\d{3,4}\d{4}$')
                          .hasMatch(_pnController.text) &&
                      passwordController.text.length > 6) {
                    singUp();
                    firestore.collection('User').doc(emailController.text).set({
                      "이름": nameController.text,
                      "메일": emailController.text,
                      "비밀번호": passwordController.text,
                      "전화번호": _pnController.text,
                      "인증번호": _cdController.text,
                      "주소": Datainfo["${_cdController.text}"].toString(),
                    });
                  } else if (nameController.value.text.isEmpty) {
                    FailName();
                  } else if (emailController.value.text.isEmpty) {
                    FailEmail();
                  } else if (passwordController.value.text.isEmpty) {
                    FailPasswords();
                  } else if (_pnController.value.text.isEmpty) {
                    FailPhoneNumber();
                  } else if (_cdController.value.text.isEmpty) {
                    FailCode();
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(emailController.text)) {
                    FailLoginEmail();
                  } else if (!RegExp(r'^\d{3}\d{3,4}\d{4}$')
                      .hasMatch(_pnController.text)) {
                    FailLoginPhon();
                  } else if (passwordController.text.length < 6) {
                    FailLoginPass();
                  }
                } catch (e) {
                  print('error');
                }
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
                    EdgeInsets.only(top: 15, left: 140, right: 140, bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ))
        ],
      ),
    );
  }

  Future FailLoginPass() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '비밀번호를 확인해주세요(6자리 이상 입력)',
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));

  Future FailPhoneNumber() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '전화번호를 입력해주세요',
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 15),
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
              '(회원가입성공) 로그인 해주세요',
              style: TextStyle(fontSize: 15),
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
              style: TextStyle(fontSize: 13),
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
      success();
    } catch (e) {
      Fail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromARGB(255, 230, 235, 238),
          title: Text(
            'Ahnduino 회원가입',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 10, left: 30, right: 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 15,
              ),
              Text(
                '이름',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              buildName(),
              SizedBox(
                height: 15,
              ),
              Text(
                '이메일',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  buildID(),
                  SizedBox(
                    width: 10,
                  ),
                  buildcertificationemail()
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                '비밀번호',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              buildPasswords(),
              SizedBox(
                height: 15,
              ),
              Text(
                '전화번호',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              buildPhoneNumber(),
              SizedBox(
                height: 20,
              ),
              Text(
                '건물 인증 번호',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              buildCode(),
              SizedBox(
                height: 35,
              ),
              buildSingUp()
            ])));
  }
}
