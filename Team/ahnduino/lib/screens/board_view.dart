import 'package:ahnduino/Auto.dart';
import 'package:ahnduino/mainpage/mainpage.dart';
import 'package:ahnduino/screens/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.image,
                    size: 40,
                  ),
                ),
                Text(
                  '업로드 이미지 ${widget.currentPage}/${widget.images.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          backgroundColor: const Color.fromRGBO(0, 143, 94, 1.0),
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
                placeholder: (context, url) => const CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 1.5,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            }));
  }
}

// ignore: must_be_immutable
class BoardView extends StatefulWidget {
  BoardView(
      {Key? key,
      required this.docsList,
      required this.index,
      required this.title,
      required this.text,
      required this.currentPage,
      required this.DocID})
      : super(key: key);

  //부모 위젯에게 전달 받은 arguments 클래스
  final QueryDocumentSnapshot<Map<String, dynamic>> docsList;
  final String title;
  final String text;
  final int index;
  int currentPage;
  String DocID = '';

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final TextEditingController titlecontroller = TextEditingController();
    final TextEditingController textcontroller = TextEditingController();
    titlecontroller.text = widget.title;
    textcontroller.text = widget.text;
    List<String> urlList = returnImageUrl(widget.docsList);

    List<dynamic> likedUser = [];

    Future<void> likeSend() async {
      if (likedUser
          .contains(FirebaseAuth.instance.currentUser!.email.toString())) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("이미 추천을 눌렸습니다."),
              backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
            ),
          );
        }
      } else {
        likedUser.add(FirebaseAuth.instance.currentUser!.email.toString());
        await FirebaseFirestore.instance
            .collection('board')
            .doc(widget.DocID)
            .update({
          "likes": FieldValue.increment(1),
          "likedUser": likedUser,
        });
      }
    }

    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Scaffold(
          backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
          appBar: AppBar(
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
            title: Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 6.0, top: 7.0),
                    child: Icon(
                      Icons.edit_notifications_rounded,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    ('공지사항'),
                  ),
                ],
              ),
            ),
            titleTextStyle: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: (FontWeight.bold)),
          ),
          body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 10.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                //모서리를 둥글게
                                border: Border.all(
                                    color: Colors.black12, width: 3)),
                            child: TextField(
                                readOnly: true,
                                controller: titlecontroller,
                                enabled: true,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 10, top: 15),
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
                      ), //공지사항 제목
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          height: 200,
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
                                maxLines: 10,
                                style: const TextStyle(fontSize: 16),
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
                      ), //공지사항 본문
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10.0, top: 20),
                        child: SizedBox(
                          height: 120,
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
                                      placeholder: (context, url) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                20), //모서리를 둥글게
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    0, 0, 0, 0.2),
                                                width: 4),
                                            color: Colors.white70,
                                          ),
                                          child: const Center(
                                              child: SizedBox(
                                                  width: 35,
                                                  height: 35,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color:
                                                              Colors.grey)))),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ).toList())
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Container(
                                        width: 120,
                                        height: 120,
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                    ],
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('board')
                          .doc(widget.DocID)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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

                        Map<String, dynamic> doc =
                            snapshot.data!.data() as Map<String, dynamic>;
                        if (doc['likedUser'] != null) {
                          likedUser = doc['likedUser'] as List<dynamic>;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(children: [
                            Text(
                              "추천 : " + doc['likes'].toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            IconButton(
                                onPressed: () async {
                                  await likeSend();
                                },
                                icon: const Icon(Icons.thumb_up)),
                          ]),
                        );
                      })
                ]),
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

List<String> returnImageUrl(QueryDocumentSnapshot<Map<String, dynamic>> docs) {
  List<String> list = [];
  for (int i = 0; i < 5; i++) {
    if (docs.data()['image$i'] != null) {
      list.add(docs['image$i']);
    } else {
      return list;
    }
  }
  return list;
}
