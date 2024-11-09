import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:witibju_1/screens/seller/wit_seller_estimaterequest_detail_sc.dart';

import '../../util/wit_api_ut.dart';

class EstimateRequestList extends StatefulWidget {
  final String stat; // stat을 멤버 변수로 추가

  EstimateRequestList(this.stat);

  @override
  State<StatefulWidget> createState() {
    return EstimateRequestListState();
  }
}

class EstimateRequestListState extends State<EstimateRequestList> {
  List<dynamic> estimateRequestList = [];

  @override
  void initState() {
    super.initState();
    // 견적리스트 조회
    getEstimateRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: estimateRequestList.map((request) {
          return buildEstimateItem(request, context);
        }).toList(),
      ),
    );
  }

  Widget buildEstimateItem(dynamic request, BuildContext context) {
    // 각 항목에 대한 내용 생성
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(request['estDt'], style: TextStyle(fontSize: 12, color: Colors.grey)), // 날짜
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    request['aptName'], // 아파트명
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 8), // 아파트명과 이름 사이의 간격
                  Text(
                    request['prsnName'], // 아파트명
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: request['stat'] == '견적요청'
                    ? Color.fromARGB(255, 3, 199, 90) // 초록색
                    : Colors.white70, // 회색
                surfaceTintColor: request['stat'] == '견적요청'
                    ? Color.fromARGB(255, 3, 199, 90) // 초록색
                    : Colors.white70, // 회색
                foregroundColor: request['stat'] == '견적요청'
                    ? Colors.white // 글씨 색상 흰색
                    : Colors.black, // 글씨 색상 검은색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(5), // 내부 여백을 0으로 설정
                minimumSize: Size(0, 30), // 최소 크기 설정 (가로: 0, 세로: 30)
              ),
              onPressed: request['stat'] == '견적요청'
                  ? () {
                // 견적 요청 관련 작업 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstimateRequestDetail()),
                );
              }
                  : null, // 상태가 아닐 경우 null로 설정하여 비활성화
              child: Text(
                request['stat'], // 견적 요청 상태
                style: TextStyle(fontSize: 12), // 텍스트 크기 12로 설정
              ),
            ),
          ],
        ),
        SizedBox(height: 1),
        Row(
          children: [
            // 사진과 방충망 텍스트
            Column(
              children: [
                Container(
                  width: 50,
                  height: 50, // 이미지 높이 설정
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                    child: Image.asset(
                      'assets/image/' + request['itemImage'] , // 광고 이미지 URL
                      fit: BoxFit.cover, // 이미지가 Container를 채우도록 설정
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        // 이미지 로드 실패 시 대체 텍스트 표시
                        return Center(child: Text('사진 로드 실패'));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 4), // 이미지와 텍스트 사이의 간격
                Text(
                  "방충망", // 이미지 아래에 표시할 텍스트
                  style: TextStyle(fontSize: 12, color: Colors.black), // 텍스트 스타일 설정
                ),
              ],
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 70, // 동일한 높이로 설정
                color: Colors.grey[200], // 연한 회색 배경색 설정
                padding: EdgeInsets.all(8), // 내부 여백 추가
                child: Center( // 텍스트를 중앙 정렬
                  child: Text(
                    request['content'], // 견적 요청 내용
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16), // 항목 간의 간격 추가
      ],
    );
  }

  // [서비스] 견적리스트 조회
  Future<void> getEstimateRequestList() async {
    // REST ID
    String restId = "getEstimateRequestList";

    print("stat: " + widget.stat);

    // PARAM
    final param = jsonEncode({
      "stat": widget.stat, // stat을 사용하여 API에 전달
    });

    // API 호출 (사전 점검 미완료 리스트 조회)
    final _estimateRequestList = await sendPostRequest(restId, param);

    // 결과 셋팅
    setState(() {
      estimateRequestList = _estimateRequestList;
    });
  }
}