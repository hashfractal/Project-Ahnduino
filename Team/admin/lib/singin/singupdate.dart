//import 'package:flutter/cupertino.dart';
import 'package:ahnduino/Auto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MySetDayAndTimeWidget extends StatefulWidget {
  Function(DateTime) getDays;
  DateTime? settime;
  MySetDayAndTimeWidget(
      {Key? key, required this.getDays, required this.settime})
      : super(key: key);
  @override
  State<MySetDayAndTimeWidget> createState() => _MySetDayAndTimeWidgetState();
}

class _MySetDayAndTimeWidgetState extends State<MySetDayAndTimeWidget> {
  // _selectDate() async {
  //   DateTime? pickedDate = await showDialog<DateTime>(
  //     context: context,
  //     builder: (context) {
  //       DateTime? tempPickedDate;
  //       return AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //         content: SizedBox(
  //           height: 250,
  //           child: Column(
  //             children: <Widget>[
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: <Widget>[
  //                   CupertinoButton(
  //                     child: const Text('Cancel'),
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                   CupertinoButton(
  //                     child: const Text('Done'),
  //                     onPressed: () {
  //                       Navigator.of(context).pop(tempPickedDate);
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               const Divider(
  //                 height: 0,
  //                 thickness: 1,
  //               ),
  //               Expanded(
  //                 child: CupertinoDatePicker(
  //                   initialDateTime: DateTime(DateTime.now().year,
  //                       DateTime.now().month, DateTime.now().day, 9, 0),
  //                   minuteInterval: 10,
  //                   minimumDate: DateTime(DateTime.now().year,
  //                       DateTime.now().month, DateTime.now().day, 9, 0),
  //                   maximumDate: DateTime(DateTime.now().year,
  //                       DateTime.now().month, DateTime.now().day, 17, 50),
  //                   mode: CupertinoDatePickerMode.time,
  //                   onDateTimeChanged: (DateTime dateTime) {
  //                     tempPickedDate = dateTime;
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //   if (pickedDate != null &&
  //       DateFormat('aa hh 시 mm 분', 'ko').format(pickedDate) !=
  //           widget.selectedTime) {
  //     setState(() {
  //       widget.selectedTime =
  //           DateFormat('aa hh 시 mm 분', 'ko').format(pickedDate);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    KowananasLayoutInfo layoutInfo =
        KowananasLayoutInfo(MediaQuery.of(context));
    return KowanasLayout(
      data: layoutInfo,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: layoutInfo.getWidth(3)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
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
                var imsitime = DateTime.now().add(Duration(hours: 9));
                var nowDay =
                    DateTime(imsitime.year, imsitime.month, imsitime.day, 0, 0);
                showDatePicker(
                  initialDate: nowDay,
                  context: context,
                  firstDate: nowDay,
                  //시작일
                  lastDate: DateTime(
                      nowDay.year + 99, nowDay.month, nowDay.day, 0, 0),
                  //마지막일
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.dark(), //다크 테마
                      child: child!,
                    );
                  },
                ).then((value) {
                  setState(() {
                    widget.settime = value;
                    widget.getDays(widget.settime!);
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
                    padding: EdgeInsets.only(
                        left: layoutInfo.getWidth(23),
                        right: layoutInfo.getWidth(23),
                        top: layoutInfo.getHeight(1.2),
                        bottom: layoutInfo.getHeight(1.2)),
                    child: Text(
                        widget.settime == null
                            ? "계약 만료일"
                            : DateFormat('yy/MM/dd/').format(widget.settime!),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0)),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10.0),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.white70,
          //       shape: RoundedRectangleBorder(
          //           side: const BorderSide(
          //               color: Color.fromRGBO(0, 0, 0, 0.2), width: 3),
          //           //모서리를 둥글게
          //           borderRadius: BorderRadius.circular(10)),
          //       onPrimary: Colors.black,
          //       shadowColor: Colors.white70, //글자색
          //  minimumSize: Size(160, 25), //width, height
          //child 정렬 - 아래의 Text('$test')
          //alignment: Alignment.centerRight,
          // ),
          //textStyle: const TextStyle(fontSize: 30)),
          //     onPressed: () {
          //       _selectDate();
          //     },
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         const Icon(
          //           Icons.more_time,
          //           size: 25.0,
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(left: 8.0),
          //           child: Text(
          //             widget.selectedTime.isEmpty
          //                 ? "     희망   시간     "
          //                 : widget.selectedTime,
          //             style: const TextStyle(
          //                 fontWeight: FontWeight.bold, fontSize: 18.0),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

// DateTime isWeekend(DateTime now) {
//   if (now.weekday == 6 || now.weekday == 7) {
//     if (now.weekday == 6) return DateTime(now.year, now.month, now.day + 2);
//     if (now.weekday == 7) return DateTime(now.year, now.month, now.day + 1);
//   }
//   return now;
// }
