import 'package:ahnduino/screens/share_view.dart';
import 'package:ahnduino/screens/share_write.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'board_view.dart';

class sharescreen extends StatefulWidget {
  sharescreen({Key? key}) : super(key: key);
  var selected = '시간순';
  final _valueList = ['시간순', '추천순'];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> bordlist = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> ShowList = [];
  @override
  _sharescreenState createState() => _sharescreenState();
}

class _sharescreenState extends State<sharescreen> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('hi');
  User? loggedUser;
  int _index = 0;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> sharelist = [];
  var selected = '시간순';
  final _valueList = ['시간순', '추천순'];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> ShowList = [];

  void _runFilter(String enteredKeyword) {
    // Refresh the UI
    setState(() {
      if (enteredKeyword == '시간순') {
        if (ShowList.isNotEmpty) {
          ShowList.sort((a, b) => b.data()['time'].compareTo(a.data()["time"]));
          return;
        }
        ShowList = [...sharelist];
      } else {
        if (ShowList.isNotEmpty) {
          ShowList.sort(
              (a, b) => b.data()['Likes'].compareTo(a.data()["Likes"]));
          return;
        }
        ShowList = [...sharelist];
        ShowList.sort((a, b) => b.data()['Likes'].compareTo(a.data()["Likes"]));
      }
    });
  }

  void _runFilter2(String enteredKeyword) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> result = [];
    setState(() {
      if (enteredKeyword.isEmpty) {
        ShowList.clear();
        ShowList = [...sharelist];

        if (selected == "시간순") {
          return;
        } else {
          ShowList.sort(
              (a, b) => b.data()['Likes'].compareTo(a.data()["Likes"]));
          return;
        }
      } else {
        result = sharelist
            .where((user) => user
                .data()["title"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();

        if (selected == "시간순") {
          ShowList = result;
          return;
        } else {
          result.sort((a, b) => b.data()['Likes'].compareTo(a.data()["Likes"]));
          ShowList = result;
          return;
        }
      }
    });
  }

  TextEditingController editingController = TextEditingController();
  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
  }

  Widget Setwidget(int i) {
    return i == 0
        ? Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //모서리를 둥글게
                    border: Border.all(color: Colors.grey, width: 3)),
                child: TextField(
                  controller: editingController,
                  onChanged: (value) => _runFilter2(value),
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: '검색어를 입력해 주세요',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      prefixIcon: Container(
                          padding: EdgeInsets.all(15),
                          child: Icon(
                            Icons.search,
                            color: const Color.fromRGBO(0, 140, 90, 0.8),
                          ))),
                ),
              ),
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
                        value: selected,
                        items: _valueList.map(
                          (value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            selected = value!;
                            _runFilter(selected);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('share')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
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
                    sharelist = snapshot.data!.docs
                        as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

                    return Column(
                      children: [
                        ShowList.isEmpty
                            ? ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                                itemCount: sharelist.length,
                                itemBuilder: (context, index) {
                                  if (sharelist[index].data()['comment'] !=
                                      null) {}
                                  Timestamp time = sharelist[index]['time'];
                                  return Card(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShareView(
                                                  Docid: sharelist[index]
                                                      ['Docid'],
                                                  docsList: sharelist[index],
                                                  index: index,
                                                  title: sharelist[index]
                                                      ['title'],
                                                  currentPage: index + 1,
                                                  text: sharelist[index]
                                                      ['text'])),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: ListTile(
                                          visualDensity:
                                              const VisualDensity(vertical: 4),
                                          title:
                                              Text(sharelist[index]['title']),
                                          subtitle:
                                              Text(sharelist[index]['name']),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(DateFormat('yyyy-MM-dd')
                                                  .format(time.toDate())),
                                              Text("추천 수:" +
                                                  sharelist[index]['Likes']
                                                      .toString()),
                                              Text("비추천 수:" +
                                                  sharelist[index]['UnLikes']
                                                      .toString())
                                            ],
                                          ),
                                          leading:
                                              sharelist[index]
                                                          .data()['image'] !=
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
                                                              child:
                                                                  Image.network(
                                                                sharelist[index]
                                                                    ['image'],
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
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                                itemCount: ShowList.length,
                                itemBuilder: (context, index) {
                                  if (ShowList[index].data()['comment'] !=
                                      null) {}
                                  Timestamp time = ShowList[index]['time'];
                                  return Card(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ShareView(
                                                  Docid: ShowList[index]
                                                      ['Docid'],
                                                  docsList: ShowList[index],
                                                  index: index,
                                                  title: ShowList[index]
                                                      ['title'],
                                                  currentPage: index + 1,
                                                  text: ShowList[index]
                                                      ['text'])),
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: ListTile(
                                          visualDensity:
                                              const VisualDensity(vertical: 4),
                                          title: Text(ShowList[index]['title']),
                                          subtitle: Text('글쓴이: ' +
                                              ShowList[index]['name']),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(DateFormat('yyyy-MM-dd')
                                                  .format(time.toDate())),
                                              Text("추천 수:" +
                                                  ShowList[index]['Likes']
                                                      .toString()),
                                              Text("비추천 수:" +
                                                  ShowList[index]['UnLikes']
                                                      .toString())
                                            ],
                                          ),
                                          leading:
                                              ShowList[index].data()['image'] !=
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
                                                              child:
                                                                  Image.network(
                                                                ShowList[index]
                                                                    ['image'],
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
                      ],
                    );
                  })
            ],
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance.collection('board').snapshots(),
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
                  widget.ShowList.isEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: widget.bordlist.length,
                          itemBuilder: (context, index) {
                            List<dynamic> allcomment = [];
                            if (widget.bordlist[index].data()['comment'] !=
                                null) {
                              allcomment = widget.bordlist[index]
                                  .data()['comment'] as List<dynamic>;
                            }
                            Timestamp time = widget.bordlist[index]['time'];
                            return Card(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoardView(
                                            DocID: widget.bordlist[index]
                                                ['DocID'],
                                            docsList: widget.bordlist[index],
                                            index: index,
                                            title: widget.bordlist[index]
                                                ['title'],
                                            currentPage: index + 1,
                                            text: widget.bordlist[index]
                                                ['text'])),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: ListTile(
                                    visualDensity:
                                        const VisualDensity(vertical: 4),
                                    title:
                                        Text(widget.bordlist[index]['title']),
                                    subtitle: Text('글쓴이: ' +
                                        widget.bordlist[index]['name']),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(DateFormat('yyyy-MM-dd')
                                            .format(time.toDate())),
                                        Text("추천 수:" +
                                            widget.bordlist[index]['likes']
                                                .toString())
                                      ],
                                    ),
                                    leading: widget.bordlist[index]
                                                .data()['image0'] !=
                                            null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                                SizedBox(
                                                  width: 75,
                                                  height: 70,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Image.network(
                                                      widget.bordlist[index]
                                                          ['image0'],
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.grey,
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ])
                                        : SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.no_photography,
                                                  size: 40,
                                                ),
                                                Text(
                                                  'No Image',
                                                  style:
                                                      TextStyle(fontSize: 13),
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
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                          itemCount: widget.ShowList.length,
                          itemBuilder: (context, index) {
                            List<dynamic> allcomment = [];
                            if (widget.ShowList[index].data()['comment'] !=
                                null) {
                              allcomment = widget.ShowList[index]
                                  .data()['comment'] as List<dynamic>;
                            }
                            Timestamp time = widget.ShowList[index]['time'];
                            return Card(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoardView(
                                            DocID: widget.ShowList[index]
                                                ['DocID'],
                                            docsList: widget.ShowList[index],
                                            index: index,
                                            title: widget.ShowList[index]
                                                ['title'],
                                            currentPage: index + 1,
                                            text: widget.ShowList[index]
                                                ['text'])),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: ListTile(
                                    visualDensity:
                                        const VisualDensity(vertical: 4),
                                    title:
                                        Text(widget.ShowList[index]['title']),
                                    subtitle: Text('글쓴이: ' +
                                        widget.ShowList[index]['name']),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(DateFormat('yyyy-MM-dd')
                                            .format(time.toDate())),
                                        Text("추천 수:" +
                                            widget.ShowList[index]['likes']
                                                .toString())
                                      ],
                                    ),
                                    leading: widget.ShowList[index]
                                                .data()['image0'] !=
                                            null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                                SizedBox(
                                                  width: 75,
                                                  height: 70,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Image.network(
                                                      widget.ShowList[index]
                                                          ['image0'],
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.grey,
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ])
                                        : SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.no_photography,
                                                  size: 40,
                                                ),
                                                Text(
                                                  'No Image',
                                                  style:
                                                      TextStyle(fontSize: 13),
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
                ],
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    PageController _pagecontroller = PageController(viewportFraction: 0.4);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _index == 1
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 8.0, right: 8),
              child: SizedBox(
                width: 120,
                height: 50,
                child: FloatingActionButton(
                    backgroundColor: const Color.fromRGBO(0, 140, 90, 0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25), //모서리를 둥글게
                          border: Border.all(color: Colors.white, width: 2)),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.edit_outlined),
                              Padding(
                                padding: EdgeInsets.only(left: 3.0, bottom: 3),
                                child: Text(
                                  '글 쓰기',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ]),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UploadingPicture()));
                    }),
              ),
            ),
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
                Icons.list_alt,
                color: Colors.black,
              ),
              Text('게시판'),
            ],
          ),
        ),
        titleTextStyle: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: (FontWeight.bold)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
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
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeOut);
                              });
                            },
                            child: Center(
                              child: Text(
                                i == 0 ? "꿀팁 게시판" : "공지 사항",
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
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
            Setwidget(_index),
          ],
        ),
      ),
    );
  }
}
