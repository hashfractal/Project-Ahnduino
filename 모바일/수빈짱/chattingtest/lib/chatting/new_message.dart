import 'package:chattingtest/config/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _userEnterMessage = '';
  List<File> images = [];
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
    Map<Permission, PermissionStatus> statuses =
    await [Permission.storage, Permission.camera].request();

    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  loadAssets() async {
    //FocusScope.of(context).unfocus();
    if (_getStatuses() == false) return;
    List<File> tempimage = [];
    String error = 'No Error Detected';
    try {
      assetimages = await MultiImagePicker.pickImages(
          maxImages: 5,
          enableCamera: true,
          selectedAssets: assetimages,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Example App",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ));
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;

    for (var result in assetimages) {
      File F = await (getImageFileFromAssets(result));
      tempimage.add(F);
    }
    setState(() {
      images = tempimage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.lightGreen,
        ),
      );
    });
  }
  void _sendMessage(){
    FocusScope.of(context).unfocus();
    final chat = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.currentUser?.email.toString();
    FirebaseFirestore.instance.collection('chat').doc('chat').collection(FirebaseAuth.instance.currentUser!.email.toString()).add(
        {'text' : _userEnterMessage,
          'time' : Timestamp.now(),
          'chat' : chat!.email,
          'type' : true
  }


    );
    _controller.clear();
    _userEnterMessage='';
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
            onPressed: ()  {
              loadAssets();
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30)
              ),
              child: TextField(

                style: TextStyle(fontSize: 17.sp),

                maxLines: null,
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '메세지를 입력하세요...', hintStyle: TextStyle(fontWeight: FontWeight.bold , color: Colors.black12),

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