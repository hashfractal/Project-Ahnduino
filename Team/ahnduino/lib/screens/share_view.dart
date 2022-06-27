import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListOnTapPageImageView extends StatefulWidget {
  ListOnTapPageImageView(
      {Key? key,
      required this.image,
      required this.startpages,
      required this.currentPages})
      : super(key: key);

  //부모 위젯에게 전달 받은 arguments 클래스
  final List<String> image;
  final int startpages;
  int currentPages;

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
                  '업로드 이미지 ${widget.currentPages}/${widget.image.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          backgroundColor: const Color.fromRGBO(0, 143, 94, 1.0),
        ),
        body: PageView.builder(
            controller: PageController(initialPage: widget.startpages),
            itemCount: widget.image.length,
            onPageChanged: (page) {
              setState(() {
                widget.currentPages = page + 1;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return CachedNetworkImage(
                imageUrl: widget.image[index],
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
class ShareView extends StatefulWidget {
  ShareView(
      {Key? key,
      required this.docsList,
      required this.index,
      required this.title,
      required this.text,
      required this.currentPage,
      required this.Docid})
      : super(key: key);

  //부모 위젯에게 전달 받은 arguments 클래스
  final QueryDocumentSnapshot<Map<String, dynamic>> docsList;
  final String title;
  final String text;
  final int index;
  int currentPage;
  String Docid = '';

  @override
  State<ShareView> createState() => _ShareViewState();
}

class _ShareViewState extends State<ShareView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final TextEditingController titlecontroller = TextEditingController();
    final TextEditingController textcontroller = TextEditingController();
    titlecontroller.text = widget.title;
    textcontroller.text = widget.text;
    List<String> urlList = returnImageUrl(widget.docsList);

    List<dynamic> LikedUser = [];
    List<dynamic> UnLikedUser = [];

    Future<void> likeSend() async {
      if (LikedUser.contains(
          FirebaseAuth.instance.currentUser!.email.toString())) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("이미 추천을 눌렸습니다."),
              backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
            ),
          );
        }
      } else {
        LikedUser.add(FirebaseAuth.instance.currentUser!.email.toString());
        await FirebaseFirestore.instance
            .collection('share')
            .doc(widget.Docid)
            .update({
          "Likes": FieldValue.increment(1),
          "Liked": LikedUser,
        });
      }
    }

    Future<void> UnlikeSend() async {
      if (UnLikedUser.contains(
          FirebaseAuth.instance.currentUser!.email.toString())) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("이미 비추천을 눌렸습니다."),
              backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
            ),
          );
        }
      } else {
        UnLikedUser.add(FirebaseAuth.instance.currentUser!.email.toString());
        await FirebaseFirestore.instance
            .collection('share')
            .doc(widget.Docid)
            .update({
          "UnLikes": FieldValue.increment(1),
          "UnLiked": UnLikedUser,
        });
      }
    }

    return Scaffold(
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
                  Icons.tips_and_updates_outlined,
                  color: Colors.black,
                ),
              ),
              Text(
                ('팁게시판'),
              ),
            ],
          ),
        ),
        titleTextStyle: const TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: (FontWeight.bold)),
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
                            border:
                                Border.all(color: Colors.black12, width: 3)),
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
                  ), //팁게시판 제목
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      height: 200,
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
                  ), //팁게시판 본문
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
                                                      image: urlList,
                                                      startpages: index,
                                                      currentPages:
                                                          index + 1)));
                                    }),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20), //모서리를 둥글게
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
                                              width: 100,
                                              height: 100,
                                              child: CircularProgressIndicator(
                                                  color: Colors.grey)))),
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
                  ), //팁게시판 사진
                ],
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('share')
                      .doc(widget.Docid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

                    Map<String, dynamic> doc =
                        snapshot.data!.data() as Map<String, dynamic>;
                    if (doc['LikedUser'] != null) {
                      LikedUser = doc['LikedUser'] as List<dynamic>;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(children: [
                        Text(
                          "추천 : " + doc['Likes'].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () async {
                              await likeSend();
                            },
                            icon: const Icon(
                              Icons.thumb_up,
                              color: Colors.redAccent,
                            )),
                      ]),
                    ); //추천 누르는곳
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('share')
                      .doc(widget.Docid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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

                    Map<String, dynamic> doc =
                        snapshot.data!.data() as Map<String, dynamic>;
                    if (doc['UnLikedUser'] != null) {
                      UnLikedUser = doc['UnLikedUser'] as List<dynamic>;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(children: [
                        Text(
                          "비추천 : " + doc['UnLikes'].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () async {
                              await UnlikeSend();
                            },
                            icon: const Icon(
                              Icons.thumb_down,
                              color: Colors.lightBlueAccent,
                            )),
                      ]),
                    ); //추천 누르는곳
                  })
            ]),
      ),
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
