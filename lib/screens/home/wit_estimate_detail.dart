import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:witibju_1/screens/home/widgets/wit_home_widgets.dart';
import 'package:witibju_1/screens/home/wit_home_theme.dart';

import '../../util/wit_api_ut.dart';
import 'models/requestInfo.dart';
import 'wit_estimate_notice.dart'; // 알림 화면 연결

/// 견적화면
class EstimateScreen extends StatefulWidget {
  @override
  State<EstimateScreen> createState() => _EstimateScreenState();
}

class _EstimateScreenState extends State<EstimateScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<RequestInfo> requestList = [];
  RequestInfo? _selectedRequest; // 선택된 요청 정보를 저장할 변수 추가

  // formatCurrency 함수 추가
  String formatCurrency(String amount) {
    if (amount.isEmpty || amount == "-") {
      return "-";
    }

    // 금액을 정수로 변환한 후 3자리마다 콤마를 찍음
    final formatter = NumberFormat('#,###');
    int intAmount = int.parse(amount);
    return formatter.format(intAmount);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // 회사 목록 조회
    getRequestList('72091587');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('견적 요청 화면'),
      ),
      body: Column(
        children: [
          // 광고 영역
          Container(
            height: 200, // 높이를 고정하여 Overflow 방지
            child: ImageBox(),
          ),
          SizedBox(height: 16.0),

          // 견적 및 알림 탭
          WitHomeWidgets.getTabBarUI(_tabController, ['견적', '알림']),

          // 탭 내용
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 8.0),
                      ..._buildReqNoSections(),
                    ],
                  ),
                ),
                WitEstimateNoticeScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReqNoSections() {
    Map<String, List<RequestInfo>> reqNoGroupedRequests = {};

    for (var request in requestList) {
      String reqNo = request.reqNo;
      if (!reqNoGroupedRequests.containsKey(reqNo)) {
        reqNoGroupedRequests[reqNo] = [];
      }
      reqNoGroupedRequests[reqNo]!.add(request);
    }

    List<Widget> sectionWidgets = [];
    reqNoGroupedRequests.forEach((reqNo, requests) {
      Map<String, List<RequestInfo>> categoryGroupedRequests = {};
      for (var request in requests) {
        String categoryId = request.categoryId;
        if (!categoryGroupedRequests.containsKey(categoryId)) {
          categoryGroupedRequests[categoryId] = [];
        }
        categoryGroupedRequests[categoryId]!.add(request);
      }

      sectionWidgets.add(
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '요청 번호: $reqNo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${requests.first.timeAgo} 요청 견적',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              for (var entry in categoryGroupedRequests.entries) ...[
                SectionWidget(
                  title: '${entry.value.first.categoryNm} (${entry.value.length}건)',
                  items: entry.value.map((request) {
                    return ListItem(
                      company: request.companyNm,
                      time: request.reqDate,
                      rate: request.rate,
                      content: request.reqContents,
                      reqDateInfo: request.reqDateInfo,
                      reqState: request.reqState,
                      reqStateNm: request.reqStateNm,
                      estimateAmount: request.estimateAmount,
                    );
                  }).toList(),
                  onTap: () {
                    _showDetailPopup(context, entry.value);
                  },
                ),
                SizedBox(height: 8.0),
              ],
            ],
          ),
        ),
      );
    });

    return sectionWidgets;
  }

  void _showDetailPopup(BuildContext context, List<RequestInfo> requests) {
    setState(() {
      _selectedRequest = requests.first; // 첫 번째 요청을 기본 선택값으로 설정
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: Text("총 받은 견적 ${requests.length}개"),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                      padding: const EdgeInsets.all(13.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: requests.length,
                        itemBuilder: (BuildContext context, int index) {
                          final request = requests[index];
                          final isSelected = _selectedRequest == request; // 선택된 요청이 있는지 확인
                          String companyName = request.companyNm.length > 8
                              ? request.companyNm.substring(0, 8) + '...'
                              : request.companyNm;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRequest = request; // 선택된 요청을 업데이트
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0), // 모서리를 더 둥글게 설정
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    companyName,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // 선택된 항목은 볼드 처리
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    request.estimateAmount.isEmpty || request.estimateAmount == "-"
                                        ? '견적 금액: -'
                                        : '견적 금액: ${formatCurrency(request.estimateAmount)} 원',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // 선택된 항목은 볼드 처리
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(thickness: 1), // 구분선 추가
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          // 선택된 요청의 상세 정보 표시
                          child: _buildRequestDetail(_selectedRequest ?? requests.first),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

///팝업 하단
  Widget _buildRequestDetail(RequestInfo request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${request.companyNm}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4.0),
            Image.asset(
              'assets/images/star.png',
              width: 16.0,
              height: 16.0,
            ),
            SizedBox(width: 4.0),
            Text('${request.rate} ', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            Expanded(
              child: Container(), // 오른쪽으로 텍스트 밀기
            ),
            GestureDetector(
              onTap: request.reqState == '02'
                  ? () {
                _showConfirmationDialog(
                    context,
                    request.companyNm,
                    request.estimateAmount,
                    request.rate,
                    request.reqNo,
                    request.seq,
                    '72091587');
              }
                  : null,
              child: Text(
                '${request.reqStateNm}',
                style: TextStyle(
                  fontSize: 14,
                  color: request.reqState != '02' ? Colors.grey : Colors.blue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Text(
          request.estimateAmount.isEmpty || request.estimateAmount == "-"
              ? '견적 금액: -'
              : '견적 금액: ${formatCurrency(request.estimateAmount)} 원',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            request.reqContents,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String companyNm, String estimateAmount, String rate,String reqNo, String seq, String reqUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("작업 요청"),
          content: RichText(
            text: TextSpan(
              text: companyNm,
              style: TextStyle(fontSize: 14, color: Colors.blue),
              children: <TextSpan>[
                TextSpan(
                  text: ' 업체에 작업을 요청할까요?',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await updateRequestState(reqNo, seq, reqUser);
                Navigator.of(context).pop();
              },
              child: Text("보내기"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("취소"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateRequestState(String reqNo, String seq, String reqUser) async {
    String restId = "updateRequestState";
    final param = jsonEncode({
      "reqNo": reqNo,
      "seq": seq,
      "reqUser": reqUser,
      "reqState": '03'
    });

    try {
      final response = await sendPostRequest(restId, param);
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('작업 요청을 완료했습니다.')),
        );
        await getRequestList('72091587');
        Navigator.of(context).pop();
      } else {
        print("요청 상태 업데이트 실패: ${response['message']}");
      }
    } catch (e) {
      print('요청 상태 업데이트 중 오류 발생: $e');
    }
  }

  Future<void> getRequestList(String reqUserNo) async {
    String restId = "getRequestList";

    final param = jsonEncode({"reqUser": reqUserNo});
    try {
      final _requestList = await sendPostRequest(restId, param);
      setState(() {
        requestList = RequestInfo().parseRequestList(_requestList) ?? [];
      });
    } catch (e) {
      print('신청 목록 조회 중 오류 발생: $e');
    }
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final List<ListItem> items;
  final VoidCallback onTap;

  const SectionWidget({required this.title, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    return GestureDetector(
      onTap: () {
        print('SectionWidget tapped');
        onTap();
      },
      child: Container(
        width: width,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            for (var item in items) ...[
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text('- ${item.company}', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 4.0),
                  Image.asset(
                    'assets/images/star.png',
                    width: 16.0,
                    height: 16.0,
                  ),
                  SizedBox(width: 4.0),
                  Text('${item.rate} ', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 4.0),
              Text(item.content, style: TextStyle(color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}

class ListItem {
  final String company;
  final String time;
  final String rate;
  final String content;
  final String reqDateInfo;
  final String reqState;
  final String reqStateNm;
  final String estimateAmount;

  ListItem({
    required this.company,
    required this.time,
    required this.rate,
    required this.content,
    required this.reqDateInfo,
    required this.reqState,
    required this.reqStateNm,
    required this.estimateAmount,
  });
}
