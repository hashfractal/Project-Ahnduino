import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'MyCustumWidget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class CheckinCheckOutPAge extends StatefulWidget {
  const CheckinCheckOutPAge({Key? key}) : super(key: key);

  @override
  _CheckinCheckOutPAgeState createState() => _CheckinCheckOutPAgeState();
}

class _CheckinCheckOutPAgeState extends State<CheckinCheckOutPAge> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool showSpinner = false;
  String user = FirebaseAuth.instance.currentUser!.email.toString();
  String _error = 'No Error Detected';
  List<AssetEntity>? assetList = [];
  Map<String, MyCheckInCheckOutImageTextWidget> CkInNOutMap = {};

  Widget makeMyCKinoutWidget(int index) {
    //if(CkInNOutMap[''])
    if (CkInNOutMap[assetList![index].id.toString()] == null) {
      CkInNOutMap[assetList![index].id.toString()] =
          MyCheckInCheckOutImageTextWidget(index: index, imagelist: assetList);
    } else if (CkInNOutMap[assetList![index].id.toString()] != null) {
      CkInNOutMap[assetList![index].id.toString()]!.index = index;
      CkInNOutMap[assetList![index].id.toString()]!.imagelist = assetList;
    }

    return CkInNOutMap[assetList![index].id.toString()]!;

    /* var CheckInOutWidget =
        MyCheckInCheckOutImageTextWidget(index: index, imagelist: images);
    CKinoutWidgetList.add(CheckInOutWidget);
    return CheckInOutWidget;*/
  }

  Future<bool> _getStatuses() async {
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        await Permission.accessMediaLocation.isGranted) {
      return Future.value(true);
    } 
    if(await Permission.camera.isDenied &&
        await Permission.storage.isDenied &&
        await Permission.accessMediaLocation.isDenied)
         {
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

  /* Future<File> getImageFileFromAssets(Asset asset) async {
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
                  '입실 사진 업로드',
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
                        pageSize: 40,
                        gridCount: 4,
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
                      pickerConfig: CameraPickerConfig(
                        textDelegate: EnglishCameraPickerTextDelegate(),
                      ),
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
    String error = '사진 선택이 완료되었습니다.';
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
      String docID = "입실";
      final refImage = FirebaseStorage.instance.ref().child(user).child(docID);

      final Userreference = await FirebaseFirestore.instance
          .collection('CheckInCheckOut')
          .doc(user);

      for (int index = 0; index < assetList!.length; index++) {
        String title = CkInNOutMap[assetList![index].id.toString()]!.titlefield;
        String text = CkInNOutMap[assetList![index].id.toString()]!.textfiled;

        if (title.isEmpty || text.isEmpty) {
           throw '제목또는 내용을 채워 주세요';
        }

        String uniqueID = DateFormat('yyyyMMddHHmmss')
                .format(DateTime.now().toUtc().add(const Duration(hours: 9))) +
            title;
        File? F = await assetList![index].file;
        if (F == null) {
          throw '업로드 하는데에 문제가 생겼습니다.';
        }

        await refImage.child(uniqueID + '.png').putFile(F);
        final url = await refImage.child(uniqueID + '.png').getDownloadURL();

        await Userreference.collection(docID).doc(uniqueID).set({
          'docID': (uniqueID),
          'title': title,
          'text': text,
          'image': url,
          'time': DateTime.now().toUtc(),
        });
      }
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add_photo_alternate,
              size: 40,
              color: Colors.black,
            ),
            Text(
              '사진 업로드',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(230, 235, 238, 1.0),
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(300, 40)),
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
                  fontSize: 20.sp, letterSpacing: 20, color: Colors.white);
            }
          }),
        ),
        onPressed: () async {
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
        child: SingleChildScrollView(
          child: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
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
                            height: 150,
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
                                            '입실 했을때의 사진을\n찍어서 위치랑 특이사항등을 \n작성해 주세요.\n',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        children: [
                                      TextSpan(
                                          text:
                                              '입실사진은 최초 한번밖에 불가능하니 \n꼼꼼히 해주시길 바랍니다.',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                          ))
                                    ])),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Column(
                          children: List.generate(
                        assetList!.length,
                        (index) => Column(children: [
                          Row(
                            children: [
                              makeMyCKinoutWidget(index),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10),
                            child: Divider(
                              thickness: 2,
                              color: Colors.black12,
                            ),
                          )
                        ]),
                      ).toList()),
                    ),
                    Padding(
                      padding: CkInNOutMap.isNotEmpty
                          ? const EdgeInsets.only(
                              left: 10.0, right: 10, bottom: 60)
                          : const EdgeInsets.only(top: 150),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // 가운데 정렬
                                  children: [
                                    IconButton(
                                      color: Colors.white30,
                                      iconSize: 50,
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.black54,
                                      ),
                                      onPressed: () {
                                        loadAssets();
                                      },
                                    ),
                                    Text(
                                      "${assetList!.length}/100",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 20.sp),
                                    )
                                  ]),
                            ),
                          ]),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
