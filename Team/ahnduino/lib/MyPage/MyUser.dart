import 'package:ahnduino/Auto.dart';
import 'package:ahnduino/MyPage/MyPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

// ignore: camel_case_types
class usercorrect extends StatefulWidget {
  usercorrect({
    Key? key,
    required this.adress,
  }) : super(key: key);

  final String adress;
  @override
  State<usercorrect> createState() => _usercorrect();
}

// ignore: camel_case_types
class _usercorrect extends State<usercorrect> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> useris = Map<String, dynamic>();
  Map<String, dynamic> useraddress = Map<String, dynamic>();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phonenum = TextEditingController();

  Widget buildUser1(String addre) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
        height: 240,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3)),
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 10),
              CircleAvatar(
                backgroundImage: AssetImage('assets/mypagehome.png'),
                radius: 50,
              ), //홈이미지 넣은코드
            ],
          ),
          SizedBox(height: 20),
          Text(
            addre,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildUser2() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        padding: EdgeInsets.fromLTRB(35, 10, 35, 0),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, //이거 넣으면 왼쪽으로 가야하는거 아닌가?
              children: <Widget>[
                Row(mainAxisAlignment: MainAxisAlignment.start),
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: '이름을 작성해주세요',
                    labelText: '이름',
                    icon: Icon(Icons.people,
                        color: Color.fromARGB(255, 0, 143, 94)),
                    labelStyle: TextStyle(color: Colors.black),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: layoutInfo.getHeight(3),
                ),
                TextFormField(
                  controller: phonenum,
                  decoration: InputDecoration(
                    hintText: '-를 제외하고 입력해주세요',
                    labelText: '전화번호',
                    icon: Icon(Icons.call,
                        color: Color.fromARGB(255, 0, 143, 94)),
                    labelStyle: TextStyle(color: Colors.black),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: layoutInfo.getHeight(3),
                ),
                TextFormField(
                  controller: password,
                  style: TextStyle(color: Colors.black),
                  obscureText: true, //글자 작성시 땡땡이로
                  decoration: InputDecoration(
                    hintText: '비밀번호 작성해주세요(6자리 이상)',
                    labelText: '비밀번호',
                    icon: Icon(Icons.lock,
                        color: Color.fromARGB(255, 0, 143, 94)),
                    labelStyle: TextStyle(color: Colors.black),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: layoutInfo.getHeight(3),
            ),
            TextButton(
              onPressed: () {
                if (password.text.length < 6 && password.text.isNotEmpty) {
                  failPassword();
                  return;
                }
                if (!RegExp(r'^\d{3}\d{3,4}\d{4}$').hasMatch(phonenum.text) &&
                    phonenum.text.isNotEmpty) {
                  failPhone();
                  return;
                }
                trueUser();
              },
              child: Row(
                children: [Icon(Icons.outbond), Text('저장')],
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color.fromARGB(255, 0, 143, 94),
                padding: EdgeInsets.only(
                    left: layoutInfo.getWidth(35),
                    right: layoutInfo.getWidth(35),
                    top: layoutInfo.getHeight(1.5),
                    bottom: layoutInfo.getHeight(1.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<bool> trueUser() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              '개인정보를 정말 변경하시겠습니까?',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      if (name.text.isNotEmpty) {
                        useris['이름'] = name.text;
                      }
                      if (password.text.isNotEmpty) {
                        FirebaseAuth.instance.currentUser!
                            .updatePassword(password.text);
                      } else if (password.text.length < 6) {}

                      if (phonenum.text.isNotEmpty) {
                        useris['전화번호'] = phonenum.text;
                      }

                      await FirebaseFirestore.instance
                          .collection('User')
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .update(useris);
                      YesUser();
                    } catch (e) {}
                  },
                  child: Text(
                    '네',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  )),
              TextButton(
                  onPressed: () {
                    //onWillpop에 false 전달되어 앱이 종료되지 않는다.
                    Navigator.pop(context, false);
                  },
                  child: Text('아니요',
                      style: TextStyle(color: Colors.black, fontSize: 15))),
            ],
          );
        });
  }

  Future YesUser() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '개인정보가 변경 되었습니다.',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyHomePage()),
                      (route) => false);
                },
              )
            ],
          ));

  Future failPhone() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '전화번호를 다시 확인해주세요(-를 빼고 입력해주세요)',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));

  Future failPassword() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '비밀번호를 다시 확인해주세요(6자리 이상)',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));

  @override
  Widget build(BuildContext context) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 231, 238, 243),
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
            title: Text(
              '개인정보수정',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromARGB(255, 230, 235, 238),
            centerTitle: true,
            elevation: 6,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical, //화면 스크롤바
            child: Column(
              children: <Widget>[buildUser1(widget.adress), buildUser2()],
            ),
          )),
    );
  }
}
