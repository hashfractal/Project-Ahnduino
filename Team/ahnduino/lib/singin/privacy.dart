import 'package:ahnduino/singin/collection.dart';
import 'package:ahnduino/singin/service.dart';
import 'package:ahnduino/singin/signup.dart';
import 'package:flutter/material.dart';

import 'finance.dart';

class privacy extends StatefulWidget {
  const privacy({Key? key}) : super(key: key);
  @override
  _privacy createState() => _privacy();
}

class _privacy extends State<privacy> {
  var ck1 = false;
  var ck2 = false;
  var ck3 = false;
  var ck4 = false;
  var ck5 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Color.fromARGB(255, 230, 235, 238),
          title: Text(
            '도와줘홈즈! 약관동의',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Column(children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: RichText(
                  text: TextSpan(
                      text: '안녕하세요!\n',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                        TextSpan(
                            text: '마음놓고 도와줘홈즈!와\n편리한 주택관리',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.normal))
                      ]),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Image.asset(
                'assets/ckim.png',
                width: 100,
                height: 100,
              )
            ],
          ),
          Container(
            color: Color.fromARGB(30, 128, 128, 128),
            margin: EdgeInsets.only(top: 40),
            width: 450,
            height: 555,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 25),
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          width: 350,
                          height: 60,
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.7,
                                child: Checkbox(
                                  value: ck1,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      ck1 = value!;
                                      ck2 = value;
                                      ck3 = value;
                                      ck4 = value;
                                      ck5 = value;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  activeColor: Color(0Xff06bbfb),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.padded,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 7),
                                child: Text(
                                  '약관 전체동의',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 20),
                    child: Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 1.7,
                          child: Checkbox(
                            value: ck2,
                            onChanged: (bool? value) {
                              setState(() {
                                ck2 = value!;
                                if (ck2 && ck3 && ck4 && ck5) {
                                  ck1 = true;
                                } else {
                                  ck1 = false;
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            activeColor: Color(0Xff06bbfb),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            '(필수)도와줘 홈즈! 이용약관',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          service()),
                                  (route) => false);
                            },
                            icon: Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 20),
                    child: Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 1.7,
                          child: Checkbox(
                            value: ck3,
                            onChanged: (bool? value) {
                              setState(() {
                                ck3 = value!;
                                if (ck2 && ck3 && ck4 && ck5) {
                                  ck1 = true;
                                } else {
                                  ck1 = false;
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            activeColor: Color(0Xff06bbfb),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            '(필수)개인정보 수집 및 이용 동의',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          collection()),
                                  (route) => false);
                            },
                            icon: Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 20),
                    child: Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 1.7,
                          child: Checkbox(
                            value: ck4,
                            onChanged: (bool? value) {
                              setState(() {
                                ck4 = value!;
                                if (ck2 && ck3 && ck4 && ck5) {
                                  ck1 = true;
                                } else {
                                  ck1 = false;
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            activeColor: Color(0Xff06bbfb),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            '(필수)전자 금융거래 기본약관',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          finance()),
                                  (route) => false);
                            },
                            icon: Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 20),
                    child: Row(
                      children: <Widget>[
                        Transform.scale(
                          scale: 1.7,
                          child: Checkbox(
                            value: ck5,
                            onChanged: (bool? value) {
                              setState(() {
                                ck5 = value!;
                                if (ck2 && ck3 && ck4 && ck5) {
                                  ck1 = true;
                                } else {
                                  ck1 = false;
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            activeColor: Color(0Xff06bbfb),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            '(선택)광고성 SMS 알림 동의',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      onPressed: ck2 && ck3 && ck4
                          ? () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SingUp()),
                                  (route) => false);
                            }
                          : Fail,
                      child: Text(
                        '회원가입으로 넘어가기',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        elevation: 5.0,
                        padding: EdgeInsets.only(
                            top: 15, left: 80, right: 80, bottom: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  )
                ]),
          )
        ]));
  }

  Future Fail() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(
              '필수 이용약관를 체크해주세요',
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                child: Text('확인'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ));
}
