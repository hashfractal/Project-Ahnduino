import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ahnduino/Auto.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../singin/signin.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
// import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(token);
    await FirebaseFirestore.instance
        .collection('Worker')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .update({"token": token});
  }

  Future? myfutuer;
  int _index = 0;
  PageController _pagecontroller = PageController(viewportFraction: 0.6);
  String Setmsgs(int num) {
    DateTime nowtime = DateTime.now().toUtc().add(Duration(hours: 9));
    String nowtimeText = DateFormat('yy-MM-dd').format(nowtime);
    if (num == 0)
      return nowtimeText + " 스케쥴";
    else
      return nowtimeText + " 완료된 스케쥴";
  }

  getData(var _selected, int i) async {
    List<QuerySnapshot<Object?>> aa = [];
    if (i == 0) {
      String temp = _selected + " 스케쥴";
      await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul")
          .collection(temp)
          .orderBy('reservTime', descending: false)
          .get()
          .then((value) {
        aa.add(value);
      });
    } else {
      String temp = _selected + " 스케쥴완료";
      await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul")
          .collection(temp)
          .orderBy('reservTime', descending: false)
          .get()
          .then((value) {
        aa.add(value);
      });
    }
    return aa;
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

  Future UserDel(Timestamp day) async {
    DateTime mutime = day.toDate();
    DateTime theseday = DateTime.now().toUtc().add(Duration(hours: 9));
    if (mutime
            .difference(DateTime(theseday.year, theseday.month, theseday.day,
                mutime.hour, mutime.minute))
            .inDays >=
        0) {
      print('안녕하세요');
    }
  }

  Widget Setmsg(int num) {
    if (num == 0) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('MangerScagul')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('scaul')
              .doc('scaul')
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.data() == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text("스냅샷 데이터가 없습니다."),
                  )
                ],
              );
            }
            Map<String, dynamic> documentFields =
                snapshot.data?.data() as Map<String, dynamic>;
            documentFields =
                SplayTreeMap.from(documentFields, (a, b) => b.compareTo(a));
            DateTime nowtime = DateTime.now().toUtc();
            String nowtimeText = DateFormat('yyyy-MM-dd').format(nowtime);
            bool istrue = false;
            for (String key in documentFields.keys) {
              if (key == nowtimeText + " 스케쥴") {
                istrue = true;
              }
            }
            ;
            if (!istrue) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        "오늘 예약된 스케쥴은 없습니다.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )
                  ],
                ),
              );
            } else {
              myfutuer = getData(nowtimeText, 0);
              return FutureBuilder(
                future: myfutuer,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue)),
                    );
                  } else {
                    if (snapshot.data == null) {
                      return const Text('error');
                    }
                    var snaplist = snapshot.data as List<QuerySnapshot>;
                    List<dynamic> docList = [];
                    for (var element in snaplist) {
                      docList
                          .addAll(element.docs.map((e) => e.data()).toList());
                    }
                    // data loaded:.
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: docList.length + 1, //99 +1
                        itemBuilder: (context, index) {
                          if (index > docList.length - 1) {
                            return const SizedBox(
                              height: 100,
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: docList[index]["Title"] != "퇴실 신청"
                                    ? MycustomCard(docs: docList, index: index)
                                    : MycustomCardverThree(
                                        docs: docList, index: index),
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                },
              );
            }
          });
    } else {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('MangerScagul')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection('scaul')
              .doc('scaul')
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.data() == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text("스냅샷 데이터가 없습니다."),
                  )
                ],
              );
            }
            Map<String, dynamic> documentFields =
                snapshot.data?.data() as Map<String, dynamic>;
            documentFields =
                SplayTreeMap.from(documentFields, (a, b) => b.compareTo(a));
            DateTime nowtime = DateTime.now().toUtc().add(Duration(hours: 9));
            String nowtimeText = DateFormat('yyyy-MM-dd').format(nowtime);
            bool istrue = false;
            for (String key in documentFields.keys) {
              if (key == nowtimeText + " 스케쥴완료") {
                istrue = true;
              }
            }
            ;
            if (!istrue) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        "오늘 완료한 스케쥴은 없습니다.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    )
                  ],
                ),
              );
            } else {
              myfutuer = getData(nowtimeText, 1);
              return FutureBuilder(
                future: myfutuer,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue)),
                    );
                  } else {
                    if (snapshot.data == null) {
                      return const Text('error');
                    }
                    var snaplist = snapshot.data as List<QuerySnapshot>;
                    List<dynamic> docList = [];
                    for (var element in snaplist) {
                      docList
                          .addAll(element.docs.map((e) => e.data()).toList());
                    }
                    // data loaded:.
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: docList.length + 1, //99 +1
                        itemBuilder: (context, index) {
                          if (index > docList.length - 1) {
                            return const SizedBox(
                              height: 100,
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: MycustomCardverTwo(
                                    docs: docList, index: index),
                                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                },
              );
            }
          });
    }
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
              backgroundColor: Color.fromARGB(255, 224, 224, 224),
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromARGB(255, 230, 235, 238),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/worker.png',
                        width: layoutInfo.getWidth(6),
                        height: layoutInfo.getHeight(5),
                      ),
                      Text(
                        'Ahnduino',
                        style: TextStyle(
                            fontSize: 23.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                actions: [
                  IconButton(
                      onPressed: () {
                        try {
                          FirebaseAuth.instance.signOut().whenComplete(
                              () => //Navigator.push(
                                  // context, MaterialPageRoute(builder: (context) => SingIn())));
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SingIn()),
                                      (route) => false));
                        } catch (e) {}
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.green,
                        size: 35,
                      )),
                ],
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white.withOpacity(0.001),
                              Colors.white,
                              Colors.white,
                              Colors.white.withOpacity(0.001)
                            ],
                            stops: [0, 0.4, 0.6, 1],
                            tileMode: TileMode.mirror,
                          ).createShader(Offset.zero & bounds.size);
                        },
                        child: Container(
                          height: 50,
                          child: PageView.builder(
                            itemCount: 2,
                            controller: _pagecontroller,
                            onPageChanged: (int index) =>
                                setState(() => _index = index),
                            itemBuilder: (_, i) {
                              return Container(
                                child: Transform.scale(
                                  scale: i == _index ? 1 : 0.9,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _index = i;
                                        _pagecontroller.animateToPage(_index,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeOut);
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        Setmsgs(i),
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Setmsg(_index),
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                child: Row(children: <Widget>[
                  SizedBox(
                    width: layoutInfo.getWidth(13),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllscheduleMainpage()));
                      },
                      icon: Image.asset(
                        'assets/search.png',
                      ),
                      iconSize: 50,
                    ),
                  ),
                  SizedBox(
                    width: layoutInfo.getWidth(14),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Mainpage()),
                            (route) => false);
                      },
                      icon: Image.asset(
                        'assets/house.png',
                      ),
                      iconSize: 40,
                    ),
                  ),
                  SizedBox(
                    width: layoutInfo.getHeight(7),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/noti.png',
                      ),
                      iconSize: 40,
                    ),
                  )
                ]),
              ))),
    );
  }
}

class MycustomCardverThree extends StatelessWidget {
  const MycustomCardverThree(
      {Key? key, required this.docs, required this.index})
      : super(key: key);
  final List<dynamic> docs;
  final int index;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      "퇴실 신청 요청",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                          text: "주소: ",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text:
                                "${docs[index]['주소'].toString()}\n          (${docs[index]['건물명'].toString()})",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            )),
                        TextSpan(
                            text: '\n일시: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: docs[index]['reserv'].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ))
                            ])
                      ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.navigation, color: Colors.white),
                        Text(
                          "길찾기",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckinCheckOutPAge(
                                      docsList: docs[index],
                                    )));
                      },
                      child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: Text(
                            "퇴실\n확인",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MycustomCardverTwo extends StatelessWidget {
  const MycustomCardverTwo({Key? key, required this.docs, required this.index})
      : super(key: key);
  final List<dynamic> docs;
  final int index;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      docs[index]['Title'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                          text: "주소: ",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text:
                                "${docs[index]['주소'].toString()}\n          (${docs[index]['건물명'].toString()})",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            )),
                        TextSpan(
                            text: '\n일시: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: docs[index]['reserv'].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ))
                            ])
                      ])),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 30.0, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        docs[index]["checkoutimage0"] == null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TileTapPageViewTwo(
                                          docsList: docs[index],
                                          currentPage: index + 1,
                                        )))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckInCheckOutImage(
                                          docsList: docs[index],
                                        )));
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_sharp, color: Colors.white),
                            Text(
                              "상세 보기",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MycustomCard extends StatelessWidget {
  const MycustomCard({Key? key, required this.docs, required this.index})
      : super(key: key);
  final List<dynamic> docs;
  final int index;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      docs[index]['Title'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  RichText(
                      text: TextSpan(
                          text: "주소: ",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text:
                                "${docs[index]['주소'].toString()}\n          (${docs[index]['건물명'].toString()})",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            )),
                        TextSpan(
                            text: '\n일시: ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: docs[index]['reserv'].toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ))
                            ])
                      ])),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.navigation, color: Colors.white),
                        Text(
                          "길찾기",
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TileTapPageView(
                                      docsList: docs[index],
                                      index: index,
                                      currentPage: index + 1,
                                    )));
                      },
                      child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red,
                          ),
                          child: Text(
                            "스케쥴\n 완 료",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TileTapPageViewTwo extends StatefulWidget {
  TileTapPageViewTwo(
      {Key? key, required this.docsList, required this.currentPage})
      : super(key: key);

  //부모 위젯에게 전달 받은 arguments 클래스
  final docsList;
  int currentPage;
  int _index = 0;
  @override
  State<TileTapPageViewTwo> createState() => _TileTapPageViewTwoState();
}

class _TileTapPageViewTwoState extends State<TileTapPageViewTwo> {
  final ScrollController _scrollController = ScrollController();
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<String> returnImageUrl(var docs) {
    List<String> list = [];
    for (int i = 0; i < 5; i++) {
      if (docs['image$i'] != null) {
        list.add(docs['image$i']);
      } else {
        return list;
      }
    }
    return list;
  }

  String Setmsgs(int num) {
    if (num == 0)
      return '수리 요청 내용';
    else
      return '수리 완료 내용';
  }

  Widget Setmsg(
      int num, List<String> urlList, TextEditingController textcontroller) {
    if (num == 0) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 20.0, bottom: 10.0, right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //모서리를 둥글게
                    border: Border.all(color: Colors.black12, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 20.0, bottom: 5.0, top: 5),
                  child: Text(
                    '제목: ' + '${widget.docsList['Title']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 33,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, bottom: 10.0, right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //모서리를 둥글게
                    border: Border.all(color: Colors.black12, width: 3)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
                  child: RichText(
                      text: TextSpan(
                          text: "주 소   ",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                        TextSpan(
                            text:
                                "${widget.docsList['주소'].toString()} (${widget.docsList['건물명'].toString()})",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            )),
                        TextSpan(
                            text: '\n세입자  ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                  text: widget.docsList['userName'].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ))
                            ])
                      ])),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //모서리를 둥글게
                    border: Border.all(color: Colors.black12, width: 3)),
                child: Scrollbar(
                  controller: _scrollController,
                  child: TextField(
                      scrollController: _scrollController,
                      controller: textcontroller,
                      readOnly: true,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 20, left: 20, bottom: 15.0, top: 20),
              child: SizedBox(
                height: 160,
                child: urlList.isNotEmpty
                    ? GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 1,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        mainAxisSpacing: 10,
                        children: List.generate(
                          urlList.length,
                          (index) => CachedNetworkImage(
                            imageUrl: urlList[index],
                            imageBuilder: (context, imageProvider) => Container(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ListOnTapPageImageView(
                                                images: urlList,
                                                startpage: index,
                                                currentPage: index + 1)));
                              }),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(20), //모서리를 둥글게
                                border: Border.all(
                                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                                    width: 4),
                                color: Colors.white70,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                        value:
                                            downloadProgress.totalSize != null
                                                ? downloadProgress.progress!
                                                : null,
                                        color: Colors.grey)),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ).toList())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Container(
                              width: 160,
                              height: 160,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.no_photography,
                                      size: 40,
                                    ),
                                    Text(
                                      '업로드된 이미지가 없습니다.',
                                      textAlign: TextAlign.center,
                                    )
                                  ]),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                //모서리를 둥글게
                                border: Border.all(
                                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                                    width: 4),
                                color: Colors.white70,
                              ),
                            ),
                          ]),
              ),
            ),
          ]);
    } else {
      Timestamp tamp = widget.docsList["fixtime"];
      String uploadtime = DateFormat('yy-MM-dd HH:MM').format(tamp.toDate());
      List<String> fiximageURL = [];
      List<String> fixtext = [];
      TextEditingController controler = TextEditingController();
      if (widget.docsList["fixtext"] != null) {
        controler.text = widget.docsList["fixtext"];
      }
      for (int i = 0; i < 5; i++) {
        if (widget.docsList["fiximage${i}"] == null) {
          break;
        }
        fiximageURL.add(widget.docsList["fiximage${i}"].toString());
        if (widget.docsList["fixtext${i}"].toString().isEmpty) {
          fixtext.add("작성된 내용이 없습니다.");
        } else {
          fixtext.add(widget.docsList["fixtext${i}"].toString());
        }
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.docsList["fixtext"] == null
              ? [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 20.0.h, right: 8.0.w, left: 8.0.w),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                          border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.2),
                              width: 4)), //테두리
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, top: 2, left: 10.0),
                        child: Container(
                          width: 120,
                          height: 160,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  scale: 0.1,
                                  alignment: Alignment.centerRight,
                                  image: AssetImage(
                                    'assets/worker.png',
                                  ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text:
                                          '${uploadtime} 에 올리신\n고장에 대해서 수리완료 후\n올리신 수리완료사진과\n작성하신 내용입니다.\n',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      children: [
                                    TextSpan(
                                        text: '사진만 있을 수 있습니다.',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                        ))
                                  ])),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: fiximageURL.length + 1, //99 +1
                    itemBuilder: (context, index) {
                      if (index > fiximageURL.length - 1) {
                        return const SizedBox(
                          height: 100,
                        );
                      } else {
                        return Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UploadFixTextImageTextViewWidget(
                                  index: index,
                                  imagelist: fiximageURL,
                                  textfiled: fixtext[index],
                                ),
                              ]),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10),
                            child: Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                          )
                        ]);
                      }
                    },
                  ),
                ]
              : [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 20.0.h, right: 8.0.w, left: 8.0.w),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                          border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.2),
                              width: 4)), //테두리
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 10.0, top: 2, left: 10.0),
                        child: Container(
                          width: 120,
                          height: 160,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  scale: 0.1,
                                  alignment: Alignment.bottomRight,
                                  image: AssetImage(
                                    'assets/worker.png',
                                  ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text:
                                          '${uploadtime} 에 올리신\n사진을 찍을 필요가 없는\n단순 고장에 대해서\n작성하신 내용입니다.\n',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      children: [
                                    TextSpan(
                                        text: '사진은 없고 내용만 있습니다.',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                        ))
                                  ])),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          //모서리를 둥글게
                          border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 0.2),
                              width: 4)),
                      child: TextField(
                          controller: controler,
                          enabled: false,
                          maxLines: 17,
                          style: TextStyle(fontSize: 16.sp),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white70,
                              hintStyle: const TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w600))),
                    ),
                  )
                ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    PageController _pagecontroller = PageController(viewportFraction: 0.4);
    List<String> urlList = returnImageUrl(widget.docsList);
    final TextEditingController titlecontroller = TextEditingController();
    final TextEditingController textcontroller = TextEditingController();
    titlecontroller.text = '${widget.docsList['Title']}';
    textcontroller.text = '${widget.docsList['Text']}';
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    // TODO: implement build
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
            backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
            title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/worker.png',
                    width: layoutInfo.getWidth(6),
                    height: layoutInfo.getHeight(5),
                  ),
                  Text(
                    'Ahnduino',
                    style: TextStyle(
                        fontSize: 23.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white.withOpacity(0.001),
                              Colors.white,
                              Colors.white,
                              Colors.white.withOpacity(0.001)
                            ],
                            stops: [0, 0.4, 0.6, 1],
                            tileMode: TileMode.mirror,
                          ).createShader(Offset.zero & bounds.size);
                        },
                        child: Container(
                          height: 50,
                          child: PageView.builder(
                            itemCount: 2,
                            controller: _pagecontroller,
                            onPageChanged: (int index) =>
                                setState(() => widget._index = index),
                            itemBuilder: (_, i) {
                              return Container(
                                child: Transform.scale(
                                  scale: i == widget._index ? 1 : 0.8,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget._index = i;
                                        _pagecontroller.animateToPage(
                                            widget._index,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeOut);
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        Setmsgs(i),
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Setmsg(widget._index, urlList, textcontroller),
                  ]),
            ),
          )),
    );
  }
}

String returnDateAndTime(String temp, int i) {
  List<String> list = temp.split('오');
  list[1] = '오' + list[1];

  return list[i];
}

// ignore: must_be_immutable
class TileTapPageView extends StatefulWidget {
  TileTapPageView(
      {Key? key,
      required this.docsList,
      required this.index,
      required this.currentPage})
      : super(key: key);

  //부모 위젯에게 전달 받은 arguments 클래스
  final docsList;
  final int index;
  int currentPage;

  @override
  State<TileTapPageView> createState() => _TileTapPageViewState();
}

class _TileTapPageViewState extends State<TileTapPageView> {
  final ScrollController _scrollController = ScrollController();
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<String> returnImageUrl(var docs) {
    List<String> list = [];
    for (int i = 0; i < 5; i++) {
      if (docs['image$i'] != null) {
        list.add(docs['image$i']);
      } else {
        return list;
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    List<String> urlList = returnImageUrl(widget.docsList);
    final TextEditingController titlecontroller = TextEditingController();
    final TextEditingController textcontroller = TextEditingController();
    titlecontroller.text = '${widget.docsList['Title']}';
    textcontroller.text = '${widget.docsList['Text']}';
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    // TODO: implement build
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
            backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
            title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/worker.png',
                    width: layoutInfo.getWidth(6),
                    height: layoutInfo.getHeight(5),
                  ),
                  Text(
                    'Ahnduino',
                    style: TextStyle(
                        fontSize: 23.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 20.0, bottom: 10.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            //모서리를 둥글게
                            border:
                                Border.all(color: Colors.black12, width: 3)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 20.0, bottom: 5.0, top: 5),
                          child: Text(
                            '제목: ' + '${widget.docsList['Title']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 33,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, bottom: 10.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            //모서리를 둥글게
                            border:
                                Border.all(color: Colors.black12, width: 3)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 5, bottom: 5),
                          child: RichText(
                              text: TextSpan(
                                  text: "주 소   ",
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                TextSpan(
                                    text:
                                        "${widget.docsList['주소'].toString()} (${widget.docsList['건물명'].toString()})",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    )),
                                TextSpan(
                                    text: '\n세입자  ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: widget.docsList['userName']
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                          ))
                                    ])
                              ])),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        height: 400,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            //모서리를 둥글게
                            border:
                                Border.all(color: Colors.black12, width: 3)),
                        child: Scrollbar(
                          controller: _scrollController,
                          child: TextField(
                              scrollController: _scrollController,
                              controller: textcontroller,
                              readOnly: true,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white70,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 15.0, top: 20),
                      child: SizedBox(
                        height: 160,
                        child: urlList.isNotEmpty
                            ? GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                mainAxisSpacing: 10,
                                children: List.generate(
                                  urlList.length,
                                  (index) => CachedNetworkImage(
                                    imageUrl: urlList[index],
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ListOnTapPageImageView(
                                                        images: urlList,
                                                        startpage: index,
                                                        currentPage:
                                                            index + 1)));
                                      }),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            20), //모서리를 둥글게
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.2),
                                            width: 4),
                                        color: Colors.white70,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        Center(
                                            child: CircularProgressIndicator(
                                                value: downloadProgress
                                                            .totalSize !=
                                                        null
                                                    ? downloadProgress.progress!
                                                    : null,
                                                color: Colors.grey)),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ).toList())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Container(
                                      width: 160,
                                      height: 160,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.no_photography,
                                              size: 40,
                                            ),
                                            Text(
                                              '업로드된 이미지가 없습니다.',
                                              textAlign: TextAlign.center,
                                            )
                                          ]),
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        //모서리를 둥글게
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                0, 0, 0, 0.2),
                                            width: 4),
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 30),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(150.w, 40.h)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
                                //syleForm에서  primarycolor랑 같다.
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    // disabled : onpressed가 null일때 , pressed : 클릭됐을때
                                    return Colors.black26;
                                  } else {
                                    return Color.fromRGBO(0, 143, 94, 1.0);
                                  }
                                }),
                                textStyle:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    // disabled : onpressed가 null일때 , pressed : 클릭됐을때
                                    return TextStyle(
                                        fontSize: 20.sp,
                                        letterSpacing: 20.w,
                                        color: Colors.black12);
                                  } else {
                                    return TextStyle(
                                        fontSize: 20.sp,
                                        letterSpacing: 20.w,
                                        color: Colors.white);
                                  }
                                }),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UploadFixFailWidget(
                                              docs: widget.docsList,
                                            )));
                              },
                              child: const Text('보 류'),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    Size(150.w, 40.h)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
                                //syleForm에서  primarycolor랑 같다.
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    // disabled : onpressed가 null일때 , pressed : 클릭됐을때
                                    return Colors.black26;
                                  } else {
                                    return Color.fromRGBO(0, 143, 94, 1.0);
                                  }
                                }),
                                textStyle:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    // disabled : onpressed가 null일때 , pressed : 클릭됐을때
                                    return TextStyle(
                                        fontSize: 20.sp,
                                        letterSpacing: 20.w,
                                        color: Colors.black12);
                                  } else {
                                    return TextStyle(
                                        fontSize: 20.sp,
                                        letterSpacing: 20.w,
                                        color: Colors.white);
                                  }
                                }),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UploadFixSuccWidget(
                                              docs: widget.docsList,
                                            )));
                              },
                              child: const Text('완 료'),
                            ),
                          ]),
                    )
                  ]),
            ),
          )),
    );
  }
}

// ignore: must_be_immutable
class UploadFixSuccWidget extends StatefulWidget {
  UploadFixSuccWidget({Key? key, required this.docs}) : super(key: key);
  Map<String, dynamic> docs;

  @override
  _UploadFixSuccWidgetState createState() => _UploadFixSuccWidgetState();
}

class _UploadFixSuccWidgetState extends State<UploadFixSuccWidget> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool showSpinner = false;
  String _error = 'No Error Detected';
  List<AssetEntity>? assetList = [];
  Map<String, UploadFixTextImageTextWidget> CkInNOutMap = {};
  var _selected = '고 장';
  String fixtext = '';
  final List<String> items = [
    '고 장',
    '단순 고장',
  ];
  // 단순 고장 , 고 장
  Widget makeMyCKinoutWidget(int index) {
    //if(CkInNOutMap[''])
    if (CkInNOutMap[assetList![index].id.toString()] == null) {
      CkInNOutMap[assetList![index].id.toString()] =
          UploadFixTextImageTextWidget(index: index, imagelist: assetList);
    } else if (CkInNOutMap[assetList![index].id.toString()] != null) {
      CkInNOutMap[assetList![index].id.toString()]!.index = index;
      CkInNOutMap[assetList![index].id.toString()]!.imagelist = assetList;
    }

    return CkInNOutMap[assetList![index].id.toString()]!;
  }

  Future<bool> _getStatuses() async {
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        await Permission.accessMediaLocation.isGranted) {
      return Future.value(true);
    }
    if (await Permission.camera.isDenied &&
        await Permission.storage.isDenied &&
        await Permission.accessMediaLocation.isDenied) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("권한 설정을 확인해주세요."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: Text('설정하기')),
              ],
            );
          });
      print("permission denied by user");
      return Future.value(false);
    }
    return Future.value(false);
  }

  loadAssets() async {
    if (_getStatuses() == Future.value(false)) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '수리 완료 사진 업로드',
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Divider(
                    height: 0,
                    thickness: 2,
                  ),
                ),
                TextButton.icon(
                  // <-- TextButton
                  onPressed: () async {
                    assetList = await AssetPicker.pickAssets(
                      context,
                      pickerConfig: AssetPickerConfig(
                        pageSize: 40,
                        gridCount: 4,
                        canclereturn: assetList,
                        textDelegate: const EnglishAssetPickerTextDelegate(),
                        selectedAssets: assetList,
                        maxAssets: 5,
                        requestType: RequestType.image,
                        themeColor: const Color.fromRGBO(0, 143, 94, 1.0),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.image,
                    color: Color.fromRGBO(0, 143, 94, 1.0),
                    size: 24.0,
                  ),
                  label: Text(
                    '갤러리에서 선택하기',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 143, 94, 1.0),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                TextButton.icon(
                  // <-- TextButton
                  onPressed: () async {
                    if (assetList!.length >= 5) {
                      return;
                    }
                    final AssetEntity? entity =
                        await CameraPicker.pickFromCamera(
                      context,
                      pickerConfig: CameraPickerConfig(
                        textDelegate: EnglishCameraPickerTextDelegate(),
                      ),
                    );
                    if (entity != null) {
                      assetList?.add(entity);
                    }
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Color.fromRGBO(0, 143, 94, 1.0),
                    size: 24.0,
                  ),
                  label: Text(
                    '카메라로 촬영하기',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 143, 94, 1.0),
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
    FocusScope.of(context).unfocus();
    String error = '사진 선택이 완료되었습니다.';
    if (!mounted) return;
    if (assetList == null) {
      assetList = [];
      return;
    }
    setState(() {
      assetList;
      _error = error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error.toString()),
          backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
        ),
      );
    });
  }

  sendFire() async {
    try {
      DateTime nowtime = DateTime.now().toUtc().add(Duration(hours: 9));
      String nowtimeText = DateFormat('yyyy-MM-dd').format(nowtime);
      String temp = nowtimeText + " 스케쥴";
      String temp2 = nowtimeText + " 스케쥴완료";
      final refImage = FirebaseStorage.instance
          .ref()
          .child(widget.docs["UID"])
          .child("ResponsAndReQuest")
          .child(widget.docs["Date"] + " 수리완료")
          .child(widget.docs["DocID"]);

      final Userreference = await FirebaseFirestore.instance
          .collection('ResponsAndReQuest')
          .doc(widget.docs["UID"])
          .collection("Request")
          .doc("Request")
          .collection(widget.docs["Date"] + " 수리완료");
      if (_selected == "고 장") {
        for (int index = 0; index < assetList!.length; index++) {
          String text = CkInNOutMap[assetList![index].id.toString()]!.textfiled;
          String uniqueID = DateFormat('yyyyMMddHHmmss')
              .format(DateTime.now().toUtc().add(const Duration(hours: 9)));
          File? F = await assetList![index].file;
          if (F == null) {
            throw '업로드 하는데에 문제가 생겼습니다.';
          }
          await refImage.child(uniqueID + '.png').putFile(F);
          final url = await refImage.child(uniqueID + '.png').getDownloadURL();
          widget.docs["solved"] = true;
          widget.docs["fiximage${index}"] = url;
          widget.docs["fixtext${index}"] = text;
          widget.docs["fixtime"] = DateTime.now();
        }
      } else {
        widget.docs["solved"] = true;
        widget.docs["fixtext"] = fixtext;
        widget.docs["fixtime"] = DateTime.now();
      }

      await Userreference.doc(widget.docs["DocID"]).set(widget.docs);

      await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul")
          .collection(temp2)
          .doc(widget.docs["DocID"])
          .set(widget.docs);

      var setdoc = await FirebaseFirestore.instance
          .collection('ResponsAndReQuest')
          .doc(widget.docs["UID"])
          .collection("Request")
          .doc("Request");
      await setdoc
          .collection(widget.docs["Date"] + "예약")
          .doc(widget.docs["DocID"])
          .delete();

      await setdoc.update({
        widget.docs["Date"] + " 수리완료": FieldValue.increment(1),
        widget.docs["Date"] + "예약": FieldValue.increment(-1)
      });
      var value = await setdoc.get();
      if (value.data() != null &&
          value.data()![widget.docs["Date"] + "예약"] == 0) {
        setdoc.update({widget.docs["Date"] + "예약": FieldValue.delete()});
      }

      await FirebaseFirestore.instance
          .collection('ResponsAndReQuest')
          .doc(widget.docs["UID"])
          .collection("Request")
          .doc("Request")
          .collection(widget.docs["Date"] + " 수리예정")
          .doc(widget.docs["DocID"])
          .delete();

      await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul")
          .collection(temp)
          .doc(widget.docs["DocID"])
          .delete();

      setdoc = await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul");
      await setdoc.update({
        temp2: FieldValue.increment(1),
        temp: FieldValue.increment(-1),
      });
      value = await setdoc.get();
      if (value.data() != null && value.data()![temp] == 0) {
        setdoc.update({temp: FieldValue.delete()});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_photo_alternate,
              size: 40,
              color: Colors.black,
            ),
            Text(
              '수리 완료 사진 업로드',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(300.w, 40.h)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
          //syleForm에서  primarycolor랑 같다.
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return Colors.black26;
            } else {
              return Color.fromRGBO(0, 143, 94, 1.0);
            }
          }),
          textStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20.w, color: Colors.black12);
            } else {
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20.w, color: Colors.white);
            }
          }),
        ),
        onPressed: _selected == "고 장"
            ? assetList!.isEmpty
                ? null
                : () async {
                    setState(() {
                      showSpinner = true;
                    });
                    await sendFire();
                    setState(() {
                      showSpinner = false;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Mainpage()),
                          (route) => false);
                    });
                  }
            : fixtext.isEmpty
                ? null
                : () async {
                    setState(() {
                      showSpinner = true;
                    });
                    await sendFire();
                    setState(() {
                      showSpinner = false;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Mainpage()),
                          (route) => false);
                    });
                  },
        child: const Text('완 료'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0.h, right: 8.0.w, left: 8.0.w),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                            border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, 0.2),
                                width: 4)), //테두리
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 2, left: 10.0),
                          child: Container(
                            width: 120,
                            height: 160,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    scale: 0.1,
                                    alignment: Alignment.bottomRight,
                                    image: AssetImage(
                                      'assets/worker.png',
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                    text: const TextSpan(
                                        text:
                                            '수리 완료 했을 때의\n사진을 찍어서 특이사항이\n있을시에 작성해 주세요.\n',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                      TextSpan(
                                          text: '특이사항이 없을 시에\n사진만 올리시면 됩니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                          ))
                                    ])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              alignment: AlignmentDirectional.center,
                              buttonDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black26,
                                ),
                              ),
                              buttonPadding:
                                  const EdgeInsets.only(left: 14, right: 14),
                              buttonHeight: 40,
                              dropdownDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              dropdownMaxHeight: 200,
                              scrollbarRadius: const Radius.circular(40),
                              scrollbarThickness: 6,
                              scrollbarAlwaysShow: true,
                              value: _selected,
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  if (mounted) {
                                    _selected = value!;
                                    CkInNOutMap = {};
                                    assetList = [];
                                  }
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: _selected == '고 장'
                          ? [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10),
                                child: Column(
                                    children: List.generate(
                                  assetList!.length,
                                  (index) => Column(children: [
                                    Row(
                                      children: [
                                        makeMyCKinoutWidget(index),
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10),
                                      child: Divider(
                                        thickness: 2,
                                        color: Colors.black12,
                                      ),
                                    )
                                  ]),
                                ).toList()),
                              ),
                              Padding(
                                padding: CkInNOutMap.isNotEmpty &&
                                        assetList!.isNotEmpty
                                    ? const EdgeInsets.only(
                                        left: 10.0, right: 10, bottom: 60)
                                    : const EdgeInsets.only(top: 150),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100.w,
                                        height: 100.h,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // 가운데 정렬
                                            children: [
                                              IconButton(
                                                color: Colors.white30,
                                                iconSize: 50,
                                                icon: const Icon(
                                                  Icons.add,
                                                  color: Colors.black54,
                                                ),
                                                onPressed: () {
                                                  loadAssets();
                                                },
                                              ),
                                              Text(
                                                "${assetList!.length}/5",
                                                style: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 20.sp),
                                              )
                                            ]),
                                      ),
                                    ]),
                              )
                            ]
                          : [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, top: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      //모서리를 둥글게
                                      border: Border.all(
                                          color: Colors.black12, width: 3)),
                                  child: TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          fixtext = text;
                                        });
                                      },
                                      maxLines: 17,
                                      style: TextStyle(fontSize: 16.sp),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: const BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white70,
                                          hintText:
                                              '사진을 찍을 필요가 없는 단순 고장일 경우에는 간단한 내용을 작성해 주세요.',
                                          hintStyle: const TextStyle(
                                              color: Colors.black26,
                                              fontWeight: FontWeight.w600))),
                                ),
                              ),
                            ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class UploadFixTextImageTextWidget extends StatelessWidget {
  UploadFixTextImageTextWidget(
      {Key? key, required this.index, required this.imagelist})
      : super(key: key);

  List<AssetEntity>? imagelist;
  int index;
  String titlefield = '';
  String textfiled = '';
  TextEditingController textecontroler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      height: 170,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: MyCustumImageBox(
              images: imagelist,
              index: index,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: Column(
              children: [
                Container(
                  width: 230,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //모서리를 둥글게
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: TextField(
                      controller: textecontroler,
                      onChanged: (text) {
                        textfiled = text;
                      },
                      maxLines: 10,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 7, top: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          hintText:
                              '세입자가 다음에 스스로 해결 할 수 있는 해결법이나 특이사항등을 작성해 주세요.',
                          hintStyle: const TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class UploadFixTextImageTextViewWidget extends StatelessWidget {
  UploadFixTextImageTextViewWidget(
      {Key? key,
      required this.index,
      required this.imagelist,
      required this.textfiled})
      : super(key: key);
  List<String> imagelist;
  int index;
  String textfiled = '';
  TextEditingController textecontroler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textecontroler.text = textfiled;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      height: 170,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: CachedNetworkImage(
              imageUrl: imagelist[index],
              imageBuilder: (context, imageProvider) => Container(
                child: GestureDetector(onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListOnTapPageImageView(
                              images: imagelist,
                              startpage: index,
                              currentPage: index + 1)));
                }),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                  border: Border.all(
                      color: const Color.fromRGBO(0, 0, 0, 0.2), width: 4),
                  color: Colors.white70,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.totalSize != null
                              ? downloadProgress.progress!
                              : null,
                          color: Colors.grey)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: Column(
              children: [
                Container(
                  width: 225,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //모서리를 둥글게
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: TextField(
                      enabled: false,
                      controller: textecontroler,
                      onChanged: (text) {
                        textfiled = text;
                      },
                      maxLines: 10,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 7, top: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          hintStyle: const TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyCustumImageBox extends StatelessWidget {
  const MyCustumImageBox({Key? key, required this.images, required this.index})
      : super(key: key);
  final int index;
  final List<AssetEntity>? images;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Pageviewscreen(
                    images: images, startpage: index, currentPage: index + 1)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20), //모서리를 둥글게
            border:
                Border.all(color: const Color.fromRGBO(0, 0, 0, 0.2), width: 4),
            image: DecorationImage(
                image:
                    AssetEntityImageProvider(images![index], isOriginal: false),
                //File Image를 삽입
                fit: BoxFit.cover)),
      ),
    );
  }
}

// ignore: must_be_immutable
class ListOnTapPageImageView extends StatefulWidget {
  ListOnTapPageImageView(
      {Key? key,
      required this.images,
      required this.startpage,
      required this.currentPage})
      : super(key: key);

  //부모 위젯에게 전달 받은 arguments 클래스
  final List<String> images;
  final int startpage;
  int currentPage;

  @override
  State<ListOnTapPageImageView> createState() => _ListOnTapPageImageViewState();
}

class _ListOnTapPageImageViewState extends State<ListOnTapPageImageView> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.image,
                size: 40,
                color: Colors.black,
              ),
              Text(
                '업로드 이미지 ${widget.currentPage}/${widget.images.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
        ),
        body: PageView.builder(
            controller: PageController(initialPage: widget.startpage),
            itemCount: widget.images.length,
            onPageChanged: (page) {
              setState(() {
                widget.currentPage = page + 1;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return CachedNetworkImage(
                imageUrl: widget.images[index],
                imageBuilder: (context, imageProvider) => Center(
                    child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                )),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.totalSize != null
                                ? downloadProgress.progress!
                                : null,
                            color: Colors.grey)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            }));
  }
}

// ignore: must_be_immutable
class Pageviewscreen extends StatefulWidget {
  Pageviewscreen(
      {Key? key,
      required this.images,
      required this.startpage,
      required this.currentPage})
      : super(key: key);
  //부모 위젯에게 전달 받은 arguments 클래스
  final List<AssetEntity>? images;
  final int startpage;
  int currentPage;
  @override
  State<Pageviewscreen> createState() => _PageviewscreenState();
}

class _PageviewscreenState extends State<Pageviewscreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.image,
                size: 40,
                color: Colors.black,
              ),
              Text(
                '업로드 이미지 ${widget.currentPage}/${widget.images!.length}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        body: PageView.builder(
          controller: PageController(initialPage: widget.startpage),
          itemCount: widget.images!.length,
          onPageChanged: (page) {
            setState(() {
              widget.currentPage = page + 1;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Image(
                  image: AssetEntityImageProvider(widget.images![index],
                      isOriginal: false)),
            );
          },
        ));
  }
}

class AllscheduleMainpage extends StatefulWidget {
  const AllscheduleMainpage({Key? key}) : super(key: key);

  @override
  _AllscheduleMainpageState createState() => _AllscheduleMainpageState();
}

class _AllscheduleMainpageState extends State<AllscheduleMainpage> {
  Future? myfutuer;
  var _selected = 'All';
  late GlobalKey dropdownKey;
  PageController _pagecontroller = PageController(viewportFraction: 0.4);

  void initState() {
    super.initState();
    dropdownKey = GlobalKey();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getData(var _selected, List<String> userDocument) async {
    List<QuerySnapshot<Object?>> aa = [];
    if (_selected == 'All') {
      for (String element in userDocument) {
        if (element != 'All' && element.contains("스케쥴완료")) {
          await FirebaseFirestore.instance
              .collection('MangerScagul')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("scaul")
              .doc("scaul")
              .collection(element)
              .orderBy('reservTime', descending: false)
              .get()
              .then((value) {
            aa.add(value);
          });
        }
      }
    } else if (_selected != 'All') {
      String temp = _selected;
      await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul")
          .collection(temp)
          .orderBy('reservTime', descending: false)
          .get()
          .then((value) {
        aa.add(value);
      });
    }
    return aa;
  }

  @override
  Widget build(BuildContext context) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 224, 224, 224),
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(255, 230, 235, 238),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/worker.png',
                    width: layoutInfo.getWidth(6),
                    height: layoutInfo.getHeight(5),
                  ),
                  Text(
                    'Ahnduino',
                    style: TextStyle(
                        fontSize: 23.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
            actions: [
              IconButton(
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.signOut().whenComplete(
                          () => //Navigator.push(
                              // context, MaterialPageRoute(builder: (context) => SingIn())));
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SingIn()),
                                  (route) => false));
                    } catch (e) {}
                  },
                  icon: Icon(
                    Icons.person,
                    color: Colors.green,
                    size: 35,
                  )),
            ],
          ),
          body: SafeArea(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('MangerScagul')
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .collection('scaul')
                    .doc('scaul')
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.data() == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Center(
                          child: Text("스냅샷 데이터가 없습니다."),
                        )
                      ],
                    );
                  }

                  Map<String, dynamic> documentFields =
                      snapshot.data?.data() as Map<String, dynamic>;
                  documentFields = SplayTreeMap.from(
                      documentFields, (a, b) => a.compareTo(b));
                  myfutuer = getData(_selected, documentFields.keys.toList());

                  if (dropdownKey.currentContext != null &&
                      Navigator.canPop(dropdownKey.currentContext!)) {
                    Navigator.pop(dropdownKey.currentContext!);
                  }

                  return Column(children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyCustumDropdownButton(
                          dropdownKey: dropdownKey,
                          documentFields: documentFields,
                          selected: _selected,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selected = value;
                                myfutuer = getData(
                                    _selected, documentFields.keys.toList());
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('오류가 생겨 잠시 후 다시 시도해주세요.'),
                                backgroundColor: Colors.blue,
                              ));
                              return;
                            }
                          },
                        )),
                    Expanded(
                      child: FutureBuilder(
                        future: myfutuer,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                  backgroundColor: Colors.red,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue)),
                            );
                          } else {
                            if (snapshot.data == null) {
                              return const Text('error');
                            }
                            var snaplist = snapshot.data as List<QuerySnapshot>;
                            List<dynamic> docList = [];
                            for (var element in snaplist) {
                              docList.addAll(
                                  element.docs.map((e) => e.data()).toList());
                            }
                            docList.sort((a, b) {
                              Timestamp tamp = a["reservTime"];
                              Timestamp tamp2 = b["reservTime"];
                              return tamp.toDate().compareTo(tamp2.toDate());
                            });
                            // data loaded:.
                            return Scrollbar(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: docList.length + 1, //99 +1
                                itemBuilder: (context, index) {
                                  if (index > docList.length - 1) {
                                    return const SizedBox(
                                      height: 100,
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child:
                                            docList[index]["Title"] != "퇴실 신청"
                                                ? docList[index]["solved"]
                                                    ? MycustomCardverTwo(
                                                        docs: docList,
                                                        index: index)
                                                    : MycustomCard(
                                                        docs: docList,
                                                        index: index)
                                                : docList[index]["solved"]
                                                    ? MycustomCardverTwo(
                                                        docs: docList,
                                                        index: index)
                                                    : MycustomCardverThree(
                                                        docs: docList,
                                                        index: index),
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ]);
                }),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(children: <Widget>[
              SizedBox(
                width: layoutInfo.getWidth(13),
              ),
              Container(
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/chat.png',
                  ),
                  iconSize: 50,
                ),
              ),
              SizedBox(
                width: layoutInfo.getWidth(14),
              ),
              Container(
                child: IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Mainpage()),
                        (route) => false);
                  },
                  icon: Image.asset(
                    'assets/house.png',
                  ),
                  iconSize: 40,
                ),
              ),
              SizedBox(
                width: layoutInfo.getHeight(7),
              ),
              Container(
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/noti.png',
                  ),
                  iconSize: 40,
                ),
              )
            ]),
          )),
    );
  }
}

class MyCustumDropdownButton extends StatefulWidget {
  final GlobalKey<State<StatefulWidget>> dropdownKey;

  final Map<String, dynamic> documentFields;

  final String selected;

  final Function(String? value) onChanged;

  const MyCustumDropdownButton(
      {Key? key,
      required this.dropdownKey,
      required this.selected,
      required this.documentFields,
      required this.onChanged})
      : super(key: key);

  @override
  State<MyCustumDropdownButton> createState() => _MyCustumDropdownButtonState();
}

class _MyCustumDropdownButtonState extends State<MyCustumDropdownButton> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        alignment: AlignmentDirectional.center,
        buttonDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            width: 2,
            color: Colors.black26,
          ),
        ),
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonHeight: 40,
        dropdownDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        dropdownMaxHeight: 200,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        key: widget.dropdownKey,
        value: widget.selected,
        items: mycustumButton(widget.documentFields),
        onChanged: (value) {
          widget.onChanged(value);
        },
      ),
    );
  }
}

List<DropdownMenuItem<String>> mycustumButton(
    Map<String, dynamic> userDocument) {
  int? i = 0;
  List<DropdownMenuItem<String>> listall = [];
  // userDocument = SplayTreeMap.from(userDocument, (a, b) => b.compareTo(a));
  userDocument.forEach((key, value) {
    if (key.toString().contains("스케쥴완료")) {
      i = (i! + value!) as int?;
      String temp = key.toString() + '  (' + value.toString() + ')';
      listall.add(DropdownMenuItem(
          value: key.toString(),
          child: Text(
            temp,
            style: const TextStyle(fontWeight: FontWeight.w700),
          )));
    }
  });

  listall.add(DropdownMenuItem(
      value: "All",
      child: Text(
        "All  ($i)",
        style: const TextStyle(fontWeight: FontWeight.w700),
      )));

  return listall;
}

class UploadFixFailWidget extends StatefulWidget {
  UploadFixFailWidget({Key? key, required this.docs}) : super(key: key);
  Map<String, dynamic> docs;

  @override
  _UploadFixFailWidgetState createState() => _UploadFixFailWidgetState();
}

class _UploadFixFailWidgetState extends State<UploadFixFailWidget> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool showSpinner = false;
  String _error = 'No Error Detected';
  List<AssetEntity>? assetList = [];
  Map<String, UploadFixTextImageTextWidget> CkInNOutMap = {};
  String fixholdtext = '';
  // 단순 고장 , 고 장

  sendFire() async {
    try {
      DateTime nowtime = DateTime.now().toUtc().add(Duration(hours: 9));
      String nowtimeText = DateFormat('yyyy-MM-dd').format(nowtime);
      String temp = nowtimeText + " 스케쥴";
      String temp2 = nowtimeText + " 수리보류";
      final Userreference = await FirebaseFirestore.instance
          .collection('ResponsAndReQuest')
          .doc(widget.docs["UID"])
          .collection("Request")
          .doc("Request")
          .collection(widget.docs["Date"] + " 수리보류");

      widget.docs["fixholdtext"] = fixholdtext;
      widget.docs["fixholdtime"] = DateTime.now();

      await Userreference.doc(widget.docs["DocID"]).set(widget.docs);

      var setdoc = await FirebaseFirestore.instance
          .collection('ResponsAndReQuest')
          .doc(widget.docs["UID"])
          .collection("Request")
          .doc("Request");
      await setdoc
          .collection(widget.docs["Date"] + "예약")
          .doc(widget.docs["DocID"])
          .delete();

      await setdoc.update({
        widget.docs["Date"] + " 수리보류": FieldValue.increment(1),
        widget.docs["Date"] + "예약": FieldValue.increment(-1)
      });
      var value = await setdoc.get();
      if (value.data() != null &&
          value.data()![widget.docs["Date"] + "예약"] <= 0) {
        setdoc.update({widget.docs["Date"] + "예약": FieldValue.delete()});
      }

      await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul")
          .collection(temp)
          .doc(widget.docs["DocID"])
          .delete();

      setdoc = await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul");
      await setdoc.update({
        'All': FieldValue.increment(-1),
        temp: FieldValue.increment(-1),
      });
      value = await setdoc.get();
      if (value.data() != null && value.data()![temp] == 0) {
        setdoc.update({temp: FieldValue.delete()});
      }

      await FirebaseFirestore.instance
          .collection('FixHold')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("FixHold")
          .doc(widget.docs['DocID'])
          .set(widget.docs);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_photo_alternate,
              size: 40,
              color: Colors.black,
            ),
            Text(
              '수리 보류 내용 업로드',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(300.w, 40.h)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
          //syleForm에서  primarycolor랑 같다.
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return Colors.black26;
            } else {
              return Color.fromRGBO(0, 143, 94, 1.0);
            }
          }),
          textStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20.w, color: Colors.black12);
            } else {
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20.w, color: Colors.white);
            }
          }),
        ),
        onPressed: fixholdtext.isEmpty
            ? null
            : () async {
                setState(() {
                  showSpinner = true;
                });
                await sendFire();
                setState(() {
                  showSpinner = false;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Mainpage()),
                      (route) => false);
                });
              },
        child: const Text('완 료'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0.h, right: 8.0.w, left: 8.0.w),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                            border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, 0.2),
                                width: 4)), //테두리
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 2, left: 10.0),
                          child: Container(
                            width: 120,
                            height: 160,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    scale: 0.1,
                                    alignment: Alignment.bottomRight,
                                    image: AssetImage(
                                      'assets/worker.png',
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                    text: const TextSpan(
                                        text:
                                            '수리가 바로 불가능 한 경우\n수리 보류에 대한 이유을\n상세히 작성해 주세요.\n',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                      TextSpan(
                                          text:
                                              '수리에 필요한 용품이 있을 경우\n용품도 작성해 주세요.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                          ))
                                    ])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //모서리를 둥글게
                            border:
                                Border.all(color: Colors.black12, width: 3)),
                        child: TextField(
                            onChanged: (text) {
                              setState(() {
                                fixholdtext = text;
                              });
                            },
                            maxLines: 17,
                            style: TextStyle(fontSize: 16.sp),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white70,
                                hintText:
                                    "수리가 보류된 이유를 상세히 적어 주시고 혹시 필요한 용품이 없어서 수리를 못하시는 경우 수리에 필요한 용품을 작성해 주시기 바랍니다.",
                                hintStyle: const TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CheckinCheckOutPAge extends StatefulWidget {
  const CheckinCheckOutPAge({Key? key, this.docsList}) : super(key: key);
  final docsList;
  @override
  _CheckinCheckOutPAgeState createState() => _CheckinCheckOutPAgeState();
}

class _CheckinCheckOutPAgeState extends State<CheckinCheckOutPAge> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool showSpinner = false;
  String _error = 'No Error Detected';
  List<AssetEntity>? assetList = [];
  Map<String, MyCheckInCheckOutImageTextWidget> CkInNOutMap = {};

  Widget makeMyCKinoutWidget(int index) {
    //if(CkInNOutMap[''])
    if (CkInNOutMap[assetList![index].id.toString()] == null) {
      CkInNOutMap[assetList![index].id.toString()] =
          MyCheckInCheckOutImageTextWidget(index: index, imagelist: assetList);
    } else if (CkInNOutMap[assetList![index].id.toString()] != null) {
      CkInNOutMap[assetList![index].id.toString()]!.index = index;
      CkInNOutMap[assetList![index].id.toString()]!.imagelist = assetList;
    }

    return CkInNOutMap[assetList![index].id.toString()]!;
    /* var CheckInOutWidget =
        MyCheckInCheckOutImageTextWidget(index: index, imagelist: images);
    CKinoutWidgetList.add(CheckInOutWidget);
    return CheckInOutWidget;*/
  }

  Future<bool> _getStatuses() async {
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        await Permission.accessMediaLocation.isGranted) {
      return Future.value(true);
    }
    if (await Permission.camera.isDenied &&
        await Permission.storage.isDenied &&
        await Permission.accessMediaLocation.isDenied) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("권한 설정을 확인해주세요."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: Text('설정하기')),
              ],
            );
          });
      print("permission denied by user");
      return Future.value(false);
    }
    return Future.value(false);
  }

  loadAssets() async {
    if (_getStatuses() == Future.value(false)) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '입실 사진 업로드',
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Divider(
                    height: 0,
                    thickness: 2,
                  ),
                ),
                TextButton.icon(
                  // <-- TextButton
                  onPressed: () async {
                    assetList = await AssetPicker.pickAssets(
                      context,
                      pickerConfig: AssetPickerConfig(
                        pageSize: 40,
                        gridCount: 4,
                        canclereturn: assetList,
                        textDelegate: const EnglishAssetPickerTextDelegate(),
                        selectedAssets: assetList,
                        maxAssets: 100,
                        requestType: RequestType.image,
                        themeColor: const Color.fromRGBO(0, 143, 94, 1.0),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.image,
                    color: Color.fromRGBO(0, 143, 94, 1.0),
                    size: 24.0,
                  ),
                  label: Text(
                    '갤러리에서 선택하기',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 143, 94, 1.0),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                TextButton.icon(
                  // <-- TextButton
                  onPressed: () async {
                    final AssetEntity? entity =
                        await CameraPicker.pickFromCamera(
                      context,
                      pickerConfig: CameraPickerConfig(
                        textDelegate: EnglishCameraPickerTextDelegate(),
                      ),
                    );
                    if (entity != null) {
                      for (int i = 0; i < 90; i++) assetList?.add(entity);
                    }
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Color.fromRGBO(0, 143, 94, 1.0),
                    size: 24.0,
                  ),
                  label: Text(
                    '카메라로 촬영하기',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 143, 94, 1.0),
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
    FocusScope.of(context).unfocus();
    String error = '사진 선택이 완료되었습니다.';
    if (!mounted) return;
    if (assetList == null) return;
    setState(() {
      assetList;
      _error = error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error.toString()),
          backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
        ),
      );
    });
  }

  sendFire() async {
    try {
      DateTime nowtime = DateTime.now().toUtc().add(Duration(hours: 9));
      String nowtimeText = DateFormat('yyyy-MM-dd').format(nowtime);
      String temp = nowtimeText + " 스케쥴";
      String temp2 = nowtimeText + " 스케쥴완료";
      String docID = "퇴실";
      final refImage = FirebaseStorage.instance
          .ref()
          .child(widget.docsList['UID'])
          .child(docID);

      final Userreference = await FirebaseFirestore.instance
          .collection('CheckInCheckOut')
          .doc(widget.docsList['UID']);
      for (int index = 0; index < assetList!.length; index++) {
        String title = CkInNOutMap[assetList![index].id.toString()]!.titlefield;
        String text = CkInNOutMap[assetList![index].id.toString()]!.textfiled;
        String uniqueID = DateFormat('yyyyMMddHHmmss')
                .format(DateTime.now().toUtc().add(const Duration(hours: 9))) +
            title;
        File? F = await assetList![index].file;
        if (F == null) {
          throw '업로드 하는데에 문제가 생겼습니다.';
        }

        await refImage.child(uniqueID + '.png').putFile(F);
        final url = await refImage.child(uniqueID + '.png').getDownloadURL();

        await Userreference.collection(docID).doc(uniqueID).set({
          'docID': (uniqueID),
          'title': title,
          'text': text,
          'image': url,
          'time': DateTime.now().toUtc(),
        });
        widget.docsList['checkoutimage$index'] = url;
        if (title.isEmpty || title == "") {
          widget.docsList['checkouttitle$index'] = "작성한 내용이 없습니다.";
        } else {
          widget.docsList['checkouttitle$index'] = title;
        }
        if (text.isEmpty || text == "") {
          widget.docsList['checkouttext$index'] = "작성한 내용이 없습니다.";
        } else {
          widget.docsList['checkouttext$index'] = text;
        }
      }
      widget.docsList['solved'] = true;
      await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul")
          .collection(temp2)
          .doc(widget.docsList["DocID"])
          .set(widget.docsList);

      await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul")
          .collection(temp)
          .doc(widget.docsList["DocID"])
          .delete();

      var setdoc = await FirebaseFirestore.instance
          .collection('MangerScagul')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("scaul")
          .doc("scaul");
      await setdoc.update({
        temp2: FieldValue.increment(1),
        temp: FieldValue.increment(-1),
      });

      var value = await setdoc.get();

      if (value.data() != null && value.data()![temp] == 0) {
        setdoc.update({temp: FieldValue.delete()});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_photo_alternate,
              size: 40,
              color: Colors.black,
            ),
            Text(
              '사진 업로드',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(300.w, 40.h)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
          //syleForm에서  primarycolor랑 같다.
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return Colors.black26;
            } else {
              return Color.fromRGBO(0, 143, 94, 1.0);
            }
          }),
          textStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20.w, color: Colors.black12);
            } else {
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20.w, color: Colors.white);
            }
          }),
        ),
        onPressed: assetList!.isEmpty
            ? null
            : () async {
                setState(() {
                  showSpinner = true;
                });
                await sendFire();
                setState(() {
                  showSpinner = false;
                  Navigator.pop(context);
                });
              },
        child: const Text('완 료'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20.0.h, right: 8.0.w, left: 8.0.w),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                            border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, 0.2),
                                width: 4)), //테두리
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 2),
                          child: Container(
                            width: 120,
                            height: 160,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    scale: 0.1,
                                    alignment: Alignment.bottomRight,
                                    image: AssetImage(
                                      'assets/worker.png',
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                    text: const TextSpan(
                                        text:
                                            '퇴실 했을때의 사진을 찍어서\n위치랑 특이사항등을 \n작성해 주세요.\n',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                      TextSpan(
                                          text: '특이사항이 없을 경우 굳이\n작성하실 필요 없습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                          ))
                                    ])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                          children: List.generate(
                        assetList!.length,
                        (index) => Column(children: [
                          Row(
                            children: [
                              makeMyCKinoutWidget(index),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10),
                            child: Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                          )
                        ]),
                      ).toList()),
                    ),
                    Padding(
                      padding: CkInNOutMap.isNotEmpty
                          ? const EdgeInsets.only(
                              left: 10.0, right: 10, bottom: 60)
                          : const EdgeInsets.only(top: 150),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100.w,
                              height: 100.h,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // 가운데 정렬
                                  children: [
                                    IconButton(
                                      color: Colors.white30,
                                      iconSize: 50,
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        loadAssets();
                                      },
                                    ),
                                    Text(
                                      "${assetList!.length}/100",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 20.sp),
                                    )
                                  ]),
                            ),
                          ]),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class MyCheckInCheckOutImageTextWidget extends StatelessWidget {
  MyCheckInCheckOutImageTextWidget(
      {Key? key, required this.index, required this.imagelist})
      : super(key: key);

  List<AssetEntity>? imagelist;
  int index;
  String titlefield = '';
  String textfiled = '';
  TextEditingController titlecontroler = TextEditingController();
  TextEditingController textecontroler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      height: 170,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: MyCustumImageBox(
              images: imagelist,
              index: index,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Container(
                    width: 225,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        //모서리를 둥글게
                        border: Border.all(color: Colors.black12, width: 2)),
                    child: TextField(
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        controller: titlecontroler,
                        onChanged: (text) {
                          titlefield = text;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 8.w,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: '위치에 대해 작성해 주세요. 예) 화장실',
                            hintStyle: const TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.w600))),
                  ),
                ),
                Container(
                  width: 225,
                  height: 119,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //모서리를 둥글게
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: TextField(
                      controller: textecontroler,
                      onChanged: (text) {
                        textfiled = text;
                      },
                      maxLines: 10,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 7, top: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          hintText:
                              '사진에 대한 설명이나 특이사항등을 작성해 주세요.\n예)타일에 금이 가 있음',
                          hintStyle: const TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CheckInCheckOutImage extends StatefulWidget {
  CheckInCheckOutImage({Key? key, required this.docsList}) : super(key: key);
  final docsList;
  //부모 위젯에게 전달 받은 arguments 클래스
  @override
  State<CheckInCheckOutImage> createState() => _CheckInCheckOutImageState();
}

class _CheckInCheckOutImageState extends State<CheckInCheckOutImage> {
  List<Map<String, dynamic>> snaplist = [];
  List<Map<String, dynamic>> showlist = [];
  List<String> urlList = [];
  List<String> showurlList = [];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    List<String> resultsurl = [];
    // Refresh the UI
    setState(() {
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        showlist.clear();
        showurlList.clear();
      } else {
        results = snaplist
            .where((user) => user["title"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
        for (int i = 0; i < results.length; i++) {
          if (results[i]['image'] != null) {
            resultsurl.add(results[i]['image']);
          }
        }
        showurlList = resultsurl;
        showlist = results;
      }
    });
  }

  //snaplist = snapshot.data as List<Map<String, dynamic>>;

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 100; i++) {
      if (widget.docsList['checkoutimage$i'] == null) {
        break;
      }
      snaplist.add({
        "title": widget.docsList['checkouttitle$i'],
        "text": widget.docsList['checkouttext$i']
      });
      urlList.add(widget.docsList['checkoutimage$i']);
    }
    final PageController pageController = PageController(initialPage: 0);
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.assignment,
                size: 40,
                color: Colors.black,
              ),
              Text(
                '퇴실 사진보기',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              )
            ],
          )),
      body: Scrollbar(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                _runFilter(value);
              },
              controller: editingController,
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: showlist.isEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snaplist.length + 1, //99 +1
                    itemBuilder: (context, index) {
                      if (index > snaplist.length - 1) {
                        return const SizedBox(
                          height: 100,
                        );
                      } else {
                        return Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyCheckInCheckOutImageTextViewWidget(
                                  index: index,
                                  urlList: urlList,
                                  text: snaplist[index]['text'].toString(),
                                  title: snaplist[index]['title'].toString(),
                                ),
                              ]),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10),
                            child: Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                          )
                        ]);
                      }
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: showlist.length + 1, //99 +1
                    itemBuilder: (context, index) {
                      if (index > showlist.length - 1) {
                        return const SizedBox(
                          height: 100,
                        );
                      } else {
                        return Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyCheckInCheckOutImageTextViewWidget(
                                  index: index,
                                  urlList: showurlList,
                                  text: showlist[index]['text'].toString(),
                                  title: showlist[index]['title'].toString(),
                                ),
                              ]),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10),
                            child: Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                          )
                        ]);
                      }
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}

class MyCheckInCheckOutImageTextViewWidget extends StatelessWidget {
  MyCheckInCheckOutImageTextViewWidget(
      {Key? key,
      required this.urlList,
      required this.index,
      required this.title,
      required this.text})
      : super(key: key);
  int index;
  String text;
  String title;
  final TextEditingController titlecontroler = TextEditingController();
  final TextEditingController textecontroler = TextEditingController();
  List<String> urlList;

  @override
  Widget build(BuildContext context) {
    textecontroler.text = text;
    titlecontroler.text = title;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      height: 170,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: CachedNetworkImage(
              imageUrl: urlList[index],
              imageBuilder: (context, imageProvider) => Container(
                child: GestureDetector(onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListOnTapPageImageView(
                              images: urlList,
                              startpage: index,
                              currentPage: index + 1)));
                }),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                  border: Border.all(
                      color: const Color.fromRGBO(0, 0, 0, 0.2), width: 4),
                  color: Colors.white70,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.totalSize != null
                              ? downloadProgress.progress!
                              : null,
                          color: Colors.grey)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Container(
                    width: 225,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        //모서리를 둥글게
                        border: Border.all(color: Colors.black12, width: 2)),
                    child: TextField(
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        controller: titlecontroler,
                        maxLines: 1,
                        enabled: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 8.w,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                        )),
                  ),
                ),
                Container(
                  width: 225,
                  height: 119,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //모서리를 둥글게
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: TextField(
                      controller: textecontroler,
                      enabled: true,
                      maxLines: 10,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 7, top: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
