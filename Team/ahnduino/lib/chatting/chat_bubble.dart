import 'package:ahnduino/Auto.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../screens/board_view.dart';

import 'package:intl/intl.dart';

class ChatBubbles extends StatelessWidget {
  const ChatBubbles(this.message, this.isMe, this.time, this.isDate,
      {Key? key, required this.alllist})
      : super(key: key);
  final List<String> alllist;
  final String message;
  final bool isMe;
  final bool isDate;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return isDate
        ? KowanasLayout(
            data: layoutInfo,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.softLight,
                          color: isMe ? Colors.black : Colors.black,
                          borderRadius: BorderRadius.circular(16)),
                      child: SizedBox(
                        width: layoutInfo.getWidth(30),
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              message,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Row(
            // 날짜 표시 버블박스
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
                if (isMe)
                  Row(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(top: layoutInfo.getHeight(5.5)),
                        child: Text(
                          DateFormat('HH:mm').format(time.toDate()),
                          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: ChatBubble(
                          clipper:
                              ChatBubbleClipper8(type: BubbleType.sendBubble),
                          alignment: Alignment.topRight,
                          margin:
                              EdgeInsets.only(top: layoutInfo.getHeight(1.5)),
                          backGroundColor: Color.fromRGBO(0, 143, 94, 1.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: message.isNotEmpty
                                ? Text(
                                    message,
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.white),
                                  )
                                : Column(
                                    children: [
                                      for (int i = 0;
                                          i < alllist.length;
                                          i++) ...[
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        CachedNetworkImage(
                                          imageUrl: alllist[i],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  SizedBox(
                                            width: 200,
                                            height: 200,
                                            child: Container(
                                              child: GestureDetector(onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListOnTapPageImageView(
                                                                images: alllist,
                                                                startpage: i,
                                                                currentPage:
                                                                    i + 1)));
                                              }),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20), //모서리를 둥글게
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.2),
                                                    width: 4),
                                                color: Colors.white70,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
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
                                        )
                                      ]
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ), // 본인이 보낸 메시지 버블박스
                if (!isMe)
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: ChatBubble(
                          clipper: ChatBubbleClipper8(
                              type: BubbleType.receiverBubble),
                          backGroundColor: Color(0xffE7E7ED),
                          margin:
                              EdgeInsets.only(top: layoutInfo.getHeight(1.5)),
                          child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: message.isNotEmpty
                                  ? Text(
                                      message,
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.black),
                                    )
                                  : Column(
                                      children: [
                                        for (int i = 0;
                                            i < alllist.length;
                                            i++) ...[
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CachedNetworkImage(
                                            imageUrl: alllist[i],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    SizedBox(
                                              width: 200,
                                              height: 200,
                                              child: Container(
                                                child:
                                                    GestureDetector(onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ListOnTapPageImageView(
                                                                  images:
                                                                      alllist,
                                                                  startpage: i,
                                                                  currentPage:
                                                                      i + 1)));
                                                }),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), //모서리를 둥글게
                                                  border: Border.all(
                                                      color:
                                                          const Color.fromRGBO(
                                                              0, 0, 0, 0.2),
                                                      width: 4),
                                                  color: Colors.white70,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                                    child: CircularProgressIndicator(
                                                        value: downloadProgress
                                                                    .totalSize !=
                                                                null
                                                            ? downloadProgress
                                                                .progress!
                                                            : null,
                                                        color: Colors.grey)),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )
                                        ]
                                      ],
                                    )),
                        ),
                      ),
                      SizedBox(width: layoutInfo.getWidth(2.5)),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          DateFormat('HH:mm').format(time.toDate()),
                          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                        ),
                      ),
                    ],
                  ), // 관리자가 보낸 메시지 버블박스
              ]);
  }
}
