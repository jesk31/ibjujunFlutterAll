import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../util/wit_api_ut.dart';

dynamic sllrNo;

class EstimateRequestAreaPop extends StatefulWidget {
  final dynamic sllrNo;
  const EstimateRequestAreaPop({Key? key, required this.sllrNo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EstimateRequestAreaPopState();
  }
}

class EstimateRequestAreaPopState extends State<EstimateRequestAreaPop> {
  // 초기 선택된 지역
  List<String> selectedRegions = [];

  // 선택 가능한 지역 목록
  List<String> regions = [
    '서울',
    '세종',
    '강원',
    '인천',
    '경기',
    '충북',
    '충남',
    '경북',
    '대전',
    '대구',
    '전북',
    '경남',
    '울산',
    '광주',
    '부산',
    '전남',
    '제주',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.0), // 다이얼로그 여백 설정
      child: Container(
        width: MediaQuery.of(context).size.width, // 화면의 전체 너비 사용
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('지역 선택', style: TextStyle(fontSize: 20)),
            ),
            Divider(),
            Expanded(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      children: regions.map((region) {
                        return CheckboxListTile(
                          title: Text(region),
                          value: selectedRegions.contains(region),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedRegions.add(region);
                              } else {
                                selectedRegions.remove(region);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    // 선택된 지역을 처리하는 로직
                    print('선택된 지역: $selectedRegions');
                    Navigator.of(context).pop(selectedRegions); // 선택된 지역 반환
                  },
                ),
                TextButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
