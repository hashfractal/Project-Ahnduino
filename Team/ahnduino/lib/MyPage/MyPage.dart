import 'package:ahnduino/MyPage/MyUser.dart';
import 'package:ahnduino/singin/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ahnduino/Auto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, Map<String, dynamic>> Datainfo = {};
  Widget buildMypageHome() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Column(
        children: <Widget>[],
      ),
    );
  }

  Widget buildDday(Timestamp days) {
    DateTime mutime = days.toDate();
    DateTime theseday = DateTime.now().toUtc().add(Duration(hours: 9));

    return TimerBuilder.periodic(const Duration(seconds: 1),
        builder: (context) {
      return Text(
        '앞으로 이 집과 함께\n' +
            'D-'
                '${mutime.difference(DateTime(theseday.year, theseday.month, theseday.day, mutime.hour, mutime.minute)).inDays}',
        style: TextStyle(
            fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.black),
      );
    });
  }

  Widget buildMypagehome(Timestamp days) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3)),
        child: Column(children: <Widget>[
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              SizedBox(width: 20),
              CircleAvatar(
                backgroundImage: AssetImage('assets/mypagehome.png'),
                radius: 45,
              ), //홈이미지 넣은코드
              SizedBox(
                  width: layoutInfo.getWidth(8),
                  height: layoutInfo.getHeight(15)),
              buildDday(days)
            ],
          ),
        ]),
      ),
    );
  }

  Widget buildTwoBox(
    String name,
    String Pn,
  ) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        padding: EdgeInsets.all(13),
        height: layoutInfo.getHeight(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3)),
        child: Column(children: <Widget>[
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '  이름 : ${name} \n  전화번호 : ${Pn} ',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => usercorrect(
                                adress: Addre,
                              )));
                },
                child: Row(
                  children: [Icon(Icons.logout), Text('개인정보수정')],
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color.fromARGB(255, 0, 143, 94),
                  padding: EdgeInsets.only(
                      left: layoutInfo.getWidth(3),
                      right: layoutInfo.getWidth(3),
                      top: layoutInfo.getHeight(1.5),
                      bottom: layoutInfo.getHeight(1.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Widget buildThreeBox(Timestamp days) {
    DateTime mutime = days.toDate();
    String formatDate = DateFormat('yy/MM/dd').format(mutime);
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        padding: EdgeInsets.all(13),
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3)),
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '    계약만료일: ${formatDate}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              TextButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  var imsitime = DateTime.now().add(Duration(hours: 9));
                  var nowDay = DateTime(
                      imsitime.year, imsitime.month, imsitime.day, 0, 0);
                  DateTime? dealtime = await showDatePicker(
                    initialDate: nowDay,
                    context: context,
                    firstDate: nowDay,
                    //시작일
                    lastDate: DateTime(
                        nowDay.year + 99, nowDay.month, nowDay.day, 0, 0),
                    //마지막일
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark(), //다크 테마
                        child: child!,
                      );
                    },
                  );
                  if (dealtime == null) return;
                  await FirebaseFirestore.instance
                      .collection('User')
                      .doc(FirebaseAuth.instance.currentUser!.email.toString())
                      .update({'계약만료일': dealtime});
                },
                child: Row(
                  children: [Icon(Icons.logout), Text('계약만료일 변경')],
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color.fromARGB(255, 0, 143, 94),
                  padding: EdgeInsets.only(
                      left: layoutInfo.getWidth(3),
                      right: layoutInfo.getWidth(3),
                      top: layoutInfo.getHeight(1.5),
                      bottom: layoutInfo.getHeight(1.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Future<DateTime?> GetDate(DateTime setTime) {
    Future<DateTime?> pickedDate = showDialog<DateTime>(
      context: context,
      builder: (context) {
        DateTime? tempPickedDate =
            DateTime(setTime.year, setTime.month, setTime.day, 9, 0);
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: SizedBox(
            height: 250,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        tempPickedDate = DateTime(
                            tempPickedDate!.year,
                            tempPickedDate!.month,
                            tempPickedDate!.day,
                            tempPickedDate!.hour - 9,
                            tempPickedDate!.minute);
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime(
                        setTime.year, setTime.month, setTime.day, 9, 0),
                    minuteInterval: 10,
                    minimumDate: DateTime(
                        setTime.year, setTime.month, setTime.day, 9, 0),
                    maximumDate: DateTime(
                        setTime.year, setTime.month, setTime.day, 17, 50),
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return pickedDate;
  }

  Widget buildFourBox() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().whenComplete(
                    () => //Navigator.push(
                        // context, MaterialPageRoute(builder: (context) => SingIn())));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => SingIn()),
                            (route) => false));
              },
              child: Row(
                children: [Icon(Icons.logout), Text('로그아웃')],
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
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                var info = await firestore.collection('Building').get();
                info.docs.forEach((element) {
                  Datainfo[element.id] = (element.data());
                });

                for (var element in Datainfo.keys) {
                  if (Datainfo[element]!["Used"] == true) {
                    Datainfo[element]!["Used"] = false;
                    await firestore
                        .collection('Building')
                        .doc(element)
                        .set(Datainfo[element]!);
                  } else {
                    print('asd');
                  }
                }

                FocusScope.of(context).unfocus();

                var imsitime = DateTime.now().toUtc().add(Duration(hours: 9));
                var nowDay =
                    DateTime(imsitime.year, imsitime.month, imsitime.day, 0, 0);
                DateTime? dealtime = await showDatePicker(
                  initialDate: nowDay,
                  context: context,
                  firstDate: nowDay,
                  //시작일
                  lastDate: DateTime(
                      nowDay.year + 99, nowDay.month, nowDay.day, 0, 0),
                  //마지막일
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.dark(), //다크 테마
                      child: child!,
                    );
                  },
                );

                if (dealtime == null) return;
                DateTime? timedeal = await GetDate(dealtime);
                if (timedeal == null) return;

                await FirebaseFirestore.instance
                    .collection('RoomOut')
                    .doc(FirebaseAuth.instance.currentUser!.email.toString())
                    .set({'퇴실신청일': timedeal});
              },
              child: Row(
                children: [Icon(Icons.note), Text('퇴실신청')],
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
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                bool? isture = await FailOutUser();
                if (isture == null) return;
                if (isture) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SingIn()),
                      (route) => false);
                  OutUser();
                } else {
                  return;
                }
              },
              child: Row(
                children: [Icon(Icons.outbond), Text('회원탈퇴')],
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
          ],
        ),
      ]),
    );
  }

  void OutUser() async {
    try {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .delete();
      await FirebaseFirestore.instance
          .collection('Bill')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .delete();
      await FirebaseAuth.instance.currentUser!.delete();
      await FirebaseFirestore.instance
          .collection('chat')
          .doc('chat')
          .collection(FirebaseAuth.instance.currentUser!.email.toString())
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('chat')
              .doc('chat')
              .collection(FirebaseAuth.instance.currentUser!.email.toString())
              .doc(element.id)
              .delete();
        });
      });
    } catch (e) {
      print('실패');
    }
  }

  Future<bool?> FailOutUser() {
    Future<bool?> TF;
    TF = showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xff161619),
            title: Text(
              '정말 탈퇴하시겠습니까?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    try {
                      var info = await firestore.collection('Building').get();
                      info.docs.forEach((element) {
                        Datainfo[element.id] = (element.data());
                      });

                      for (var element in Datainfo.keys) {
                        if (Datainfo[element]!["Used"] == true) {
                          Datainfo[element]!["Used"] = false;
                          await firestore
                              .collection('Building')
                              .doc(element)
                              .set(Datainfo[element]!);
                        } else {
                          print('asd');
                        }
                      }
                      Navigator.pop(context, true);
                    } catch (e) {}
                  },
                  child: Text('네')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('아니요')),
            ],
          );
        });
    return TF;
  }

  String Addre = '';
  @override
  Widget build(BuildContext context) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 210, 217, 221),
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
            '마이페이지',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 230, 235, 238),
          centerTitle: true,
          elevation: 6,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('User')
                .doc(FirebaseAuth.instance.currentUser!.email.toString())
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {}
              if (snapshot.data == null) {
                return Text('');
              }
              if (!snapshot.hasData) {
                return new Text("");
              }
              try {
                Map<String, dynamic> userDocument =
                    snapshot.data!.data() as Map<String, dynamic>;
                Timestamp dayss = userDocument['계약만료일'];
                String Username = userDocument['이름'];

                String UserPn = userDocument['전화번호'];
                Addre = userDocument['건물명'];
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical, //화면 스크롤바
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      buildMypagehome(dayss), //메인페이지
                      SizedBox(height: 10),
                      buildTwoBox(Username, UserPn), //하얀색 두번째 박스
                      SizedBox(height: 10),
                      buildThreeBox(dayss), //하얀색 세번째 박스
                      SizedBox(height: 40),
                      buildFourBox() //하얀색 네번째 박스
                    ],
                  ),
                );
              } catch (e) {
                return Text("");
              }
            }),
      ),
    );
  }
}
