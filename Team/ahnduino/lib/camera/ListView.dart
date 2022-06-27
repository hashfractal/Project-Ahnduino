import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'MyCustumWidget.dart';
import 'carmeras.dart';

class UploadedPictureList extends StatefulWidget {
  const UploadedPictureList({Key? key}) : super(key: key);

  @override
  State<UploadedPictureList> createState() => _UploadedPictureListState();
}

class _UploadedPictureListState extends State<UploadedPictureList> {
  String temp = 'All';
  var _selected = 'All';
  Future? myfutuer;
  late GlobalKey dropdownKey;

  @override
  void initState() {
    super.initState();
    dropdownKey = GlobalKey();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  getData(var _selected, List<String> userDocument) async {
    List<QuerySnapshot<Object?>> aa = [];
    if (_selected == 'All') {
      for (var element in userDocument) {
        if (element != 'all') {
          await FirebaseFirestore.instance
              .collection('ResponsAndReQuest')
              .doc(FirebaseAuth.instance.currentUser!.email.toString())
              .collection("Request")
              .doc("Request")
              .collection(element)
              .orderBy('Time', descending: true)
              .get()
              .then((value) {
            aa.add(value);
          });
        }
      }
    } else if (_selected != 'All') {
      String temp = _selected;
      await FirebaseFirestore.instance
          .collection('ResponsAndReQuest')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .collection("Request")
          .doc("Request")
          .collection(temp)
          .orderBy('Time', descending: true)
          .get()
          .then((value) {
        aa.add(value);
      });
    }
    return aa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
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
                                fontSize: 18, fontWeight: FontWeight.bold),
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
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.photo_library,
                color: Colors.black,
                size: 35,
              ),
              Text(
                '예약현황 열람실',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('ResponsAndReQuest')
              .doc(FirebaseAuth.instance.currentUser!.email.toString())
              .collection('Request')
              .doc('Request')
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.data() == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text("데이터가 없습니다."),
                  )
                ],
              );
            }

            Map<String, dynamic> documentFields =
                snapshot.data?.data() as Map<String, dynamic>;
            documentFields =
                SplayTreeMap.from(documentFields, (a, b) => b.compareTo(a));

            myfutuer = getData(_selected, documentFields.keys.toList());

            if (dropdownKey.currentContext != null &&
                Navigator.canPop(dropdownKey.currentContext!)) {
              Navigator.pop(dropdownKey.currentContext!);
            }

            return Column(children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyCustumDropdownButton(
                    dropdownKey: dropdownKey,
                    documentFields: documentFields,
                    selected: _selected,
                    onChanged: (value) {
                      if (value != null) {
                        temp = value;
                        setState(() {
                          _selected = value;
                          myfutuer =
                              getData(_selected, documentFields.keys.toList());
                        });
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('오류가 생겨 잠시 후 다시 시도해주세요.'),
                          backgroundColor: Colors.blue,
                        ));
                        return;
                      }
                    },
                  )),
              Expanded(
                child: FutureBuilder(
                  future: myfutuer,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue)),
                      );
                    } else {
                      if (snapshot.data == null) {
                        return const Text('error');
                      }
                      var snaplist = snapshot.data as List<QuerySnapshot>;
                      List<dynamic> docList = [];
                      for (var element in snaplist) {
                        docList
                            .addAll(element.docs.map((e) => e.data()).toList());
                      }
                      // data loaded:.
                      return Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: docList.length + 1, //99 +1
                          itemBuilder: (context, index) {
                            if (index > docList.length - 1) {
                              return const SizedBox(
                                height: 100,
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 2,
                                          color: Color.fromRGBO(0, 0, 0, 0.10)),
                                    ),
                                  ),
                                  child: MycustomCard(
                                      docs: docList,
                                      index: index,
                                      category: temp),
                                  margin:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ]);
          }),
    );
  }
}
