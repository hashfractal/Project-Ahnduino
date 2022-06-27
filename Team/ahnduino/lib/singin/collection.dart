import 'package:ahnduino/singin/privacy.dart';
import 'package:flutter/material.dart';

class collection extends StatefulWidget {
  const collection({Key? key}) : super(key: key);
  @override
  _collection createState() => _collection();
}

class _collection extends State<collection> {
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
                  '개인정보 수집 이용 약관',
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
                    '개인정보 수집 이용 동의서',
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
                              '도와줘홈즈!는 「개인정보보호법」에 의거하여, 아래와 같은 내용으로 개인정보를 수집하고 있습니다.귀하께서는 아래 내용을 자세히 읽어 보시고, 모든 내용을 이해하신 후에 동의 여부를 결정해 주시기 바랍니다.',
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
                          text: '1. 개인정보의 수집 및 이용 동의서',
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
                              '- 이용자가 제공한 모든 정보는 다음의 목적을 위해 활용하며, 하기 목적 이외의 용도로는 사용되지 않습니다',
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
                      maxLines: 50,
                      text: TextSpan(
                          text:
                              '1. 개인정보 수집 항목 및 수집·이용 목적\n가) 수집 항목 (필수항목)- 성명(국문),  주소, 전화번호(휴대전화), 이메일 등 회원가입에 기재된 정보 또는 신청자가 제공한 정보\n나) 수집 및 이용 목적- 신속한 정보를 확인하여 사용자에게 보다 빠르게 업무처리를 하기 위함\n 2.개인정보 보유 및 이용기간- 수집·이용 동의일로부터 개인정보의 수집·이용목적을 달성할 때까지\n 3동의거부관리- 귀하께서는 본 안내에 따른 개인정보 수집, 이용에 대하여 동의를 거부하실 권리가 있습니다. 다만,귀하가 개인정보의 수집/이용에 동의를 거부하시는 경우에 도와줘홈즈!를 사용하실 수 없음을 알려드립니다.',
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
