import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:intl/intl.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  List<Asset> assetimages = [];

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    return file;
  }

  Future<bool> _getStatuses() async {
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted &&
        await Permission.accessMediaLocation.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  List<AssetEntity>? assetList = [];
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
                        pageSize: 40,
                        gridCount: 4,
                        textDelegate: const EnglishAssetPickerTextDelegate(),
                        selectedAssets: assetList,
                        maxAssets: 5,
                        requestType: RequestType.image,
                        themeColor: const Color.fromRGBO(0, 143, 94, 1.0),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.image,
                    size: 24.0,
                    color: Color.fromRGBO(0, 143, 94, 1.0),
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
                    size: 24.0,
                    color: Color.fromRGBO(0, 143, 94, 1.0),
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
    // ignore: unused_local_variable
    String error = '사진 선택이 완료되었습니다.';
    if (!mounted) return;
    if (assetList == null) return;
    setState(() {
      assetList;
    });
    _sendMessage();
  }

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    String uniqueID = DateFormat('yyyyMMddHHmmss')
        .format(DateTime.now().toUtc().add(const Duration(hours: 9)));
    final chat = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> sendMap = {
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'chat': chat!.email,
      'type': true
    };
    if (assetList != null) {
      for (int i = 0; i < assetList!.length; i++) {
        File? F = await assetList![i].file;
        await FirebaseStorage.instance
            .ref()
            .child(chat.email.toString())
            .child('chat')
            .child(uniqueID)
            .child("image$i" + '.png')
            .putFile(F!);
        String url = await FirebaseStorage.instance
            .ref()
            .child(chat.email.toString())
            .child('chat')
            .child(uniqueID)
            .child("image$i" + '.png')
            .getDownloadURL();
        sendMap['image$i'] = url;
      }
    }

    FirebaseFirestore.instance
        .collection('chat')
        .doc('chat')
        .collection(chat.email.toString())
        .doc(uniqueID)
        .set(sendMap);
    FirebaseFirestore.instance
        .collection('chat')
        .doc('chat')
        .collection('needanswer')
        .doc(chat.email.toString())
        .set({'time': DateTime.now()});
    _controller.clear();
    _userEnterMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.add_box_outlined,
              color: Colors.grey,
            ),
            onPressed: () async {
              await loadAssets();
            },
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                style: TextStyle(fontSize: 17.sp),
                maxLines: null,
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '메세지를 입력하세요...',
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black12),
                ),
                onChanged: (value) {
                  setState(() {
                    _userEnterMessage = value;
                  });
                },
              ),
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Color.fromRGBO(0, 143, 94, 1.0),
          ),
        ],
      ),
    );
  }
}
