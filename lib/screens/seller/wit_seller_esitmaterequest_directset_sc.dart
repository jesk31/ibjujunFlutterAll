import 'dart:convert';

import 'package:witibju_1/screens/seller/wit_seller_cash_recharge_sc.dart';
import 'package:witibju_1/screens/seller/wit_seller_esitmaterequest_areapop_sc.dart';
import 'package:witibju_1/screens/seller/wit_seller_esitmaterequest_contentpop_sc.dart';
import 'package:witibju_1/screens/seller/wit_seller_esitmaterequest_extimepop_sc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/wit_api_ut.dart';

dynamic sllrNo;

class EstimateRequestDirect extends StatefulWidget {
  final dynamic sllrNo;
  const EstimateRequestDirect({Key? key, required this.sllrNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EstimateRequestDirectState();
  }
}

class EstimateRequestDirectState extends State<EstimateRequestDirect> {
  dynamic sellerInfo;
  String storeName = "";
  Map cashInfo = {};
  List<dynamic> autoEstimateList = [];
  String selectedRegionSubtitle = '선택된 지역 없음'; // 상태 변수 추가
  String estimateDescription = '서울시에서 제일 잘하는 집...'; // 견적 설명 상태 변수
  String? excludedStartTime; // 견적 발송 제외 시작 시간
  String? excludedEndTime;   // 견적 발송 제외 종료 시간

  int _sliderIndex = 0; // 슬라이더의 인덱스 초기값
  final List<dynamic> _values = [
    16000,
    24000,
    31000,
    60000,
    92000,
    150000,
    420000,
    600000,
    1000000,
  ];

  final List<dynamic> _sendCounts = [
  5,
  8,
  10,
  20,
  30,
  50,
  141,
  202,
  336,
  ];

  @override
  void initState() {
    super.initState();
    getSellerInfo(widget.sllrNo);
    getCashInfo();
    getAutoEstimateList(widget.sllrNo);
  }

  Future<void> getSellerInfo(dynamic sllrNo) async {

    String restId = "getSellerInfo";
    // PARAM
    final param = jsonEncode({
      "sllrNo": sllrNo,
    });

    print("sllrNo :" + sllrNo.toString());

    // API 호출
    final response = await sendPostRequest(restId, param);

    if (response != null) {
      setState(() {
        sellerInfo = response;
        storeName = sellerInfo['storeName'];
        print('Store Name: $storeName');
      });
    } else {
      // 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사업자 프로필 조회가 실패하였습니다.")),
      );
    }
  }

  Future<void> getCashInfo() async {
    // REST ID
    String restId = "getCashInfo";

    // PARAM
    final param = jsonEncode({
      "sllrNo": "17",
    });

    // API 호출 (사전 점검 미완료 리스트 조회)
    final _cashInfo = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      cashInfo = _cashInfo;
    });
  }

  // [서비스] 바로 견적리스트 조회
  Future<void> getAutoEstimateList(dynamic sllrNo) async {
    // REST ID
    String restId = "getAutoEstimateList";

    // PARAM
    final param = jsonEncode({
      "sllrNo": widget.sllrNo, // stat을 사용하여 API에 전달
    });

    // API 호출 (사전 점검 미완료 리스트 조회)
    final _autoEstimateList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      autoEstimateList = _autoEstimateList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: Container(
            height: double.infinity,
            child: Center(child: Text(storeName, style: TextStyle(fontSize: 15, color: Colors.black), textAlign: TextAlign.center))),
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.perm_identity)),
          IconButton(onPressed: () {}, icon: Icon(Icons.mail))
        ],
      ),
      body: SingleChildScrollView(  // 추가된 부분
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    color: Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text("IBJU", style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        cashInfo['cash'] != null ? '${NumberFormat('#,###').format(int.parse(cashInfo['cash']))} C' : '0 C',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CashRecharge(sllrNo: 17)),
                );
              },
              child: Text('충전하러가기 >>'),
            ),
            Divider(),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0), // 카드 간격
              elevation: 4, // 카드 그림자
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 카드 내부 여백
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                  children: [
                    Text('* 이번주 견적 발송 고객', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    ...autoEstimateList.map((estimate) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0), // 항목 간 간격
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 정렬
                              children: [
                                Expanded(
                                  child: Text(
                                    estimate['itemName'] ?? '품목명 없음',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // 강조된 품목명
                                  ),
                                ),
                                SizedBox(width: 10), // itemName과 estDt 사이의 간격
                                Text(
                                  estimate['estDt'] ?? '시간 없음',
                                  style: TextStyle(fontSize: 16, color: Colors.blueGrey), // 시간 표시 스타일
                                ),
                              ],
                            ),
                            SizedBox(height: 4), // itemName과 prsnName 사이의 간격
                            Text(
                              (estimate['prsnName'] ?? '요청자 없음') + '님 ' + (estimate['autoYn'] ?? ''),
                              style: TextStyle(fontSize: 14, color: Colors.grey), // 요청자 이름 스타일
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('| 바로견적', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildEstimateProgress(),
            SizedBox(height: 16),
            _buildDetailItem('서비스 지역', isLink: true),
            _buildDetailItem('견적 설명', isLink: true),
            _buildDetailItem('견적발송 제외시간', isLink: true),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {

                  },
                  child: Text('수정하기'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // 취소 버튼 로직
                  },
                  child: Text('취소'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, {bool isLink = false}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0), // 카드 간격
      elevation: 4, // 그림자 효과
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          title == '견적 설명'
              ? estimateDescription
              : (title == '견적발송 제외시간'
              ? (excludedStartTime == '설정 없음' && excludedEndTime == '설정 없음'
              ? '설정 없음'
              : '${excludedStartTime ?? '설정 없음'} ~ ${excludedEndTime ?? '설정 없음'}')
              : selectedRegionSubtitle),
        ),
        trailing: isLink ? Icon(Icons.arrow_forward) : null,
        onTap: isLink ? () {
          if (title == '견적 설명') {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                return EstimateRequestContentPop(sllrNo: 17);
              },
            ).then((description) {
              if (description != null && description.isNotEmpty) {
                setState(() {
                  estimateDescription = description; // 상태 변수 업데이트
                });
              }
            });
          } else if (title == '서비스 지역') {
            showDialog<List<String>>(
              context: context,
              builder: (BuildContext context) {
                return EstimateRequestAreaPop(sllrNo: 17);
              },
            ).then((selectedRegions) {
              if (selectedRegions != null && selectedRegions.isNotEmpty) {
                setState(() {
                  selectedRegionSubtitle = selectedRegions.join(', '); // 상태 변수 업데이트
                });
              }
            });
          } else if (title == '견적발송 제외시간') {
            showDialog<Map<String, String>>(
              context: context,
              builder: (BuildContext context) {
                return EstimateRequestExTimePop(sllrNo: 17);
              },
            ).then((result) {
              if (result != null) {
                String selectedStartTime = result['startTime'] ?? '설정 없음';
                String selectedEndTime = result['endTime'] ?? '설정 없음';

                // 선택한 시간을 모 화면에서 사용
                print('선택한 시작 시간: $selectedStartTime');
                print('선택한 종료 시간: $selectedEndTime');

                setState(() {
                  excludedStartTime = selectedStartTime;
                  excludedEndTime = selectedEndTime;
                });
              }
            });
          }
        } : null,
      ),
    );
  }

  Widget _buildEstimateProgress() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16.0), // 카드 간격
      elevation: 4, // 그림자 효과
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 카드 내부 여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('일일 견적 예상', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${_sendCounts[_sliderIndex]} 회 발송가능', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 12),
            Slider(
              value: _sliderIndex.toDouble(),
              min: 0,
              max: (_values.length - 1).toDouble(),
              divisions: _values.length - 1, // 리스트의 길이 - 1
              label: '${_values[_sliderIndex]} C', // 현재 선택된 값 표시
              onChanged: (double value) {
                setState(() {
                  _sliderIndex = value.round(); // 슬라이더의 인덱스 업데이트
                });
              },
              activeColor: Colors.lightBlue, // 활성화 된 슬라이더 색상
              inactiveColor: Colors.grey, // 비활성화 된 슬라이더 색상
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_values[0].toInt()} C', style: TextStyle(fontSize: 14)), // 첫 번째 금액
                Text('${_values[_sliderIndex].toInt()} C', style: TextStyle(fontSize: 14)), // 현재 선택된 금액
                Text('${_values.last.toInt()} C', style: TextStyle(fontSize: 14)), // 마지막 금액
              ],
            ),
          ],
        ),
      ),
    );
  }
}
