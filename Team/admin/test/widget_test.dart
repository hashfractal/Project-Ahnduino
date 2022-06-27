import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cameratest/pageviewscreen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'ListOnTapPageImageView.dart';
import 'MyCustumWidget.dart';

class CheckInCheckOutImage extends StatefulWidget {
  const CheckInCheckOutImage({Key? key}) : super(key: key);
  //부모 위젯에게 전달 받은 arguments 클래스
  @override
  State<CheckInCheckOutImage> createState() => _CheckInCheckOutImageState();
}

class _CheckInCheckOutImageState extends State<CheckInCheckOutImage> {
  int _index = 0;

  String Setmsgs(int num) {
    if (num == 0)
      return '입실';
    else
      return '퇴실';
  }
  Widget Setmsg(int num) {
    if (num == 0) {
      return Column(
        children: const [
          Text('asd')
        ],
      );
    } else {
      return Text('assadasd');
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color.fromRGBO(224, 224, 224, 1.0),
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          backgroundColor: const Color.fromRGBO(0, 143, 94, 1.0),
          title: Padding(
            padding:  const EdgeInsets.only(right: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 8.0, top: 7.0),
                  child: Icon(Icons.assignment_outlined, size: 40,),
                ),
              ],
            ),
          )
      ),
      body: SafeArea(
        child:
        Column(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.white.withOpacity(0.001),Colors.white,Colors.white,Colors.white.withOpacity(0.001)],
                  stops:[0,0.4, 0.6,1],
                  tileMode: TileMode.mirror,
                ).createShader(Offset.zero & bounds.size);
              },
              child: SizedBox(
                height: 50,
                child: PageView.builder(
                  itemCount: 2,
                  controller: PageController(viewportFraction:0.7),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (_,i) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child:
                          Text(
                            Setmsgs(i),
                            style: TextStyle(fontSize: 20),
                          ),

                        ),
                      ),

                    );
                  },
                ),

              ),
            ),
            Setmsg(_index),
          ],
        ),

      ),
    );
  }
}