import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'MyCustumWidget.dart';

class CheckInCheckOutImage extends StatefulWidget {
  const CheckInCheckOutImage({Key? key}) : super(key: key);
  //부모 위젯에게 전달 받은 arguments 클래스
  @override
  State<CheckInCheckOutImage> createState() => _CheckInCheckOutImageState();
}

class _CheckInCheckOutImageState extends State<CheckInCheckOutImage> {
  String user = FirebaseAuth.instance.currentUser!.email.toString();
  Future? myfuture;
  List<Map<String, dynamic>> snaplist = [];
  List<Map<String, dynamic>> showlist = [];
  List<String> urlList = [];
  List<String> showurlList = [];

  List<String> returnImageUrl(List<Map<String, dynamic>> docs) {
    List<String> list = [];
    for (int i = 0; i < docs.length; i++) {
      if (docs[i]['image'] != null) {
        list.add(docs[i]['image']);
      } else {
        return list;
      }
    }
    return list;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    myfuture = getData();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    List<String> resultsurl = [];
    // Refresh the UI
    setState(() {
      if (enteredKeyword.isEmpty) {
        // if the search field is empty or only contains white-space, we'll display all users
        showlist.clear();
        showurlList.clear();
      } else {
        results = snaplist
            .where((user) => user["title"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();
        for (int i = 0; i < results.length; i++) {
          if (results[i]['image'] != null) {
            resultsurl.add(results[i]['image']);
          }
        }
        showurlList = resultsurl;
        showlist = results;
      }
    });
  }

  Future<List<Map<String, dynamic>>> getData() async {
    // Get docs from collection reference
    var allData = (await FirebaseFirestore.instance
        .collection('CheckInCheckOut')
        .doc(user)
        .collection('입실')
        .orderBy('time', descending: true)
        .get());
    final docs = allData.docs.map((doc) => doc.data()).toList();
    return docs;
  }

  TextEditingController editingController = TextEditingController();

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
            children: const [
              Icon(
                Icons.assignment,
                size: 40,
                color: Colors.black,
              ),
              Text(
                '입실 사진보기',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              )
            ],
          )),
      body: FutureBuilder(
        future: myfuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
            );
          } else {
            if (snapshot.data == null) {
              return const Text('error');
            }
            snaplist = snapshot.data as List<Map<String, dynamic>>;
            urlList = returnImageUrl(snaplist);

            // data loaded:.
            return Scrollbar(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      _runFilter(value);
                    },
                    controller: editingController,
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: showlist.isEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snaplist.length + 1, //99 +1
                          itemBuilder: (context, index) {
                            if (index > snaplist.length - 1) {
                              return const SizedBox(
                                height: 100,
                              );
                            } else {
                              return Column(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyCheckInCheckOutImageTextViewWidget(
                                        index: index,
                                        urlList: urlList,
                                        text:
                                            snaplist[index]['text'].toString(),
                                        title:
                                            snaplist[index]['title'].toString(),
                                      ),
                                    ]),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10),
                                  child: Divider(
                                    thickness: 2,
                                    color: Colors.black12,
                                  ),
                                )
                              ]);
                            }
                          },
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: showlist.length + 1, //99 +1
                          itemBuilder: (context, index) {
                            if (index > showlist.length - 1) {
                              return const SizedBox(
                                height: 100,
                              );
                            } else {
                              return Column(children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MyCheckInCheckOutImageTextViewWidget(
                                        index: index,
                                        urlList: showurlList,
                                        text:
                                            showlist[index]['text'].toString(),
                                        title:
                                            showlist[index]['title'].toString(),
                                      ),
                                    ]),
                                const Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10),
                                  child: Divider(
                                    thickness: 2,
                                    color: Colors.black12,
                                  ),
                                )
                              ]);
                            }
                          },
                        ),
                ),
              ]),
            );
          }
        },
      ),
    );
  }
}
