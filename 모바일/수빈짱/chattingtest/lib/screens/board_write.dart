import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';




class CameraIconButton extends StatelessWidget {
  const CameraIconButton({Key? key, required this.loadAssets, required this.length}) : super(key: key);

  final VoidCallback loadAssets;
  final int length;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
        children: [
          IconButton(
            color: Colors.white30,
            iconSize: 50,
            icon: Icon(
              Icons.camera_alt,
              color: Colors.black54,
            ),
            onPressed: () {
              loadAssets();
              //_pickImage();
            },
          ),
          Text(
            "$length/5",
            style: TextStyle(color: Colors.black45, fontSize: 20.sp),
          )
        ]);
  }
}




class UploadingPicture extends StatefulWidget {
  const UploadingPicture({Key? key}) : super(key: key);






  @override
  _UploadingPictureState createState() => _UploadingPictureState();
}

class _UploadingPictureState extends State<UploadingPicture> {
  bool showSpinner = false;
  String user = 'kim6425@naver.com';
  String name = '김수빈';
  String _error = 'No Error Detected';
  String title = '';
  String textfield = '';
  List<File> images = [];
  List<Asset> assetimages = [];


  Future<bool> _getStatuses() async {
    if (await Permission.camera.isGranted &&
        await Permission.storage.isGranted&& await Permission.accessMediaLocation.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

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

  loadAssets() async {
    FocusScope.of(context).unfocus();
    if (_getStatuses() == Future.value(false)) return;
    List<File> tempimage = [];
    String error = '오류없이 선택이 완료 되었습니다.';
    try {
      assetimages = await MultiImagePicker.pickImages(
          maxImages: 5,
          enableCamera: true,
          selectedAssets: assetimages,
          cupertinoOptions: const CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: const MaterialOptions(
            actionBarColor: "#008f5e",
            actionBarTitle: "사진 고르기",
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
      _error = error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_error.toString()),
          backgroundColor: Colors.blue,
        ),
      );
    });
  }

  void sendFire() async {

    try {
      Map<String, dynamic> dic;
      DateTime now = DateTime.now().toUtc().add(const Duration(hours: 9));
      String day = DateFormat('yyyy/MM/dd').format(now);
      String intStr = DateFormat('yyMMddHms').format(now);
      String docID = title + intStr;
      String colID = day.toString() + '예약 전';


      dic = {
        'user': user,
        'name':name,
        'title': title,
        'text': textfield,
        'time': Timestamp.fromDate(now).toDate(),
        'DocID': docID,
        'Date': day,
      };


      for (int i = 0; i < images.length; i++) {
        final refImage = FirebaseStorage.instance
            .ref()
            .child(user)
            .child(docID)
            .child(title + '$i' + '.png');
        await refImage.putFile(images[i]);
        final url = await refImage.getDownloadURL();
        dic['image$i'] = url;
      }
      final setdoc = await FirebaseFirestore.instance
          .collection('board')
          .doc(docID).set(dic).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('업로륻 되었습니다.'),
            backgroundColor: Colors.blue,
          ),
        );


      });

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.blue,
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right:60),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.border_color_outlined,size: 40,),
                ),
                Text(
                  '게시글 작성',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],),
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 143, 94, 1.0),

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
              return Colors.blue;
            }
          }),
          textStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              // disabled : onpressed가 null일때 , pressed : 클릭됐을때
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20.w, color: Colors.black12);
            } else {
              return TextStyle(
                  fontSize: 20.sp, letterSpacing: 20.w, color: Colors.white);
            }
          }),
        ),
        onPressed: title.isEmpty || textfield.isEmpty
            ? null
            : () {

          setState(() {
            showSpinner = true;
          });
          sendFire();
          setState(() {
            showSpinner = false;
          });
          Navigator.pop(context);
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
                      padding: EdgeInsets.only(top: 10.0.h, bottom: 5.0.h),
                      child: SizedBox(
                        height: 50.h,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0.w, right: 10.0.w, bottom: 10.0.h),
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
                                    EdgeInsets.only(left: 10.w, top: 15.h),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white70,
                                    hintText: '제목을 작성해주세요.',
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
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            //모서리를 둥글게
                            border:
                            Border.all(color: Colors.black12, width: 3)),
                        child: TextField(
                            onChanged: (text) {
                              setState(() {
                                textfield = text;
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
                                hintText: '게시글을 작성해주세요.',
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
                            mainAxisSpacing:10 ,
                            children: images.isEmpty
                                ? List.generate(
                                1,
                                    (index) => SizedBox(
                                  width: 100.w,
                                  height: 100.h,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                                        border: Border.all(
                                            color: const Color.fromRGBO(0, 0, 0, 0.2),
                                            width: 4)),
                                    child: Center(
                                      child: CameraIconButton(
                                          loadAssets: loadAssets,
                                          length: images.length),
                                    ),
                                  ),
                                )).toList()
                                : List.generate(
                                images.length + 1,
                                    (index) => SizedBox(
                                  width: 100.w,
                                  height: 100.h,
                                  child: index == 0
                                      ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                                        border: Border.all(
                                            color: const Color.fromRGBO(0, 0, 0, 0.2),
                                            width: 4)),
                                    child: Center(
                                        child: CameraIconButton(
                                            loadAssets:
                                            loadAssets,
                                            length: images
                                                .length)),
                                  )
                                      : MyCustumImageBox(
                                    images: images,
                                    index: index - 1,
                                  ),
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

class MyCustumImageBox extends StatelessWidget {
  const MyCustumImageBox({Key? key, required this.images, required this.index}) : super(key: key);
  final int  index;
  final  List<File> images;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Pageviewscreen(
                    images: images, startpage: index, currentPage: index + 1)));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20), //모서리를 둥글게
            border: Border.all(
                color: const Color.fromRGBO(0, 0, 0, 0.2),
                width: 4),
            image: DecorationImage(
                image: FileImage(images[index]),
                //File Image를 삽입
                fit: BoxFit.cover)),
      ),
    );
  }
}

class Pageviewscreen extends StatefulWidget{
  Pageviewscreen({Key? key,  required this.images ,required this.startpage, required this.currentPage}) : super(key: key);
  //부모 위젯에게 전달 받은 arguments 클래스
  final List<File> images;
  final int startpage;
  int currentPage;
  @override
  State<Pageviewscreen> createState() => _PageviewscreenState();
}

class _PageviewscreenState extends State<Pageviewscreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
        backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),

        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: const Color.fromRGBO(0, 143, 94, 1.0),
          title:Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.image,size: 40,),
                ),
                Text('업로드 이미지 ${widget.currentPage}/${widget.images.length}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold
                  ),),
              ],
            ),
          ),
        ),

        body: PageView.builder(
          controller: PageController(initialPage: widget.startpage),
          itemCount: widget.images.length,
          onPageChanged: (page){
            setState(() {
              widget.currentPage = page+1;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return  Center(
              child: Image(image: FileImage(widget.images[index])),
            );
          },
        )
    );
  }
}
