import 'package:ahnduino/singin/privacy.dart';
import 'package:flutter/material.dart';

class service extends StatefulWidget {
  const service({Key? key}) : super(key: key);
  @override
  _service createState() => _service();
}

class _service extends State<service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 20, right: 10),
          child: Column(children: [
            Row(
              children: [
                Text(
                  '도와줘 홈즈! 이용 약관',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 130),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => privacy()),
                          (route) => false);
                    },
                    icon: Icon(Icons.close),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Text(
                    '도와줘 홈즈! 이용 약관내용',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text:
                              '여러분을 환영합니다. 도와줘 홈즈!와 함께 간편하고 편리한 주택관리를 경험해보세요.',
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text: '1. 간편한 수리요청',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text:
                              '- 도와줘 홈즈!의 수리요청 기능을 통해 편안한 수리요청을 해보세요.\n 수리요청으로 인해 개인정보를 사용할 수 있습니다',
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text: '2. 입주 사진 및 주택 사진 열람',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text:
                              '- 도와줘 홈즈!의 입주사진 및 사진 열람 기능을 통해 퇴실 이나 여러가지 문제에 증빙 자료로 사용하실 수 있습니다. 단 입주사진을 등록시 수정이 불가능합니다.',
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text: '3. 게시판 공지',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text:
                              '- 도와줘 홈즈!의 게시판 기능을 통해 공지사항이나 여러가지 공통적인 문제를 해결하실 수 있습니다.',
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text: '3. 채팅',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 100,
                      text: TextSpan(
                          text:
                              '- 도와줘 홈즈!의 채팅 기능을 통해 오전 9:00 ~ 오후 6:00시까지 실시간으로 상담을 받을 수 있으며 그 시간 이후에는 챗봇을 통해 궁금한 점을 해결 하실 수 있습니다. 단 채팅으로 폭언,성희롱적 발언은 금지하고 있으며 추후에 문제가 생길시 법적 근거자료가 될 수 있음을 알려드립니다.',
                          style: TextStyle(color: Colors.black, fontSize: 17)),
                    ))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
