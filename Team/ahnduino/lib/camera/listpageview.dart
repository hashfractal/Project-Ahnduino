import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'ListOnTapPageImageView.dart';

// ignore: must_be_immutable
class TileTapPageView extends StatefulWidget {
  TileTapPageView(
      {Key? key,
      required this.docsList,
      required this.index,
      required this.title,
      required this.currentPage})
      : super(key: key);

  //부모 위젯에게 전달 받은 arguments 클래스
  final List<dynamic> docsList;
  final String title;
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
            backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.assignment,
                  size: 40,
                  color: Colors.black,
                ),
                Text(
                  '${widget.title}  ${widget.currentPage}/${widget.docsList.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
        body: PageView.builder(
          controller: PageController(initialPage: widget.index),
          itemCount: widget.docsList.length,
          onPageChanged: (page) {
            setState(() {
              widget.currentPage = page + 1;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            final TextEditingController titlecontroller =
                TextEditingController();
            final TextEditingController textcontroller =
                TextEditingController();
            titlecontroller.text = '${widget.docsList[index]['Title']}';
            textcontroller.text = '${widget.docsList[index]['Text']}';
            List<String> urlList = returnImageUrl(widget.docsList[index]);
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 8.0, left: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(20),
                              //모서리를 둥글게
                              border: Border.all(
                                  color: const Color.fromRGBO(0, 0, 0, 0.2),
                                  width: 4)), //테두리
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          scale: 0.1,
                                          alignment: Alignment.bottomRight,
                                          image: AssetImage(
                                            'assets/fiximage.png',
                                          ))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                          text: TextSpan(
                                              text:
                                                  '${widget.docsList[index]['Date']}에 접수하신 내용입니다.\n빠른 시일 이내에 검토 후\n해결하겠습니다. 감사합니다.\n',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                              children: const [
                                            TextSpan(
                                                text: '예약이 진행되면 연락해드립니다.',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey,
                                                ))
                                          ])),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
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
                      ),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1, right: 10.0),
                        child: returnHopeTime(widget.docsList[index]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 60.0, top: 20),
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
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress
                                                              .totalSize !=
                                                          null
                                                      ? downloadProgress
                                                          .progress!
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
                    ]),
              ),
            );
          },
        ));
  }
}

Widget returnHopeTime(var docs) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (docs["hopeTime0"] != null) ...[
        // spread operators  []
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                "예약 희망 날짜 :",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        for (int i = 0; i < 3; i++) ...[
          if (docs["hopeTime$i"] != null) ...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(
                        color: const Color.fromRGBO(0, 0, 0, 0.2), width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Icon(
                        Icons.calendar_month,
                        size: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          returnDateAndTime(docs["hopeTime$i"].toString(), 0),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(
                        color: const Color.fromRGBO(0, 0, 0, 0.2), width: 3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Icon(
                        Icons.more_time,
                        size: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          returnDateAndTime(docs["hopeTime$i"].toString(), 1),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ])
          ]
        ]
      ],
      if (docs["isreserv"] == true) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              "예약 완료 날짜",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(
                      color: const Color.fromRGBO(0, 0, 0, 0.2), width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_month,
                      size: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        returnDateAndTime(docs["reserv"].toString(), 0),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  border: Border.all(
                      color: const Color.fromRGBO(0, 0, 0, 0.2), width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Icon(
                      Icons.calendar_month,
                      size: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        returnDateAndTime(docs["reserv"].toString(), 1),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ]
    ],
  );
}

String returnDateAndTime(String temp, int i) {
  List<String> list = temp.split('오');
  list[1] = '오' + list[1];

  return list[i];
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
