import 'package:ahnduino/mainpage/mainpage.dart';
import 'package:ahnduino/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'bootpay.dart';
import 'package:ahnduino/Auto.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? Month = null;

  String? PayTrue = "완납";
  String? PayFalse = "미납";
  //여기 선
  String? Aree = "";
  String? De = " ";
  String? Po = "";
  String? Re = "";
  String? Mo = "";
  bool Pa = false;
  String? Don = "";
  String? total = "";

  String Setmsg(int num) {
    if (num == 1)
      return '납부 완료';
    else if (num == 2)
      return '납부 하기';
    else
      return '연   체';
  }

  String Setmsgs(int num) {
    if (num == 1)
      return '완납';
    else if (num == 2)
      return '미납';
    else
      return '연체';
  }

  int? Bun = (DateTime.now().month.toInt() + 1);
  DateTime time = DateTime.now().toUtc().add(Duration(hours: 9));

  Widget buildYear() {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Column(
        children: <Widget>[
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Bill')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection('Month')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //연결상태
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Text('오류 발생')],
                  );
                }
                if (snapshot.data == null) {
                  return Column(
                    children: [
                      Center(
                        child: Text("데이터가 없습니다."), //에러
                      )
                    ],
                  );
                }

                Map<String, Map<String, dynamic>> docs = {};
                List<DropdownMenuItem<String>> month = [];

                snapshot.data!.docs.forEach((element) {
                  month.add(DropdownMenuItem(
                    value: element.id.toString(),
                    child: Text(element.id.toString()),
                  ));

                  docs[element.id] = element.data() as Map<String, dynamic>;

                  if (Month == null &&
                      (DateTime.now().month.toInt().toString() + '월' ==
                          element.id.toString())) {
                    Month = element.id.toString();
                    Mo = docs[Month]!['Money'].toString();
                    total = docs[Month]!['Totmoney'].toString();
                    Aree = docs[Month]!['Arrears'].toString();
                    De = docs[Month]!['Defmoney'].toString();
                    Po = docs[Month]!['Pomoney'].toString();
                    Re = docs[Month]!['Repair'].toString();
                    Pa = docs[Month]!['Pay'] as bool;
                  }

                  //중간에 있는값 받아오기
                  print(element.id); //month 몇월인지 테스트
                  print(element['Arrears']); //Arrears값 테스트
                });

                if (docs.length <= 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: layoutInfo.getHeight(20),
                      ),
                      Image.asset(
                        'assets/homegr.png',
                        width: 100.w,
                        height: 100.h,
                      ),
                      SizedBox(
                        height: layoutInfo.getHeight(3),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: layoutInfo.getWidth(25),
                          ),
                          Text(
                            '-관리비 관련 내용이 없습니다-',
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        '입주 후 한달 뒤에도 데이터가 없을 시 관리업체로 문의주세요',
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    ],
                  );
                }

                if (docs.length > 1) {
                  DateTime time =
                      DateTime.now().toUtc().add(Duration(hours: 9));
                  String PastMonth = (time.month.toInt() - 1).toString() + '월';
                  docs[PastMonth];

                  if (Timestamp.fromDate(time)
                          .compareTo(docs[PastMonth]!['Nab']) ==
                      1) {
                    docs[PastMonth]!['Ab'] = 3;
                    FirebaseFirestore.instance
                        .collection('Bill')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('Month')
                        .doc(PastMonth)
                        .update({
                      'Ab': docs[PastMonth]!['Ab'] = 3,
                    });
                  }
                }

                return Column(children: [
                  buildMonth(
                      ListAll: month,
                      onChaged: (value) {
                        setState(() {
                          Bun =
                              (int.parse(value.toString().replaceAll('월', '')) +
                                  1);
                          Month = value.toString();
                          total = docs[Month]!['Totmoney'].toString();
                          //------------------------------------------
                          Mo = docs[Month]!['Money'].toString();
                          Aree = docs[Month]!['Arrears'].toString();
                          De = docs[Month]!['Defmoney'].toString();
                          Po = docs[Month]!['Pomoney'].toString();
                          Re = docs[Month]!['Repair'].toString();
                          Pa = docs[Month]!['Pay'] as bool;
                        });
                      }),
                  SizedBox(height: layoutInfo.getHeight(2.5)),
                  buildGreenBox(docs[Month]!['Ab']),
                  SizedBox(height: layoutInfo.getHeight(2.5)),
                  buildGreyBox(docs[Month]!['Ab']),
                  //SizedBox(height: layoutInfo.getHeight(10)),
                ]);
              }),
        ],
      ),
    );
  }

  Widget buildMonth(
      {required List<DropdownMenuItem<String>> ListAll,
      required Function(dynamic value) onChaged}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            buttonDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
            ),
            buttonPadding: EdgeInsets.only(left: 14.w, right: 14.w),
            dropdownMaxHeight: 200.h,
            dropdownWidth: 200.w,
            offset: const Offset(-50, 0),
            scrollbarRadius: const Radius.circular(40),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            icon: Icon(Icons.keyboard_arrow_down),
            iconSize: 36,
            style: TextStyle(color: Colors.black, fontSize: 22.sp),
            value: Month,
            onChanged: (newValue) {
              onChaged(newValue);
            },
            items: ListAll.toList()),
      ),
    );
  }

  Widget buildGreenBox(int Ab) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        padding: EdgeInsets.all(15),
        height: layoutInfo.getHeight(23),
        width: MediaQuery.of(context).size.width - 40.w,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 143, 94),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: layoutInfo.getWidth(5),
                    height: layoutInfo.getHeight(5)),
                Text(
                  '2022년 ${Month}분',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: layoutInfo.getWidth(25), //납부완료랑 월분 사이
                ),
                buildWhiteBox(Ab),
              ],
            ),
            SizedBox(height: layoutInfo.getHeight(1.2)),
            Row(
              children: <Widget>[
                SizedBox(
                  width: layoutInfo.getWidth(7),
                ),
                RichText(
                  text: TextSpan(
                    text: '${total}',
                    style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: '원',
                        style: TextStyle(
                            letterSpacing: 5,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: layoutInfo.getHeight(1.2),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: layoutInfo.getWidth(5),
                  height: layoutInfo.getHeight(2),
                ),
                Text(
                  '납부마감일 ${Bun}월 30일',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildWhiteBox(int Ab) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        padding: EdgeInsets.only(
            left: layoutInfo.getWidth(1.1),
            top: layoutInfo.getHeight(1.1),
            right: layoutInfo.getWidth(1.1),
            bottom: layoutInfo.getHeight(0)),
        width: layoutInfo.getWidth(25),
        height: layoutInfo.getHeight(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(children: [
          Text(
            Setmsgs(Ab),
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 143, 94)),
          )
        ]),
      ),
    );
  }

  Widget buildGreyBox(int Ab) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        padding: EdgeInsets.only(top: layoutInfo.getHeight(2)),
        width: layoutInfo.getWidth(90),
        //height:  //layoutInfo.getHeight(60),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 226, 226, 226),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: layoutInfo.getWidth(5),
                ),
                Text(
                  '청구금액',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: layoutInfo.getHeight(3)),
            buildMiniBox(Ab),
          ],
        ),
      ),
    );
  }

  Widget buildMiniBox(int Ab) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        margin: EdgeInsets.only(bottom: 23),

        width: layoutInfo.getWidth(80),
        // height: double.infinity,
        // height: layoutInfo.getHeight(50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: layoutInfo.getWidth(5),
                height: layoutInfo.getHeight(1.2),
              ),
              Text(
                '이번 달 관리비',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(width: layoutInfo.getWidth(12)),
              RichText(
                text: TextSpan(
                  text: '${Mo}',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '원',
                      style: TextStyle(
                          letterSpacing: 5,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: layoutInfo.getWidth(100),
            child: Divider(
              color: Color.fromARGB(255, 217, 216, 216),
              thickness: 2,
            ),
          ),
          SizedBox(height: layoutInfo.getHeight(3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: layoutInfo.getWidth(5)),
                child: Text(
                  '당월부과액',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width: layoutInfo.getWidth(12)),
                  RichText(
                    text: TextSpan(
                      text: '${Mo}',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '원',
                          style: TextStyle(
                              letterSpacing: 5,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: layoutInfo.getHeight(1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: layoutInfo.getWidth(5)),
                child: Text(
                  '미납액',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width: layoutInfo.getWidth(12)),
                  RichText(
                    text: TextSpan(
                      text: '${De}',
                      style: TextStyle(
                        letterSpacing: 1,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '원',
                          style: TextStyle(
                              letterSpacing: 5,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: layoutInfo.getHeight(1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: layoutInfo.getWidth(5)),
                child: Text(
                  '납기후 연체금액',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${Aree}',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '원',
                      style: TextStyle(
                          letterSpacing: 5,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: layoutInfo.getHeight(1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: layoutInfo.getWidth(5)),
                child: Text(
                  '납기후 금액',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${Po}',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '원',
                      style: TextStyle(
                          letterSpacing: 5,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: layoutInfo.getHeight(1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: layoutInfo.getWidth(5)),
                child: Text(
                  '수리 금액',
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: '${Re}',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '원',
                      style: TextStyle(
                          letterSpacing: 5,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: layoutInfo.getHeight(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              buildgrBox(Ab),
              SizedBox(
                width: layoutInfo.getWidth(5),
                height: layoutInfo.getHeight(5),
              )
            ],
          )
        ]),
      ),
    );
  }

  Widget buildgrBox(int Ab) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Container(
        width: layoutInfo.getWidth(30),
        height: layoutInfo.getHeight(8),
        margin: EdgeInsets.only(bottom: 30),
        child: Column(children: <Widget>[
          SizedBox(width: layoutInfo.getWidth(10)),
          ElevatedButton(
            onPressed: Ab == 2
                ? () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecondRoute(
                                  total: total,
                                )));
                  }
                : null,
            child: Text(
              Setmsg(Ab),
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 63, 67, 65)),
            ),
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 159, 208, 248),
                elevation: 5.0,
                padding: EdgeInsets.only(
                    top: 5.h, left: 21.w, right: 21.w, bottom: 5.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
          resizeToAvoidBottomInset: false, //키보드 위에 떠있는 버튼 만드는 코드
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
              "관리비 고지서",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Color.fromARGB(255, 230, 235, 238),
            centerTitle: true,
            elevation: 0.0,
          ),

          //화면 스크롤바
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                buildYear(),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  },
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
