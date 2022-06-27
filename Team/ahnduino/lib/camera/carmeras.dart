import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'MyCustumWidget.dart';

class UploadingPicture extends StatefulWidget {
  const UploadingPicture({Key? key}) : super(key: key);

  @override
  _UploadingPictureState createState() => _UploadingPictureState();
}

class _UploadingPictureState extends State<UploadingPicture> {
  bool showSpinner = false;
  bool _isSelected = false;
  String user = FirebaseAuth.instance.currentUser!.email.toString();
  String _error = 'No Error Detected';
  String title = '';
  String fieldText = '';
  List<AssetEntity>? assetList = [];
  List<MySetDayAndTimeWidget> dynamicList = [];
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  addDynamic(bool isadd) {
    setState(() {});
    if (dynamicList.length >= 3 && isadd) {
      return;
    } else if (isadd) {
      dynamicList.add(MySetDayAndTimeWidget());
    } else if (!isadd) {
      dynamicList.clear();
    }
  }

  Future<bool> _getStatuses() async {
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        await Permission.accessMediaLocation.isGranted) {
      return Future.value(true);
    }
    if (await Permission.camera.isDenied &&
        await Permission.storage.isDenied &&
        await Permission.accessMediaLocation.isDenied) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("권한 설정을 확인해주세요."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: Text('설정하기')),
              ],
            );
          });
      print("permission denied by user");
      return Future.value(false);
    }
    return Future.value(false);
  }

  /*Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }*/

  loadAssets() async {
    if (_getStatuses() == Future.value(false)) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '사진 업로드',
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Divider(
                    height: 0,
                    thickness: 2,
                  ),
                ),
                TextButton.icon(
                  // <-- TextButton
                  onPressed: () async {
                    assetList = await AssetPicker.pickAssets(
                      context,
                      pickerConfig: AssetPickerConfig(
                        canclereturn: assetList,
                        textDelegate: const EnglishAssetPickerTextDelegate(),
                        selectedAssets: assetList,
                        maxAssets: 100,
                        requestType: RequestType.image,
                        themeColor: const Color.fromRGBO(0, 143, 94, 1.0),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.image,
                    color: Color.fromRGBO(0, 143, 94, 1.0),
                    size: 24.0,
                  ),
                  label: Text(
                    '갤러리에서 선택하기',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 143, 94, 1.0),
                    ),
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                ),
                TextButton.icon(
                  // <-- TextButton
                  onPressed: () async {
                    final AssetEntity? entity =
                        await CameraPicker.pickFromCamera(
                      context,
                      pickerConfig: const CameraPickerConfig(),
                    );
                    if (entity != null) {
                      assetList?.add(entity);
                    }
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Color.fromRGBO(0, 143, 94, 1.0),
                    size: 24.0,
                  ),
                  label: Text(
                    '카메라로 촬영하기',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 143, 94, 1.0),
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
              ],
            ),
          ),
        );
      },
    );

    FocusScope.of(context).unfocus();
    String error = '오류없이 선택이 완료 되었습니다.';
    if (!mounted) return;
    if (assetList == null) return;
    setState(() {
      assetList;
      _error = error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error.toString()),
          backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
        ),
      );
    });
  }

  sendFire() async {
    try {
      Map<String, dynamic> dic;
      DateTime now = DateTime.now().toUtc();
      String day =
          DateFormat('yyyy-MM-dd').format(now.add(const Duration(hours: 9)));
      String intStr =
          DateFormat('yyMMddHHmms').format(now.add(const Duration(hours: 9)));
      String docID = title + intStr;
      String colID = day.toString() + '예약 전';
      dic = {
        'userName': user,
        'UID': user,
        'Title': title,
        'Text': fieldText,
        'Time': now,
        'DocID': docID,
        'Date': day,
        'solved': false,
        'isreserv': false,
        'reserv': '예약 전'
      };

      final refImage = await FirebaseStorage.instance
          .ref()
          .child(user)
          .child('ResponsAndReQuest');

      for (int i = 0; i < dynamicList.length; i++) {
        if (dynamicList[i].day.isNotEmpty &&
            dynamicList[i].selectedTime.isNotEmpty)
          dic['hopeTime$i'] = dynamicList[i].day + dynamicList[i].selectedTime;
      }

      for (int i = 0; i < assetList!.length; i++) {
        File? F = await assetList![i].file;

        if (F == null) {
          throw '업로드 하는데에 문제가 생겼습니다.';
        }
        await refImage
            .child(colID)
            .child(docID)
            .child(title + '$i' + '.png')
            .putFile(F);

        final url = await refImage
            .child(colID)
            .child(docID)
            .child(title + '$i' + '.png')
            .getDownloadURL();

        dic['image$i'] = url;
      }

      final setdoc = await FirebaseFirestore.instance
          .collection('ResponsAndReQuest')
          .doc(user)
          .collection("Request")
          .doc("Request");

      await setdoc.collection(colID).doc(docID).set(dic);

      final value = await setdoc.get();

      if (value.data() == null) {
        setdoc.set({
          'All': FieldValue.increment(1),
          colID: FieldValue.increment(1),
        });
      } else {
        setdoc.update({
          'All': FieldValue.increment(1),
          colID: FieldValue.increment(1),
        });
      }
      await FirebaseFirestore.instance
          .collection('ResponsAndReQuest')
          .doc(user)
          .set({'isdone': false});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
          ),
        );
      }
    }
  }

  final ScrollController _scrollController = ScrollController();

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
        title: Padding(
          padding: const EdgeInsets.only(right: 60),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_photo_alternate,
                  size: 40,
                  color: Colors.black,
                ),
                Text(
                  '수리 예약 하기',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(300.w, 40.h)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          )),
          //syleForm에서  primarycolor랑 같다.
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return Colors.black26;
            } else {
              return Color.fromRGBO(0, 143, 94, 1.0);
            }
          }),
          textStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20, color: Colors.black12);
            } else {
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 2, color: Colors.white);
            }
          }),
        ),
        onPressed: fieldText.isEmpty || title.isEmpty
            ? null
            : () async {
                for (var element in dynamicList) {
                  if (element.day.isEmpty || element.selectedTime.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('희망 날짜 또는 희망 시간이 설정 되지 않았습니다.'),
                        backgroundColor: Color.fromRGBO(0, 143, 94, 1.0),
                      ),
                    );
                    return;
                  }
                }
                setState(() {
                  showSpinner = true;
                });
                await sendFire();
                setState(() {
                  showSpinner = false;
                  Navigator.pop(context);
                });
              },
        child: const Text('완 료'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(top: 20.0, right: 8.0, left: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                            border: Border.all(
                                color: const Color.fromRGBO(0, 0, 0, 0.2),
                                width: 4)), //테두리
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 2),
                          child: Container(
                            width: 120,
                            height: 130,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    scale: 0.1,
                                    alignment: Alignment.bottomRight,
                                    image: AssetImage(
                                      'assets/fiximage.png',
                                    ))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                    text: const TextSpan(
                                        text:
                                            '주택 이용 중에 생긴\n불편한 점이나 문의사항을 \n보내주세요.\n',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                      TextSpan(
                                          text: '확인 후 연락 드리겠습니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ))
                                    ])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1, right: 10.0),
                      child: SizedBox(
                        height: 25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              '희망 날짜 설정',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.grey),
                            ),
                            Switch(
                              value: _isSelected,
                              onChanged: (value) {
                                setState(() {
                                  _isSelected = value;
                                  addDynamic(_isSelected);
                                });
                              },
                              activeColor: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          child: Column(
                              children: List.generate(
                                  dynamicList.length,
                                  (index) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Container(
                                                //width: 400,
                                                child: dynamicList[index]),
                                          ),
                                          if (index == 0)
                                            SizedBox(
                                              width: 29,
                                              height: 29,
                                              child: FittedBox(
                                                child: FloatingActionButton(
                                                  heroTag: null,
                                                  backgroundColor:
                                                      Colors.white70,
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 41,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      addDynamic(true);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          if (index == 1)
                                            SizedBox(
                                              width: 29,
                                              height: 29,
                                              child: FittedBox(
                                                child: FloatingActionButton(
                                                  heroTag: null,
                                                  backgroundColor:
                                                      Colors.white70,
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 41,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      dynamicList.removeLast();
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          if (index == 2)
                                            const SizedBox(
                                              width: 29,
                                              height: 29,
                                            ),
                                        ],
                                      )).toList())),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                //모서리를 둥글게
                                border: Border.all(
                                    color: Colors.black12, width: 3)),
                            child: TextField(
                                scrollController: _scrollController,
                                onChanged: (text) {
                                  setState(() {
                                    title = text;
                                  });
                                },
                                maxLines: 1,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(left: 10, top: 15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    hintText: '제목을 작성해 주십시오',
                                    hintStyle: const TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.w600))),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //모서리를 둥글게
                            border:
                                Border.all(color: Colors.black12, width: 3)),
                        child: TextField(
                            onChanged: (text) {
                              setState(() {
                                fieldText = text;
                              });
                            },
                            maxLines: 10,
                            style: TextStyle(fontSize: 16.sp),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: '수리요청할 부분을 자세히 적어 주시길 바랍니다',
                                hintStyle: const TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 10, left: 10, bottom: 60.0, top: 10),
                      child: SizedBox(
                        height: 120.h,
                        child: GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 1,
                            physics: const ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            mainAxisSpacing: 10,
                            children: assetList!.isEmpty || assetList == null
                                ? List.generate(
                                    1,
                                    (index) => Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), //모서리를 둥글게
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      0, 0, 0, 0.2),
                                                  width: 4)),
                                          child: Center(
                                            child: CameraIconButton(
                                                max: 5,
                                                loadAssets: loadAssets,
                                                length: assetList!.length),
                                          ),
                                        )).toList()
                                : List.generate(
                                    assetList!.length + 1,
                                    (index) => index == 0
                                        ? Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.white70,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20), //모서리를 둥글게
                                                border: Border.all(
                                                    color: const Color.fromRGBO(
                                                        0, 0, 0, 0.2),
                                                    width: 4)),
                                            child: Center(
                                                child: CameraIconButton(
                                                    max: 5,
                                                    loadAssets: loadAssets,
                                                    length: assetList!.length)),
                                          )
                                        : MyCustumImageBox(
                                            images: assetList,
                                            index: index - 1,
                                          )).toList()),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
