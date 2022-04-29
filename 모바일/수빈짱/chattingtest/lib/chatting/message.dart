import 'package:chattingtest/chatting/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String chatDate ='';
    final chat = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat').doc('chat').collection(FirebaseAuth.instance.currentUser!.email.toString())
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    final chatDocs = snapshot.data!.docs;

        chatDate = '';

      List<ChatBubbles> chatinglist =[];
          chatDocs.forEach((element) {
          Timestamp now = element['time'];
          if (chatDate != DateFormat('yyyy-MM-dd').format(now.toDate()).toString())
          {
            chatDate =  DateFormat('yyyy-MM-dd').format(now.toDate()).toString();
            chatinglist.add(ChatBubbles(chatDate, element['chat'] == chat!.email,  element['time'],true));
            chatinglist.add(ChatBubbles (
                element['text'],
                element['type'] ,
                element['time'],
                false
            ));
          }
          else
            {
              chatinglist.add( new ChatBubbles (
                  element['text'],
                  element['type'],
                  element['time'],
                  false
              ),);
            }


        });
    return ListView.builder(
    reverse: true,
    itemCount: chatinglist.length,
    itemBuilder: (context, index) {
      return chatinglist[chatinglist.length - index - 1];

    }

        );
      },
    );

  }

}