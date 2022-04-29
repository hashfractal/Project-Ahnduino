import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ahnduino/Auto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../singin/signin.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
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

  Map<String, dynamic> cert = Map<String, dynamic>();
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
                        'assets/homegr.png',
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
              body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: layoutInfo.getWidth(13),
                      top: layoutInfo.getHeight(10),
                    ),
                    child: Column(children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 3,
                                    offset: Offset(0, 3))
                              ]),
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/a.png',
                            ),
                            iconSize: 110,
                          ),
                        ),
                        SizedBox(
                          width: layoutInfo.getWidth(12),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 3,
                                    offset: Offset(0, 3))
                              ]),
                          child: IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/d.png',
                            ),
                            iconSize: 110,
                          ),
                        )
                      ]),
                      SizedBox(
                        height: layoutInfo.getHeight(5),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 3,
                                      offset: Offset(0, 3))
                                ]),
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/e.png',
                              ),
                              iconSize: 110,
                            ),
                          ),
                          SizedBox(
                            width: layoutInfo.getWidth(12),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 3,
                                      offset: Offset(0, 3))
                                ]),
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/f.png',
                              ),
                              iconSize: 110,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(5),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 3,
                                      offset: Offset(0, 3))
                                ]),
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/b.png',
                              ),
                              iconSize: 110,
                            ),
                          ),
                          SizedBox(
                            width: layoutInfo.getWidth(12),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 3,
                                      offset: Offset(0, 3))
                                ]),
                            child: IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/c.png',
                              ),
                              iconSize: 110,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(5),
                      )
                    ]),
                  ),
                ),
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
              ))),
    );
  }
}
