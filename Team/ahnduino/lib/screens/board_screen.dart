import 'package:ahnduino/Auto.dart';
import 'package:ahnduino/mainpage/mainpage.dart';
import 'package:ahnduino/screens/chat_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'board_view.dart';

// ignore: must_be_immutable
class boardscreen extends StatefulWidget {
  boardscreen({Key? key}) : super(key: key);
  var selected = '시간순';
  final _valueList = ['시간순', '추천순'];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> bordlist = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> ShowList = [];

  @override
  _boardscreenState createState() => _boardscreenState();
}

class _boardscreenState extends State<boardscreen> {
  User? loggedUser;

  void _runFilter(String enteredKeyword) {
    // Refresh the UI
    setState(() {
      if (enteredKeyword == '시간순') {
        // if the search field is empty or only contains white-space, we'll display all users
        widget.ShowList.clear();
        widget.ShowList = [...widget.bordlist];
      } else {
        widget.ShowList.clear();
        widget.ShowList = [...widget.bordlist];
        widget.ShowList.sort(
            (a, b) => b.data()['likes'].compareTo(a.data()["likes"]));
      }
    });
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
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
              ),
            ]),
            backgroundColor: Color.fromRGBO(230, 235, 238, 1.0),
            title: Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_notifications_rounded,
                    color: Colors.black,
                  ),
                  Text('공지사항'),
                ],
              ),
            ),
            titleTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: (FontWeight.bold)),
            actions: [],
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('board')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data == null) {
                        return Column(
                          children: const [
                            Center(
                              child: Text("데이터가 없습니다."),
                            )
                          ],
                        );
                      }
                      widget.bordlist = snapshot.data!.docs
                          as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: DropdownButtonHideUnderline(
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
                                    buttonPadding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                    buttonHeight: 40,
                                    dropdownDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    dropdownMaxHeight: 200,
                                    scrollbarRadius: const Radius.circular(40),
                                    scrollbarThickness: 6,
                                    scrollbarAlwaysShow: true,
                                    value: widget.selected,
                                    items: widget._valueList.map(
                                      (value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        widget.selected = value!;
                                        _runFilter(widget.selected);
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                              child: widget.ShowList.isEmpty
                                  ? ListView.separated(
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const Divider();
                                      },
                                      itemCount: widget.bordlist.length,
                                      itemBuilder: (context, index) {
                                        // ignore: unused_local_variable
                                        List<dynamic> allcomment = [];
                                        if (widget.bordlist[index]
                                                .data()['comment'] !=
                                            null) {
                                          allcomment = widget.bordlist[index]
                                                  .data()['comment']
                                              as List<dynamic>;
                                        }
                                        Timestamp time =
                                            widget.bordlist[index]['time'];
                                        return Card(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BoardView(
                                                        DocID: widget
                                                                .bordlist[index]
                                                            ['DocID'],
                                                        docsList: widget
                                                            .bordlist[index],
                                                        index: index,
                                                        title: widget
                                                                .bordlist[index]
                                                            ['title'],
                                                        currentPage: index + 1,
                                                        text: widget
                                                                .bordlist[index]
                                                            ['text'])),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15),
                                              child: ListTile(
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: 4),
                                                title: Text(widget
                                                    .bordlist[index]['title']),
                                                subtitle: Text('글쓴이: ' +
                                                    widget.bordlist[index]
                                                        ['name']),
                                                trailing: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(time.toDate())),
                                                    Text("추천 수:" +
                                                        widget.bordlist[index]
                                                                ['likes']
                                                            .toString())
                                                  ],
                                                ),
                                                leading: widget.bordlist[index]
                                                            .data()['image0'] !=
                                                        null
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                            SizedBox(
                                                              width: 75,
                                                              height: 70,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20)),
                                                                child: Image
                                                                    .network(
                                                                  widget.bordlist[
                                                                          index]
                                                                      [
                                                                      'image0'],
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .grey,
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  },
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ])
                                                    : SizedBox(
                                                        width: 80,
                                                        height: 80,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .no_photography,
                                                              size: 40,
                                                            ),
                                                            Text(
                                                              'No Image',
                                                              style: TextStyle(
                                                                  fontSize: 13),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : ListView.separated(
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const Divider();
                                      },
                                      itemCount: widget.ShowList.length,
                                      itemBuilder: (context, index) {
                                        // ignore: unused_local_variable
                                        List<dynamic> allcomment = [];
                                        if (widget.ShowList[index]
                                                .data()['comment'] !=
                                            null) {
                                          allcomment = widget.ShowList[index]
                                                  .data()['comment']
                                              as List<dynamic>;
                                        }
                                        Timestamp time =
                                            widget.ShowList[index]['time'];
                                        return Card(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => BoardView(
                                                        DocID: widget
                                                                .ShowList[index]
                                                            ['DocID'],
                                                        docsList: widget
                                                            .ShowList[index],
                                                        index: index,
                                                        title: widget
                                                                .ShowList[index]
                                                            ['title'],
                                                        currentPage: index + 1,
                                                        text: widget
                                                                .ShowList[index]
                                                            ['text'])),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15),
                                              child: ListTile(
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: 4),
                                                title: Text(widget
                                                    .ShowList[index]['title']),
                                                subtitle: Text('글쓴이: ' +
                                                    widget.ShowList[index]
                                                        ['name']),
                                                trailing: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(time.toDate())),
                                                    Text("추천 수:" +
                                                        widget.ShowList[index]
                                                                ['likes']
                                                            .toString())
                                                  ],
                                                ),
                                                leading: widget.ShowList[index]
                                                            .data()['image0'] !=
                                                        null
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                            SizedBox(
                                                              width: 75,
                                                              height: 70,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20)),
                                                                child: Image
                                                                    .network(
                                                                  widget.ShowList[
                                                                          index]
                                                                      [
                                                                      'image0'],
                                                                  loadingBuilder: (BuildContext
                                                                          context,
                                                                      Widget
                                                                          child,
                                                                      ImageChunkEvent?
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        color: Colors
                                                                            .grey,
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  },
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ])
                                                    : SizedBox(
                                                        width: 80,
                                                        height: 80,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .no_photography,
                                                              size: 40,
                                                            ),
                                                            Text(
                                                              'No Image',
                                                              style: TextStyle(
                                                                  fontSize: 13),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ))
                        ],
                      );
                    }),
              )
            ],
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
