import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_7.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chattingtest/auto.dart';
import 'message.dart';
import 'package:intl/intl.dart';

class ChatBubbles extends StatelessWidget {


  const ChatBubbles(this.message, this.isMe,this.time, this.isDate, {Key? key}) : super(key: key);

  final String message;
  final bool isMe;
  final bool isDate;
  final Timestamp time;
  @override
  Widget build(BuildContext context) {
KowananasLayoutInfo layoutInfo = KowananasLayoutInfo(MediaQuery.of(context));
    return isDate? KowanasLayout(data: layoutInfo,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,5,0),
                child: DecoratedBox(
                  decoration: BoxDecoration(

                    color: isMe ? Color.fromRGBO(0, 143, 94, 1.0): Color.fromRGBO(0, 143, 94, 1.0),
                    borderRadius: BorderRadius.circular(16)
                  ),


                  child: SizedBox(

                    width: layoutInfo.getWidth(25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          message,
                          style: TextStyle( color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

          ],
        ),
      ),
    ) : Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
       if(isMe)
         Row(
           children: <Widget>[
             Padding(
               padding: EdgeInsets.only(top:layoutInfo.getHeight(5.5)),
               child: Text(DateFormat('yyyy-MM-dd').format(time.toDate()),

               style: TextStyle(fontSize: 10.sp ,color: Colors.grey),),
             ),
             const SizedBox(width: 5),
             Padding(
               padding: const EdgeInsets.fromLTRB(0,0,5,0),
               child: ChatBubble(

                 clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
                 alignment: Alignment.topRight,

                 margin: EdgeInsets.only(top: layoutInfo.getHeight(1.5)),
                 backGroundColor: Color.fromRGBO(0, 143, 94, 1.0),
                 child: Container(

                   constraints: BoxConstraints(
                     maxWidth: MediaQuery.of(context).size.width * 0.7,
                   ),
                   child: Text(

                    message,
                     style: TextStyle(fontSize: 16.sp,color: Colors.white),

                   ),
                 ),
               ),
             ),
           ],
         ),
        if(!isMe)
        Row(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.fromLTRB(5,0,0,0),
            child: ChatBubble(
              clipper: ChatBubbleClipper8(type: BubbleType.receiverBubble),
              backGroundColor: Color(0xffE7E7ED),

              margin: EdgeInsets.only(top: layoutInfo.getHeight(1.5)),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(

                  message,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),

                ),
              ),
            ),
          ), SizedBox(width:layoutInfo.getWidth(2.5)), Padding(
            padding: const EdgeInsets.only(top: 8.0),

            child: Text(DateFormat('yyyy-MM-dd').format(time.toDate()),
              style: TextStyle(fontSize: 10.sp ,color: Colors.grey),),

          ),
      ],
    ),
    ]
    );
  }
  }
