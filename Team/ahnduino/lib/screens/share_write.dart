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

class UploadingPicture extends StatefulWidget {
  const UploadingPicture({Key? key}) : super(key: key);

  @override
  _UploadingPictureState createState() => _UploadingPictureState();
}

class _UploadingPictureState extends State<UploadingPicture> {
  bool showSpinner = false;
  String User = FirebaseAuth.instance.currentUser!.email.toString();
  String _error = 'No Error Detected';
  String title = '';
  String fieldText = '';
  List<AssetEntity>? assetList = [];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
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

      String name = "익명";
      String Docid = title + intStr;
      List<String> list = [];
      dic = {
        'User': User,
        'title': title,
        'text': fieldText,
        'time': now,
        'Docid': Docid,
        'Date': day,
        "Liked": list,
        "LikedUser": list,
        "UnLiked": list,
        "UnLikedUser": list,
        "Likes": 0,
        "UnLikes": 0,
        "name": name,
      };
      final refImage =
          await FirebaseStorage.instance.ref().child('share').child(Docid);

      for (int i = 0; i < assetList!.length; i++) {
        File? F = await assetList![i].file;

        if (F == null) {
          throw '업로드 하는데에 문제가 생겼습니다.';
        }

        await refImage.child(title + '$i' + '.png').putFile(F);

        final url =
            await refImage.child(title + '$i' + '.png').getDownloadURL();

        dic['image$i'] = url;
      }

      await FirebaseFirestore.instance.collection('share').doc(Docid).set(dic);
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
          onPressed: () async {
            await sendFire();

            Navigator.pop(context);
          },
          child: const Text('완 료'),
        ),
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
                    '게시판 작성',
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
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              constraints: const BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              child: Column(children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 10.0, bottom: 5.0),
                                  child: SizedBox(
                                    height: 50,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          bottom: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            //모서리를 둥글게
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 3)),
                                        child: TextField(
                                            scrollController: _scrollController,
                                            onChanged: (text) {
                                              setState(() {
                                                title = text;
                                              });
                                            },
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 10, top: 15),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                    fontWeight:
                                                        FontWeight.w600))),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        //모서리를 둥글게
                                        border: Border.all(
                                            color: Colors.black12, width: 3)),
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white70,
                                            hintText:
                                                '본인이 알고있는 꿀팁을 적어주시기 바랍니다.',
                                            hintStyle: const TextStyle(
                                                color: Colors.black26,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                ),
                              ]),
                            ),
                          )
                        ]))))));
  }
}
