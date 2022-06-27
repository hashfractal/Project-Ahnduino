import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListOnTapPageImageView extends StatefulWidget {
  ListOnTapPageImageView(
      {Key? key,
      required this.images,
      required this.startpage,
      required this.currentPage})
      : super(key: key);

  //부모 위젯에게 전달 받은 arguments 클래스
  final List<String> images;
  final int startpage;
  int currentPage;

  @override
  State<ListOnTapPageImageView> createState() => _ListOnTapPageImageViewState();
}

class _ListOnTapPageImageViewState extends State<ListOnTapPageImageView> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
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
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.image,
                size: 40,
              ),
              Text(
                '업로드 이미지 ${widget.currentPage}/${widget.images.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: const Color.fromRGBO(0, 143, 94, 1.0),
        ),
        body: PageView.builder(
            controller: PageController(initialPage: widget.startpage),
            itemCount: widget.images.length,
            onPageChanged: (page) {
              setState(() {
                widget.currentPage = page + 1;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return CachedNetworkImage(
                imageUrl: widget.images[index],
                imageBuilder: (context, imageProvider) => Center(
                    child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                    ),
                  ),
                )),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.totalSize != null
                                ? downloadProgress.progress!
                                : null,
                            color: Colors.grey)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              );
            }));
  }
}
