import 'package:ahnduino/camera/pageviewscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'ListOnTapPageImageView.dart';
import 'listpageview.dart';

class CameraIconButton extends StatelessWidget {
  const CameraIconButton(
      {Key? key,
      required this.loadAssets,
      required this.length,
      required this.max})
      : super(key: key);

  final VoidCallback loadAssets;
  final int length;
  final max;

  @override
  Widget build(BuildContext context) {
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
            "$length/$max",
            style: TextStyle(color: Colors.black45, fontSize: 20.sp),
          )
        ]);
  }
}

class MyCustumImageBox extends StatelessWidget {
  const MyCustumImageBox({Key? key, required this.images, required this.index})
      : super(key: key);
  final int index;
  final List<AssetEntity>? images;
  @override
  Widget build(BuildContext context) {
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
            border:
                Border.all(color: const Color.fromRGBO(0, 0, 0, 0.2), width: 4),
            image: DecorationImage(
                image:
                    AssetEntityImageProvider(images![index], isOriginal: false),
                //File Image를 삽입
                fit: BoxFit.cover)),
      ),
    );
  }
}

class MyCustumDropdownButton extends StatefulWidget {
  final GlobalKey<State<StatefulWidget>> dropdownKey;

  final Map<String, dynamic> documentFields;

  final String selected;

  final Function(String? value) onChanged;

  const MyCustumDropdownButton(
      {Key? key,
      required this.dropdownKey,
      required this.selected,
      required this.documentFields,
      required this.onChanged})
      : super(key: key);

  @override
  State<MyCustumDropdownButton> createState() => _MyCustumDropdownButtonState();
}

class _MyCustumDropdownButtonState extends State<MyCustumDropdownButton> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        alignment: AlignmentDirectional.center,
        buttonDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            width: 2,
            color: Colors.black26,
          ),
        ),
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonHeight: 40,
        dropdownDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        dropdownMaxHeight: 200,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        key: widget.dropdownKey,
        value: widget.selected,
        items: mycustumButton(widget.documentFields),
        onChanged: (value) {
          widget.onChanged(value);
        },
      ),
    );
  }
}

List<DropdownMenuItem<String>> mycustumButton(
    Map<String, dynamic> userDocument) {
  List<DropdownMenuItem<String>> listall = [];
  // userDocument = SplayTreeMap.from(userDocument, (a, b) => b.compareTo(a));
  userDocument.forEach((key, value) {
    String temp = key.toString() + '  (' + value.toString() + ')';
    listall.add(DropdownMenuItem(
        value: key.toString(),
        child: Text(
          temp,
          style: const TextStyle(fontWeight: FontWeight.w700),
        )));
  });

  return listall;
}

class MycustomCard extends StatelessWidget {
  const MycustomCard(
      {Key? key,
      required this.docs,
      required this.index,
      required this.category})
      : super(key: key);
  final String category;
  final List<dynamic> docs;
  final int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TileTapPageView(
                      docsList: docs,
                      index: index,
                      title: category,
                      currentPage: index + 1,
                    )));
      },
      visualDensity: const VisualDensity(vertical: 4),
      leading: docs[index]['image0'] != null
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 75,
                height: 70,
                child: CachedNetworkImage(
                  imageUrl: docs[index]['image0'],
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.totalSize != null
                                  ? downloadProgress.progress!
                                  : null,
                              color: Colors.grey)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ])
          : SizedBox(
              width: 80,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.no_photography,
                    size: 40,
                  ),
                  Text(
                    'No Image',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
      title: Text(
        docs[index]['Title'],
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Text(
        docs[index]['Text'].toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            docs[index]['Date'].toString(),
            style: TextStyle(fontSize: 12.sp),
          ),
          Text('예약: ' + docs[index]['reserv'].toString(),
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold))
        ],
      ),
      isThreeLine: true,
    );
  }
}

// ignore: must_be_immutable
class MyCheckInCheckOutImageTextWidget extends StatelessWidget {
  MyCheckInCheckOutImageTextWidget(
      {Key? key, required this.index, required this.imagelist})
      : super(key: key);

  List<AssetEntity>? imagelist;
  int index;
  String titlefield = '';
  String textfiled = '';
  TextEditingController titlecontroler = TextEditingController();
  TextEditingController textecontroler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      height: 170,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: MyCustumImageBox(
              images: imagelist,
              index: index,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Container(
                    width: 225,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        //모서리를 둥글게
                        border: Border.all(color: Colors.black12, width: 2)),
                    child: TextField(
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        controller: titlecontroler,
                        onChanged: (text) {
                          titlefield = text;
                        },
                        maxLines: 1,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 8.w,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white70,
                            hintText: '위치에 대해 작성해 주세요. 예) 화장실',
                            hintStyle: const TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.w600))),
                  ),
                ),
                Container(
                  width: 225,
                  height: 119,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //모서리를 둥글게
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: TextField(
                      controller: textecontroler,
                      onChanged: (text) {
                        textfiled = text;
                      },
                      maxLines: 10,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 7, top: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          hintText:
                              '사진에 대한 설명이나 특이사항등을 작성해 주세요.\n예)타일에 금이 가 있음',
                          hintStyle: const TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MyCheckInCheckOutImageTextViewWidget extends StatelessWidget {
  MyCheckInCheckOutImageTextViewWidget(
      {Key? key,
      required this.urlList,
      required this.index,
      required this.title,
      required this.text})
      : super(key: key);
  int index;
  String text;
  String title;
  final TextEditingController titlecontroler = TextEditingController();
  final TextEditingController textecontroler = TextEditingController();
  List<String> urlList;

  @override
  Widget build(BuildContext context) {
    textecontroler.text = text;
    titlecontroler.text = title;
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      height: 170,
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: CachedNetworkImage(
              imageUrl: urlList[index],
              imageBuilder: (context, imageProvider) => Container(
                child: GestureDetector(onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListOnTapPageImageView(
                              images: urlList,
                              startpage: index,
                              currentPage: index + 1)));
                }),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), //모서리를 둥글게
                  border: Border.all(
                      color: const Color.fromRGBO(0, 0, 0, 0.2), width: 4),
                  color: Colors.white70,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.totalSize != null
                              ? downloadProgress.progress!
                              : null,
                          color: Colors.grey)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Container(
                    width: 225,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        //모서리를 둥글게
                        border: Border.all(color: Colors.black12, width: 2)),
                    child: TextField(
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        controller: titlecontroler,
                        maxLines: 1,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 8.w,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                        )),
                  ),
                ),
                Container(
                  width: 225,
                  height: 119,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //모서리를 둥글게
                      border: Border.all(color: Colors.black12, width: 2)),
                  child: TextField(
                      controller: textecontroler,
                      enabled: false,
                      maxLines: 10,
                      style: TextStyle(fontSize: 12.sp),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 7, top: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MySetDayAndTimeWidget extends StatefulWidget {
  String day = '';
  String selectedTime = '';
  MySetDayAndTimeWidget({Key? key}) : super(key: key);
  @override
  State<MySetDayAndTimeWidget> createState() => _MySetDayAndTimeWidgetState();
}

class _MySetDayAndTimeWidgetState extends State<MySetDayAndTimeWidget> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _selectDate() async {
    DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        DateTime? tempPickedDate;
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: SizedBox(
            height: 250,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        tempPickedDate ??= DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 9, 0);
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day, 9, 0),
                    minuteInterval: 10,
                    minimumDate: DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day, 9, 0),
                    maximumDate: DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day, 17, 50),
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (pickedDate != null &&
        DateFormat('aa hh 시 mm 분', 'ko').format(pickedDate) !=
            widget.selectedTime) {
      setState(() {
        widget.selectedTime =
            DateFormat('aa hh 시 mm 분', 'ko').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white70,
              shape: RoundedRectangleBorder(
                  //모서리를 둥글게
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      color: Color.fromRGBO(0, 0, 0, 0.2), width: 3)),
              onPrimary: Colors.black, //글자색
              shadowColor: Colors.white70,
              //minimumSize: Size(160, 25), //width, height
              //child 정렬 - 아래의 Text('$test')
              //alignment: Alignment.centerRight,
            ),
            //textStyle: const TextStyle(fontSize: 30)),
            onPressed: () {
              FocusScope.of(context).unfocus();
              var nowDay = DateTime.now();
              showDatePicker(
                initialDate: isWeekend(nowDay),
                selectableDayPredicate: (DateTime val) =>
                    val.weekday == 6 || val.weekday == 7 ? false : true,
                context: context,
                firstDate: nowDay,
                //시작일
                lastDate: DateTime(nowDay.year + 1, nowDay.month, nowDay.day),
                //마지막일
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.dark(), //다크 테마
                    child: child!,
                  );
                },
              ).then((value) {
                setState(() {
                  widget.day = DateFormat('yy/MM/dd').format(value!);
                });
              });
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Icon(
                  Icons.calendar_month,
                  size: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(widget.day.isEmpty ? "희망  날짜" : widget.day,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white70,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(
                      color: Color.fromRGBO(0, 0, 0, 0.2), width: 3),
                  //모서리를 둥글게
                  borderRadius: BorderRadius.circular(10)),
              onPrimary: Colors.black,
              shadowColor: Colors.white70, //글자색
              //  minimumSize: Size(160, 25), //width, height
              //child 정렬 - 아래의 Text('$test')
              //alignment: Alignment.centerRight,
            ),
            //textStyle: const TextStyle(fontSize: 30)),
            onPressed: () {
              FocusScope.of(context).unfocus();
              _selectDate();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Icon(
                  Icons.more_time,
                  size: 25.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.selectedTime.isEmpty
                        ? "     희망   시간     "
                        : widget.selectedTime,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

DateTime isWeekend(DateTime now) {
  if (now.weekday == 6 || now.weekday == 7) {
    if (now.weekday == 6) return DateTime(now.year, now.month, now.day + 2);
    if (now.weekday == 7) return DateTime(now.year, now.month, now.day + 1);
  }
  return now;
}
