import 'package:ahnduino/singin/privacy.dart';
import 'package:flutter/material.dart';

class finance extends StatefulWidget {
  const finance({Key? key}) : super(key: key);
  @override
  _finance createState() => _finance();
}

class _finance extends State<finance> {
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
                  '전자 금융거래 기본약관',
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
                    '전자금융거래 이용에 관한 기본약관',
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
                      maxLines: 50,
                      text: TextSpan(
                          text:
                              '제1조(목적) 이 약관은 (주)부트페이(이하 “회사”라 한다)가 제공하는 전자금융거래에 대한 기본적인 사항을 정함으로써 전자금융거래를 이용하고자 하는 이용자와 회사간의 권리.의무 관계를 명확하게 정함을 목적으로 한다.',
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
                          text: '제2조(정의)',
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
                          text: '1. 이 약관에서 사용하는 용어의 정의는 다음과 같다.',
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
                              '1. “전자금융거래”란 회사가 전자적 장치를 통하여 금융상품 및 서비스를 제공하고 고객이 회사와 직접 대면하거나 의사소통을 하지 아니하고 자동화된 방식으로 이를 이용하는 거래를 말한다.\n2. “고객”이란 전자금융거래를 위하여 회사와 체결한 계약(이하 “전자금융거래계약“이라 한다)에 따라 전자금융거래를 이용하는 자를 말한다.\n3. “전자지급거래”란 자금을 주는 자(이하 “지급인”이라 한다)가 회사로 하여금 전자지급수단을 이용하여 자금을 받는 자(이하 “수취인”이라 한다)에게 자금을 이동하게 하는 전자금융거래를 말한다.\n4. “전자적 장치”란 전자금융 거래정보를 전자적 방법으로 전송하거나 처리하는데 이용되는 장치로서 현금자동지급기, 자동입출금기, 지급용단말기, 컴퓨터, 전화기 그 밖에 전자적 방법으로 정보를 전송하거나 처리하는 장치를 말한다.\n5. “전자문서”란 전자거래기본법 제2조제1호에 따른 작성, 송신․수신 또는 저장된 정보를 말한다.\n6. “접근매체”란 전자금융거래에 있어서 고객이 거래지시를 하거나 또는 고객 및 거래내용의 진실성과 정확성을 확보하기 위하여 사용되는 다음 각 목의 어느 하나에 해당하는 수단 또는 정보를 말한다.\n가. 전자식 카드 및 이에 준하는 전자적 정보\n나. 전자서명법 제2조 제4호의 전자서명생성정보 및 같은 조 제7호의 인증서\n다. 회사에 등록된 고객번호\n라. 고객의 생체정보\n마. 가목 또는 나목의 수단이나 정보를 사용하는데 필요한 비밀번호\n7. “전자지급수단”이란 전자자금이체, 직불전자지급수단, 선불전자지급수단, 전자화폐, 신용카드, 전자채권 그 밖의 전자적 방법에 따른 지급수단을 말한다.\n8. “전자자금이체”란 지급인과 수취인 사이에 자금을 지급할 목적으로 회사에 개설된 계좌에서 다른 계좌로 전자적 장치에 의하여 다음 각 목의 어느 하나에 해당하는 방법으로 자금을 이체하는 것을 말한다.\n가. 회사에 대한 지급인의 지급지시\n나. 회사에 대한 수취인의 추심지시(이하 “추심이체”라 한다)\n9. “거래지시”란 고객이 전자금융거래계약에 따라 회사에 전자금융거래의 처리를 지시하는 것을 말한다.\n10. “오류”란 고객의 고의 또는 과실 없이 전자금융거래가 전자금융거래계약 또는 고객의 거래지시에 따라 이행되지 아니한 경우를 말한다.\n11. “개별약관”이란 이 약관과 함께 전자금융거래에 적용되는 약관으로서 회사가 별도로 작성한 약관을 말한다.\n2.이 약관에서 별도로 정하지 아니한 용어의 정의는 전자금융거래법 및 전자금융거래법 시행령, 금융감독위원회의 전자금융감독규정 및 전자금융감독규정 시행세칙에서 정하는 바에 따른다.',
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
