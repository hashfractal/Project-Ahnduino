import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

// ignore: must_be_immutable
class Pageviewscreen extends StatefulWidget {
  Pageviewscreen(
      {Key? key,
      required this.images,
      required this.startpage,
      required this.currentPage})
      : super(key: key);
  //부모 위젯에게 전달 받은 arguments 클래스
  final List<AssetEntity>? images;
  final int startpage;
  int currentPage;
  @override
  State<Pageviewscreen> createState() => _PageviewscreenState();
}

class _PageviewscreenState extends State<Pageviewscreen> {
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
            children: [
              const Icon(
                Icons.image,
                size: 40,
                color: Colors.black,
              ),
              Text(
                '업로드 이미지 ${widget.currentPage}/${widget.images!.length}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        ),
        body: PageView.builder(
          controller: PageController(initialPage: widget.startpage),
          itemCount: widget.images!.length,
          onPageChanged: (page) {
            setState(() {
              widget.currentPage = page + 1;
            });
          },
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Image(
                  image: AssetEntityImageProvider(widget.images![index],
                      isOriginal: false)),
            );
          },
        ));
  }
}
