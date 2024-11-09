import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:witibju_1/util/main_toss.dart';
import 'package:witibju_1/util/wit_api_ut.dart';
import 'package:witibju_1/screens/seller/wit_seller_profile_detail_sc.dart';

class EstimateRequestDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EstimateRequestDetailState();
  }
}

class EstimateRequestDetailState extends State<EstimateRequestDetail> {
  Map estimateRequestInfoForSend = new Map<String, dynamic>();

  TextEditingController itemPrice1Controller = TextEditingController();
  TextEditingController itemPrice2Controller = TextEditingController();
  TextEditingController estimateContentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 견적리스트 조회
    getEstimateRequestInfoForSend();
  }

  @override
  Widget build(BuildContext context) {
    String estNo = estimateRequestInfoForSend['estNo'] ?? "";
    String aptName = estimateRequestInfoForSend['aptName'] ?? "고객 APT 정보 없음";
    String content = estimateRequestInfoForSend['content'] ?? "content 정보 없음";
    String itemImage = estimateRequestInfoForSend['itemImage'] ?? "itemImage 정보 없음";
    String itemName = estimateRequestInfoForSend['itemName'] ?? "itemName 정보 없음";
    String customerContent = estimateRequestInfoForSend['customerContent'] ?? "customerContent 정보 없음";
    String itemPrice1 = estimateRequestInfoForSend['itemPrice1'] ?? "itemPrice1 정보 없음";
    String itemPrice2= estimateRequestInfoForSend['itemPrice2'] ?? "itemPrice2 정보 없음";

    print("customerContent : " + customerContent);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leadingWidth: 90,
          leading: Container(
            height: double.infinity,
            child: Center(
              child: Text(
                "친절한 사장님",
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          title: Text("Profile"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.perm_identity)),
            IconButton(onPressed: () {}, icon: Icon(Icons.mail)),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.blue,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "고객 APT",
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded( // Expanded로 감싸서 공간을 차지하게 함
                        child: Text(
                          aptName,
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: Image.asset(
                          'assets/image/' + itemImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(  // Flexible로 감싸기
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              content,
                              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              itemName,
                              style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "고객님\n 추가 조건/\n요구사항",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(width: 35),
                      Expanded(
                        child: Text(
                          '',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("* 견적금액:", style: TextStyle(fontSize: 16)),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: itemPrice1Controller,
                          decoration: InputDecoration(
                            hintText: "금액을 입력하세요",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text("원", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Text(
                    "견적 추가 설명",
                    style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: estimateContentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '여기에 추가 설명을 입력하세요',
                        contentPadding: EdgeInsets.all(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "*업체 전화번호나 위치 설명 금지",
                    style: TextStyle(fontSize: 14, color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // 견적 보내기 로직
                        String sllrNo = estimateRequestInfoForSend['sllrNo'] ?? "";
                        String estNo = estimateRequestInfoForSend['estNo'] ?? "";
                        String estimateContent = estimateContentController.text;
                        String inputItemPrice1 = itemPrice1Controller.text;
                        //String inputItemPrice2 = itemPrice2Controller.text;
                        updateEstimateInfo(sllrNo, estNo, estimateContent, inputItemPrice1);
                      },
                      child: Text('견적보내기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 3, 199, 90),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // [서비스] 견적발송 용 데이터 조회
  Future<void> getEstimateRequestInfoForSend() async {
    // REST ID
    String restId = "getEstimateRequestInfoForSend";

    // PARAM
    final param = jsonEncode({

    });

    // API 호출 (견적발송 용 데이터 조회)
    final _estimateRequestInfoForSend = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      estimateRequestInfoForSend = _estimateRequestInfoForSend;
    });
  }

  // [서비스]견적 정보 저장
  Future<void> updateEstimateInfo(dynamic sllrNo, dynamic estNo, dynamic estimateContent, dynamic inputItemPrice1) async {
    // REST ID
    String restId = "updateEstimateInfo";

    String restId2 = "getCashInfo";

    int sllrNoInt = int.tryParse(sllrNo.toString()) ?? 0;

    // 1. 견적 발송 전 캐시 정보 조회
    final param2 = jsonEncode({
      "sllrNo": sllrNoInt,
    });

    // API 호출
    final response = await sendPostRequest(restId2, param2);

    // API 응답 처리
    if (response != null) {
      dynamic cashInfo = response;
      dynamic cash = cashInfo['cash'];

      int cashInt = int.tryParse(cash.toString()) ?? 0;

      if(cashInt == 0) {
        print("캐시가 부족합니다.");
        // 다이얼로그 표시
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          if (context.mounted) { // context가 유효한지 확인
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PointNotOKDialog();
              },
            );
          }
        });
      }
      else {
        print("캐시가 충븐합니다." + cashInt.toString());
        // 다이얼로그 표시
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          if (context.mounted) {
            String estNo = estimateRequestInfoForSend['estNo'] ?? "";
            String estimateContent = estimateContentController.text;
            String inputItemPrice1 = itemPrice1Controller.text;

            print("inputItemPrice1 : " + inputItemPrice1);

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PointOKDialog(
                  estNo: estNo,
                  estimateContent: estimateContent,
                  inputItemPrice1: inputItemPrice1,
                );
              },
            );
          }
        });
      }
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("캐시 조회가 실패하였습니다.")),
      );
    }
  }
}

class PointOKDialog extends StatelessWidget {
  final String estNo;
  final String estimateContent;
  final String inputItemPrice1;

  PointOKDialog({required this.estNo, required this.estimateContent, required this.inputItemPrice1});

  @override
  Widget build(BuildContext context) {
    print("estNo : " +  this.estNo);

    return AlertDialog(
      title: Text('캐시가 충분합니다.'),
      content: Text('*견적을 보내기 위해 캐시가 1200 차감됩니다.'),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // 초록색 배경
            foregroundColor: Colors.white, // 하얀색 글씨
          ),
          onPressed: () {
            // 충전 로직 추가
            // Navigator.of(context).pop(); // 다이얼로그 닫기
            //String estNo = estimateRequestInfoForSend['estNo'] ?? "";
            String estNo = this.estNo;
            String estimateContent = this.estimateContent;
            String inputItemPrice1 = this.inputItemPrice1;
            
            // 견적발송 당 차감 캐쉬도 정의 해야함
            String cash = "1200";

            //String inputItemPrice2 = itemPrice2Controller.text;
            updateEstimateInfo2(context, estNo, estimateContent, inputItemPrice1, cash);
            Navigator.of(context).pop();
            // 견적 보내기 후 SellerProfileDetail로 화면 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SellerProfileDetail(sllrNo: 17)),
            );
          },
          child: Text('보내기'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // 회색 배경
            foregroundColor: Colors.white, // 하얀색 글씨
          ),
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: Text('취소'),
        ),
      ],
    );
  }

  // [서비스]견적 정보 저장
  Future<void> updateEstimateInfo2(BuildContext context, dynamic estNo, dynamic estimateContent, dynamic inputItemPrice1
      , dynamic cash) async {
    // REST ID
    String restId = "updateEstimateInfo";

    print("estNo : " + estNo);
    print("inputItemPrice1 : " + inputItemPrice1);
    print("estimateContent : " + estimateContent);

    // PARAM
    final param = jsonEncode({
      "sllrNo": "17",
      "estNo": estNo,
      "customerContent": estimateContent,
      "itemPrice1": inputItemPrice1,
      "stat": "02", // 02 : 판매자가 견적발송
      "cash": cash,
      "cashGbn": "02", // 02 : 견적발송
    });

    // API 호출
    final response = await sendPostRequest(restId, param);

    // API 응답 처리
    if (response != null) {
      // 성공적으로 저장된 경우 처리
      _showSuccessDialog(context); // 다이얼로그 표시
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("견적이 성공적으로 발송되었습니다.")),
      );*/
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("견적 저장에 실패했습니다.")),
      );
    }
  }
  // 성공 다이얼로그를 표시하는 메서드
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('견적 발송 성공'),
          content: Text('견적이 정상적으로 발송되었습니다.'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // 초록색 배경
                foregroundColor: Colors.white, // 하얀색 글씨
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}


class PointNotOKDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('캐시가 부족합니다.'),
      content: Text('캐시를 충전하시겠습니까?'),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // 초록색 배경
            foregroundColor: Colors.white, // 하얀색 글씨
          ),
          onPressed: () {
            // 충전 로직 추가
            //Navigator.of(context).pop(); // 다이얼로그 닫기
            // 충전 다이얼로그 띄우기
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PointPurchaseDialog();
              },
            );
          },
          child: Text('캐시충전'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // 회색 배경
            foregroundColor: Colors.white, // 하얀색 글씨
          ),
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}

class PointPurchaseDialog extends StatefulWidget {
  @override
  _PointPurchaseDialogState createState() => _PointPurchaseDialogState();
}

class _PointPurchaseDialogState extends State<PointPurchaseDialog> {
  int? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('캐시충전으로 많은 견적서비스를 이용해보세요~',
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black
        ),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [3000, 5000, 10000, 30000, 50000, 100000].map((point) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPoint = point;
                  });
                },
                child: Container(
                  width: 100,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedPoint == point ? Colors.red : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('$point P'),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // 초록색 배경
            foregroundColor: Colors.white, // 하얀색 글씨
          ),
          onPressed: () {
            // 결제하기 로직 추가 및 Intro로 이동
            if (_selectedPoint != null) {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TosspaymentsSampleApp()),
              );
            } else {
              // 포인트가 선택되지 않은 경우 알림
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('구매할 포인트를 선택해주세요.')),
              );
            }
          },
          child: Text('결제하기'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey, // 회색 배경
            foregroundColor: Colors.white, // 하얀색 글씨
          ),
          onPressed: () {
            Navigator.of(context).pop(); // 다이얼로그 닫기
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}
